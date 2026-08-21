# Supabase Project Starter Plan

## Goal

Build a reusable starter repository for Supabase projects that includes:

- a starter project structure for cloud and local/self-hosted setups
- full agent-oriented documentation
- shared Edge Function helpers
- SQL function versioning based on dbdev + mansueli-function_vc
- automated Git publication of SQL functions
- DDL/schema snapshot export with cron-friendly update flow

## Main Workstreams

### 1. Repository Blueprint

Define the target repository structure and separate it into clear modules:

- `docs/`
- `supabase/`
- `docs/templates/`
- `docs/templates/db-function-versioning/`
- `docs/templates/schema-export/`
- optional self-hosted/offline support

Decide which parts are:

- core
- optional
- generated
- read-only snapshots

### 2. Agent Documentation Pack

Create an agent pack similar in spirit to `ww-component-starter`, but focused on Supabase:

- `docs/AGENT_START_HERE.md`
- `docs/AGENT_SYSTEM_PROMPT.md`
- `docs/AI.md`
- `docs/README_AGENT_PACK.md`
- `docs/SUPABASE_MASTER_GUIDE.md`
- `docs/SUPABASE_FUNCTIONS_GUIDE.md`
- `docs/SUPABASE_RUNTIME_GUIDE.md`
- `docs/SUPABASE_SECURITY_RULES.md`
- `docs/SUPABASE_DB_VERSIONING_GUIDE.md`
- `docs/SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`
- `docs/SUPABASE_TASK_MATRIX.md`
- `docs/HELPERS_REFERENCE.md`

The documentation must explain:

- cloud vs local CLI vs self-hosted/offline modes
- auth model and role separation
- shared helper usage
- SQL source-of-truth rules
- sync and export workflows

### 3. Shared Helper Layer

Design and document the shared helper layer for Edge Functions:

- `env.ts`
- `supabase.ts`
- `cors.ts`
- `edge.ts`
- `dbg.ts`

Core constraints:

- lazy env access
- no import-time env assumptions
- strict separation of anon, user JWT, and service-role contexts
- compatibility with cloud and local/self-hosted runtimes

### 4. SQL Function Versioning

Package the DB-side function versioning system as a reusable starter module.

Inputs from existing work:

- dbdev installation flow
- `mansueli-function_vc`
- custom `archive.function_history` extensions
- queue-based Git sync

Key objects to include or regenerate:

- `archive.save_function_history`
- `archive.update_function_history`
- `archive.update_functions`
- `archive.github_push_queue`
- `archive.process_github_push_queue`
- `archive.github_send_function`
- `archive.push_updated_functions_to_github`
- `archive.bootstrap_functions_to_github`
- `archive.push`

### 5. Git Publication Pipeline

Document and template the function publication flow:

1. detect changed SQL functions in DB
2. enqueue changed versions
3. push them through an Edge Function to GitHub
4. support retries and dead-letter behavior

Also define:

- required environment variables
- bootstrap flow for first sync
- manual recovery flow
- cron invocation pattern

### 6. Schema Export and DDL Snapshots

Define the schema export layer separately from function history.

The starter must support:

- JSON schema snapshot export
- DDL export or equivalent generated snapshot
- scheduled updates through cron or a controlled task runner

Must verify whether the export covers:

- tables
- enums
- functions
- foreign keys
- indexes
- triggers
- RLS policies
- views
- materialized views

Views and materialized views are an explicit verification item and may require extra work.

### 7. SQL Source-of-Truth Policy

Document exactly how SQL is managed:

- which files are generated from DB
- which files may be edited manually
- whether `db/tmp/` is used for drafts
- how generated artifacts are refreshed
- what the agent must never edit directly

### 8. Agent Usage Instructions

Write explicit procedural guidance for the agent:

- initialize repo
- add a new function
- modify an existing function
- update helpers
- bootstrap function history
- run Git sync
- refresh schema snapshot
- investigate failed queue items

## Immediate Next Steps

1. Create the initial repository skeleton.
2. Add the root agent entry files.
3. Add the docs pack scaffold.
4. Add the shared helper scaffold.
5. Draft the versioning module structure under `docs/templates/`, outside the runtime `supabase/` folder.
6. Verify gaps in schema export, especially views.
