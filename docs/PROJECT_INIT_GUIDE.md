# Project Init Guide

This guide describes the expected initialization flow for a new project created from this starter.

## 1. Identify The Runtime Mode

Choose the initial operating mode before adding code:

- Supabase Cloud
- local Supabase CLI
- self-hosted or offline-sensitive
- hybrid

Read:

- `SUPABASE_RUNTIME_GUIDE.md`
- `SUPABASE_MCP_GUIDE.md`

If the project is self-hosted or offline-sensitive, keep one additional rule in mind:

- do not lock in a vendoring or offline dependency strategy from starter docs alone
- validate the real library landing path in the target project first, then document the proven pattern

If the project uses Supabase Cloud deploys, clarify this early:

- which Cloud project is the default deploy target
- whether `supabase link --project-ref ...` should be configured for this repo

If the project is local-only or self-hosted, do not assume Cloud deploy or remote Supabase MCP setup is required.

## 2. Keep The Repository Boundaries Clean

Before adding SQL, decide which zone it belongs to:

- `supabase/functions/` for runtime function code
- `supabase/sql/` for small project-owned runtime SQL
- `docs/templates/` for starter-source templates only

Read:

- `SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`

## 3. Configure Runtime Support

Install or adapt the base runtime pieces first:

- `supabase/config.toml`
- shared helpers in `supabase/functions/_shared/`
- utility functions already included in `supabase/functions/`
- runtime SQL support in `supabase/sql/`

At minimum, review:

- `supabase/sql/001_debug_events.sql`
- `supabase/sql/010_call_edge_function.sql`
- `supabase/sql/020_reference_user_profiles_rls.sql`

## 4. Decide Whether DB Function Versioning Is Enabled

If the project needs SQL function history and Git publication:

1. read `SUPABASE_DB_VERSIONING_GUIDE.md`
2. apply `docs/templates/db-function-versioning/APPLY_ORDER.md`
3. wire the publication boundary through `public.call_edge_function(...)`
4. bootstrap the initial function history
5. wire a scheduler only after manual flow works

If not, skip this module entirely.

## 5. Decide Whether Schema Export To Git Is Enabled

If the project needs schema snapshots in Git:

1. read `SUPABASE_SCHEMA_EXPORT_GUIDE.md`
2. apply `docs/templates/schema-export/APPLY_ORDER.md`
3. verify `public.get_complete_schema()` output
4. verify `public.refresh_and_publish_schema_export(...)`
5. wire a scheduler only after manual flow works

If not, keep schema snapshots DB-local or skip the publication layer.

## 6. Configure Service Integrations Only When Needed

Do not preload every service path into a new project.

Read only the guides you need:

- `SERVICE_OPENAI_GUIDE.md`
- `SERVICE_STRIPE_GUIDE.md`
- `SERVICE_TELEGRAM_GUIDE.md`
- `SERVICE_FAL_GUIDE.md`
- `SERVICE_STORAGE_GUIDE.md`

## 7. Prefer A Manual First Run

Before cron or automation:

1. verify helper env access
2. verify one utility Edge Function deploys
3. verify `debug-log` writes correctly
4. verify `public.call_edge_function(...)` reaches the intended Edge Function
5. verify one manual Git publication succeeds

Only then add scheduled execution.

## 8. Wire Cron Last

When the manual path is stable:

1. read `SUPABASE_CRON_GUIDE.md`
2. wire SQL function publication cadence
3. wire schema export cadence if needed
4. keep scheduler entrypoints small

## 9. Agent Rule

When starting work in a project derived from this starter, the minimum read set is:

1. `AGENT_START_HERE.md`
2. `README_AGENT_PACK.md`
3. `SUPABASE_MASTER_GUIDE.md`
4. `SUPABASE_SECURITY_RULES.md`
5. `HELPERS_REFERENCE.md`
6. `PROJECT_INIT_GUIDE.md`
