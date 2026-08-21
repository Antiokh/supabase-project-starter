# Agent Decision Tree

Use this file to minimize unnecessary reading.

## Step 1. Ask The Hosting Mode First

If the hosting mode is not already clear from context, ask the user which path the project uses:

- cloud
- self-hosted
- hybrid

This question should happen before reading deep docs or proposing deploy instructions.

## Step 2. Read Only The Minimum Set

Always read these first:

1. `AGENT_SYSTEM_PROMPT.md`
2. `PROJECT_INIT_GUIDE.md`
3. `SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`
4. `HELPERS_REFERENCE.md`

Then stop and choose the next file by task.

## Task Routing

### Edge Function work

Read:

- `SUPABASE_FUNCTIONS_GUIDE.md`
- `SUPABASE_RUNTIME_GUIDE.md`

### Shared helpers or auth context

Read:

- `HELPERS_REFERENCE.md`
- `SUPABASE_SECURITY_RULES.md`

### Cloud / local / self-hosted / hybrid setup

Read:

- `SUPABASE_RUNTIME_GUIDE.md`
- `SUPABASE_MCP_GUIDE.md`

### DB function versioning / Git sync

Read:

- `SUPABASE_DB_VERSIONING_GUIDE.md`
- `SUPABASE_DB_VERSIONING_RUNBOOK.md`
- `SUPABASE_CRON_GUIDE.md` if scheduling is involved

### Schema export / DDL snapshots

Read:

- `SUPABASE_SCHEMA_EXPORT_GUIDE.md`
- `SUPABASE_CRON_GUIDE.md` if scheduling is involved

### Telegram

Read:

- `SERVICE_TELEGRAM_GUIDE.md`
- `TELEGRAM_DEBUGGING_GUIDE.md`

### Storage / thumbnails / signed URLs

Read:

- `SERVICE_STORAGE_GUIDE.md`

### Stripe

Read:

- `SERVICE_STRIPE_GUIDE.md`

### OpenAI

Read:

- `SERVICE_OPENAI_GUIDE.md`

### fal.ai

Read:

- `SERVICE_FAL_GUIDE.md`

## Skip Rules

- Do not read DB versioning docs for a pure frontend or simple auth-helper task.
- Do not read storage docs unless the task touches buckets, files, thumbnails, or URLs.
- Do not read all service guides by default.
- Do not read template SQL under `docs/templates/` unless the task actually changes starter SQL modules.
