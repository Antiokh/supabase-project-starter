# Supabase DB Versioning Runbook

This runbook covers the smallest recovery path that should exist in every project using the starter's DB function versioning module.

## Read This With

- `SUPABASE_DB_VERSIONING_GUIDE.md`
- `SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`

## First Principle

Do not invent ad hoc fixes in the middle of an incident.

Use these steps:

1. inspect queue state
2. inspect dead items
3. requeue dead items if the publication boundary is healthy again
4. process a limited batch
5. verify queue convergence

## Quick Checks

Queue summary:

```sql
select *
from archive.github_push_queue_summary();
```

Recent dead items:

```sql
select *
from archive.get_github_push_queue_dead_items(20);
```

Process a small batch immediately:

```sql
select archive.process_github_push_queue(10);
```

## Common Cases

### GitHub or network outage is over

Requeue dead items and immediately retry a small batch:

```sql
select archive.retry_dead_github_push_queue(100, 20);
```

Then verify:

```sql
select *
from archive.github_push_queue_summary();
```

### Bootstrap finished only partially

If bootstrap inserted queue rows but publication failed mid-run:

1. inspect dead items
2. requeue dead items
3. process a limited batch

If bootstrap was never run for the schema at all:

```sql
select archive.bootstrap_functions_to_github('public', 20);
```

Do not run bootstrap repeatedly as a blind retry loop.

The queue deduplicates by `function_history_id`, so repeated bootstrap is usually harmless, but it hides the real operational problem.

### Incremental sync stopped pushing updates

Check:

```sql
select *
from archive.github_push_queue_summary();
```

Then:

1. if only `pending` grows, inspect the publication boundary and rerun `archive.process_github_push_queue(...)`
2. if `dead` grows, inspect dead items and requeue after the underlying issue is fixed
3. if neither grows, inspect the upstream `archive.update_functions(...)` flow

## What Usually Went Wrong

Most failures should be traced to one of these boundaries:

- `public.call_edge_function(...)` configuration
- `github-send` Edge Function runtime failure
- GitHub token, repo, branch, or path configuration
- temporary outbound network failure

Do not start by editing `archive.function_history`.

That table is version history, not a retry queue.

## Manual Recovery Rule

Prefer updating queue status over deleting queue rows.

Deleting rows throws away evidence:

- `try_count`
- `last_error`
- timing

Use the starter recovery helpers instead:

```sql
select archive.requeue_dead_github_push_queue(100);
select archive.process_github_push_queue(20);
```

## Escalation Cases

Escalate from queue recovery to install/runtime investigation when:

- `dead` items immediately return after requeue
- `github-send` fails for every row
- `public.call_edge_function(...)` cannot reach the Edge Function boundary
- local, cloud, and self-hosted environments behave differently

At that point, inspect:

- project env and secrets
- Edge Function logs
- self-hosted outbound connectivity
- extension installation state
