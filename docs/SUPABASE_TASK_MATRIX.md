# Supabase Task Matrix

This file maps common tasks to the correct docs, helpers, and workflows.

## Runtime And Functions

- Initialize a new project from this starter
  - read `PROJECT_INIT_GUIDE.md`
  - then read `SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`
- Add a new Edge Function
  - read `SUPABASE_FUNCTIONS_GUIDE.md`
  - inspect `supabase/functions/_shared/`
- Add a shared helper
  - read `HELPERS_REFERENCE.md`
  - keep required helpers in `supabase/functions/_shared/`
  - put optional integrations in `supabase/functions/_optional/`
- Add small project-owned SQL support
  - read `SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`
  - place hand-maintained runtime SQL in `supabase/sql/`
- Add a minimal owner-based RLS table
  - inspect `supabase/sql/020_reference_user_profiles_rls.sql`
  - pair it with a user-JWT function such as `supabase/functions/whoami`

## DB Function Versioning

- Install DB function versioning prerequisites
  - read `SUPABASE_DB_VERSIONING_GUIDE.md`
  - inspect `docs/templates/db-function-versioning/00_install/`
- Apply the DB function versioning module in the correct order
  - read `docs/templates/db-function-versioning/APPLY_ORDER.md`
- Bootstrap function history
  - read `SUPABASE_DB_VERSIONING_GUIDE.md`
  - inspect `docs/templates/db-function-versioning/90_bootstrap/`
- Push updated SQL functions to Git
  - read `SUPABASE_DB_VERSIONING_GUIDE.md`
  - inspect `docs/templates/db-function-versioning/30_publish/`
- Wire scheduled SQL function publication
  - read `SUPABASE_CRON_GUIDE.md`
  - inspect `docs/templates/db-function-versioning/50_cron/`
- Investigate failed queue items
  - read `SUPABASE_DB_VERSIONING_RUNBOOK.md`
  - inspect `docs/templates/db-function-versioning/20_queue/`
- Requeue dead queue items
  - read `SUPABASE_DB_VERSIONING_RUNBOOK.md`
  - use `archive.requeue_dead_github_push_queue(...)`
- Force a limited retry batch
  - read `SUPABASE_DB_VERSIONING_RUNBOOK.md`
  - use `archive.process_github_push_queue(...)`

## Schema Export

- Refresh schema snapshot
  - read `SUPABASE_SCHEMA_EXPORT_GUIDE.md`
  - inspect `docs/templates/schema-export/`
- Apply the schema export module in the correct order
  - read `docs/templates/schema-export/APPLY_ORDER.md`
- Wire scheduled schema export refresh
  - read `SUPABASE_CRON_GUIDE.md`
  - inspect `docs/templates/schema-export/`

## Service Integrations

- Work with OpenAI
  - read `SERVICE_OPENAI_GUIDE.md`
- Work with Stripe
  - read `SERVICE_STRIPE_GUIDE.md`
- Work with Telegram Bot API
  - read `SERVICE_TELEGRAM_GUIDE.md`
  - use `debug-log` for the basic debug path
- Work with fal.ai
  - read `SERVICE_FAL_GUIDE.md`
- Work with Supabase Storage
  - read `SERVICE_STORAGE_GUIDE.md`
- Add a thumbnail generation path
  - read `SERVICE_STORAGE_GUIDE.md`
  - prefer existence check -> external library resize -> public thumbnail bucket -> persisted public thumbnail URL

## Debugging And Ops

- Set up Telegram-based debugging
  - read `TELEGRAM_DEBUGGING_GUIDE.md`
  - use `createDbg(true)` only when Telegram mirroring is wanted
- Determine whether a SQL file is template, runtime, or generated
  - read `SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`
