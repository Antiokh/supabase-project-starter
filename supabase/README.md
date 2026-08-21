# Supabase Scaffold

This folder contains the runtime-facing Supabase scaffold for projects derived from this starter.

Current areas:

- `functions/`
- `functions/_shared/`
- `functions/_optional/`
- `sql/`
- local CLI config

The `supabase/` folder is reserved for runtime-facing project scaffold.

Starter SQL template modules live under `docs/templates/`.

## Current Utility Functions

The starter already includes a small universal utility set under `supabase/functions/`:

- `debug-log`
- `test-cors`
- `env-debug`
- `text-diff`
- `github-send`

These files are meant to be adapted by real projects.

By contrast, reusable starter SQL modules remain under `docs/templates/`.
