# Supabase Agent Pack

This folder contains the documentation pack for AI agents and humans working in this starter.

## Recommended Reading Order

Minimum set:

1. `QUICKSTART_FOR_AGENT.md`
2. `PROJECT_INIT_GUIDE.md`
3. `SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`
4. `HELPERS_REFERENCE.md`
5. `AGENT_DECISION_TREE.md`

Then read only the files relevant to the task.

## Task Router Files

- `AGENT_DECISION_TREE.md`
  - markdown routing for what to read next
- `agent_index.json`
  - machine-readable routing index
- `SUPABASE_MCP_GUIDE.md`
  - when MCP helps and when it should be skipped

## Purpose Of Each File

- `SUPABASE_MASTER_GUIDE.md`
  - top-level mental model for the starter
- `SUPABASE_SECURITY_RULES.md`
  - non-negotiable auth, secret, and SQL safety rules
- `HELPERS_REFERENCE.md`
  - contract for shared helpers
- `PROJECT_INIT_GUIDE.md`
  - end-to-end initialization flow for a new project
- `AGENT_DECISION_TREE.md`
  - minimal reading path by task
- `QUICKSTART_FOR_AGENT.md`
  - smallest token-footprint repo entry
- `SUPABASE_MCP_GUIDE.md`
  - hosting-mode-aware MCP guidance
- `SUPABASE_FUNCTIONS_GUIDE.md`
  - Edge Function structure and operating rules
- `SUPABASE_RUNTIME_GUIDE.md`
  - cloud vs local vs self-hosted runtime differences
- `SUPABASE_DB_VERSIONING_GUIDE.md`
  - function history, Git sync, cron model
- `SUPABASE_DB_VERSIONING_RUNBOOK.md`
  - queue recovery and retry procedures
- `SUPABASE_CRON_GUIDE.md`
  - scheduler model for function push and schema export
- `SUPABASE_TASK_MATRIX.md`
  - quick lookup for common tasks
- `SUPABASE_SCHEMA_EXPORT_GUIDE.md`
  - schema snapshot and export guidance
- `SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`
  - repository-level file ownership and edit rules
- `SERVICE_OPENAI_GUIDE.md`
  - OpenAI integration patterns
- `SERVICE_STRIPE_GUIDE.md`
  - Stripe integration patterns
- `SERVICE_TELEGRAM_GUIDE.md`
  - Telegram Bot API patterns and ops role
- `SERVICE_FAL_GUIDE.md`
  - fal.ai async provider patterns
- `SERVICE_STORAGE_GUIDE.md`
  - Supabase Storage usage patterns
- `TELEGRAM_DEBUGGING_GUIDE.md`
  - Telegram as the preferred debug channel
- `OPS_ALERTING_GUIDE.md`
  - what belongs in fast alerting channels

## Important Repository Rule

The `supabase/` folder is for runtime-facing project scaffold.

Starter SQL modules and template modules live under `docs/templates/` so they do not get confused with:

- generated DB sync output
- project-owned SQL
- future schema snapshots
