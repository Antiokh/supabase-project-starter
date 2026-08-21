# Supabase DB Versioning Guide

This guide defines the starter's database-side code versioning model.

It is focused on SQL functions as code, not on the full schema snapshot.

## Mission

The starter should support a repeatable workflow where:

1. SQL functions live in the database
2. function changes are detected from actual DB source code
3. changed functions are versioned in DB history
4. changed functions can be pushed to Git automatically
5. failures can be retried without guessing what happened

## Scope

This guide covers:

- function history
- change detection
- queue-based Git publication
- bootstrap flow
- cron flow
- recovery flow
- relationship to schema snapshot export

## Important Distinction

There are two separate workflows in this starter:

1. versioning SQL functions as code
2. exporting a broader schema snapshot or DDL artifact

They are related, but they are not the same thing.

The function versioning workflow answers:

- which function source changed
- what is the latest active function body
- what needs to be pushed to Git

The schema export workflow answers:

- what the broader schema currently looks like
- what tables, views, functions, policies, triggers, and indexes exist

Do not collapse these into one mechanism.

## Recommended Architecture

The starter uses a layered approach.

### 1. Extension layer

The baseline history capability comes from:

- `dbdev`
- `mansueli-function_vc`

This provides the initial `archive.function_history` foundation.

### 2. Custom history layer

The starter adds its own functions on top of the extension-provided tables and logic.

Key responsibilities:

- mark one version as active
- compare previous and current source code
- create a new history row only when code actually changed
- support bootstrap and incremental refresh flows

### 3. Queue layer

Changed functions are not pushed to Git directly from every update path.

Instead:

- changed function history rows are enqueued
- queue processing is retried safely
- dead items are visible for manual recovery

### 4. Publication layer

Publication is done through an Edge Function, not by embedding GitHub-specific logic directly into every SQL path.

This keeps the Git API integration in one place.

## Repository Placement Rule

The versioning module is starter source.

It should live outside the runtime `supabase/` scaffold so it does not get confused with:

- generated SQL snapshots
- project-owned SQL synced from a database
- future exported schema artifacts

In this starter, the versioning module belongs under:

- `docs/templates/db-function-versioning/`

Repository-level edit rules are documented separately in:

- `SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`

## Core Database Objects

The reusable versioning module is expected to provide these objects.

### History and comparison

- `archive.save_function_history`
- `archive.update_function_history`
- `archive.update_functions`
- `archive.diff_text`

### Queue and publication

- `archive.github_push_queue`
- `archive.process_github_push_queue`
- `archive.github_send_function`
- `archive.push_updated_functions_to_github`
- `archive.bootstrap_functions_to_github`
- `archive.push`

### Optional support objects

- helper views over active versions
- compacting or cleanup helpers
- diagnostics helpers

## Normal Workflow

The normal update flow should look like this.

1. A SQL function is created or changed in the database.
2. The sync process scans functions for a schema.
3. `archive.update_function_history` compares the current source with the latest stored source.
4. If the code changed, a new active history row is created.
5. The changed function history row is added to `archive.github_push_queue`.
6. Queue processing invokes the Git publication Edge Function.
7. The queue row is marked `done`, retried, or marked `dead`.

## Bootstrap Workflow

Bootstrap is separate from incremental updates.

Bootstrap is used when:

- versioning is being enabled for an existing project
- a schema already contains many functions
- Git history for DB functions needs an initial snapshot

Expected bootstrap flow:

1. install required extensions
2. initialize history for the target schema
3. enqueue all currently active function versions
4. process an initial batch immediately

The starter should provide a helper function for this, such as:

- `archive.bootstrap_functions_to_github(...)`

## Incremental Workflow

Incremental sync is used for ongoing operation after bootstrap.

Expected flow:

1. scan the target schema
2. detect only changed functions
3. enqueue changed rows
4. process some queue items immediately
5. let cron or scheduled jobs continue draining the queue

The starter should provide a helper function for this, such as:

- `archive.push_updated_functions_to_github(...)`

## Queue Model

The queue exists to make Git publication more operationally safe.

Recommended fields:

- queue row id
- `function_history_id`
- `status`
- `try_count`
- `last_error`
- `created_at`
- `pushed_at`

Recommended statuses:

- `pending`
- `done`
- `dead`

Recommended behavior:

- retry failed items a limited number of times
- use `FOR UPDATE SKIP LOCKED` during processing
- keep the final error text for recovery

## Cron Model

The starter should assume two kinds of scheduled work.

### 1. Incremental SQL function publication

Example intent:

- periodically scan for changed functions
- enqueue changes
- process part of the queue

### 2. Queue draining / retry processing

Example intent:

- periodically retry pending queue items
- cleanly converge after temporary GitHub or network failures

Keep the cron model small and explicit.

Do not create a maze of overlapping scheduled jobs unless there is a strong reason.

The cron entrypoint templates live here:

- `docs/templates/db-function-versioning/50_cron/`

## Publication Boundary

The database should not try to become a full GitHub client.

Instead, the publication boundary should be:

- SQL prepares structured payload
- SQL calls an Edge Function
- Edge Function handles GitHub API formatting and authentication

This separation is important for:

- secret handling
- API changes
- logging
- retry behavior
- future provider changes

In practice, the DB-side boundary is often a small helper such as:

- `public.call_edge_function(function_path, payload)`

That helper belongs to project-owned runtime SQL, not to the starter template module itself.

## Source-Of-Truth Rules

The versioning module must make the source-of-truth policy explicit.

Recommended policy:

- the live database is the source of truth for current function bodies
- `archive.function_history` is the source of truth for version records
- Git is the publication target for readable version-controlled SQL artifacts
- generated export files should not be treated as hand-edited source

If the repository also stores synced SQL snapshots, those files should be clearly marked:

- generated
- grouped
- read-only

By contrast, small runtime support SQL such as `debug_events` or `call_edge_function` can live in `supabase/sql/` as hand-maintained project SQL.

## Relationship To Schema Export

The starter should support a broader schema export flow, but that is not the same system as function history.

Function versioning is optimized for:

- change detection
- per-function history
- operational Git publication

Schema export is optimized for:

- whole-schema understanding
- architecture analysis
- DDL snapshots

The schema export may include functions, but that does not replace function history.

## Operational Recovery

The starter should document recovery procedures for at least these cases:

- queue items stuck in `pending`
- queue items marked `dead`
- GitHub publication failure
- initial bootstrap only partially completed
- extension installation failure

Minimum recovery tools should include:

- a way to inspect dead items
- a way to requeue dead items
- a way to re-run immediate queue processing

The starter runbook for this lives in:

- `SUPABASE_DB_VERSIONING_RUNBOOK.md`

## Open Verification Items

These still need to be validated as the starter is built:

- whether all required extension install steps work in Cloud and local setups
- whether self-hosted or offline-sensitive targets need a different install path
- whether grouped publication format should include overload aggregation by default
- whether views and materialized views need a parallel history/export strategy

The install scaffold for the extension layer currently lives here:

- `docs/templates/db-function-versioning/00_install/010_install_dbdev_and_function_vc.sql`

The recovery helpers currently live here:

- `docs/templates/db-function-versioning/20_queue/`

The recommended apply order lives here:

- `docs/templates/db-function-versioning/APPLY_ORDER.md`

## Practical Rule

If an agent is about to:

- directly edit generated SQL snapshots
- mix schema snapshot export with function history logic
- bypass the queue and push to Git ad hoc
- combine user JWT and service-role concerns

it is probably moving away from the intended model.
