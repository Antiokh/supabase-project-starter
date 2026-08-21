# supabase-project-starter

Starter repository for Supabase projects with:

- agent-oriented documentation
- shared Edge Function helpers
- support for cloud and local/self-hosted setups
- SQL function versioning patterns
- schema snapshot and DDL export workflows

## What This Starter Gives You

- a runtime-facing `supabase/` scaffold
- a documentation pack for humans and AI agents
- starter SQL modules under `docs/templates/`
- utility Edge Functions for debugging, auth reference, and Git publication
- explicit rules for cloud, local CLI, and self-hosted work

## Included Runtime Baseline

- shared helpers in `supabase/functions/_shared/`
- optional helpers in `supabase/functions/_optional/`
- utility functions:
  - `debug-log`
  - `test-cors`
  - `env-debug`
  - `text-diff`
  - `github-send`
  - `whoami`
- runtime support SQL in `supabase/sql/`
- local Supabase CLI config in `supabase/config.toml`

## Read First

1. [docs/AGENT_START_HERE.md](./docs/AGENT_START_HERE.md)
2. [docs/AGENT_SYSTEM_PROMPT.md](./docs/AGENT_SYSTEM_PROMPT.md)
3. [docs/AI.md](./docs/AI.md)
4. [docs/PROJECT_INIT_GUIDE.md](./docs/PROJECT_INIT_GUIDE.md)
5. [docs/README_AGENT_PACK.md](./docs/README_AGENT_PACK.md)
6. [docs/PLAN.md](./docs/PLAN.md)

## Repository Layout

- `docs/`
  - agent pack, runtime guides, service guides, and operating rules
- `docs/templates/`
  - starter-source SQL modules for DB function versioning and schema export
- `supabase/`
  - runtime-facing scaffold for real projects
- `supabase/functions/_shared/`
  - required shared helpers
- `supabase/functions/_optional/`
  - optional helpers that should not be forced into every project
- `supabase/sql/`
  - small project-owned runtime SQL, not starter template SQL

## Design Intent

This starter is not just a code template.

It is meant to package:

- the project structure
- the operating rules
- the trusted helper patterns
- the documentation an AI agent should read before changing anything

## Initialization

For a new project setup flow, start here:

- [docs/PROJECT_INIT_GUIDE.md](./docs/PROJECT_INIT_GUIDE.md)

## Important Boundary

Keep these zones separate:

- `supabase/` for runtime-facing project files
- `docs/templates/` for reusable starter-source SQL modules

Do not mix generated artifacts, project-owned SQL, and starter templates in the same folder just because they are all “SQL”.
