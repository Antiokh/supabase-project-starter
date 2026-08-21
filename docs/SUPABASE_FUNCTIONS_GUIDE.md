# Supabase Functions Guide

This guide defines the starter's baseline contract for Edge Functions.

## Core Contract

- one folder per function
- one local `README.md` per function
- function-local `deno.json` or equivalent import map if needed
- use shared helpers instead of ad hoc client creation
- keep functions deployable in isolation

If a function changes:

- logic
- auth or RBAC
- request or response shape
- env requirements
- dependencies

its local `README.md` should change in the same edit.

## Runtime Rules

- no import-time env access
- no module-scope Supabase client creation
- no dependency on global import maps
- no assumption that background async work survives after a response
- no assumption that `ENV=local` is the only local-runtime signal

## Import Map Rule

Only add a function-local `deno.json` when that function actually needs one.

Current examples:

- `text-diff` for `@diff`
- `github-send` for `@octokit`

Do not create redundant import maps for functions that only use relative imports and built-in runtime APIs.

## Dependency Rule

For this starter, `npm:` is the preferred dependency source for external libraries.

Reason:

- it is friendlier to self-hosted deployments
- it is easier to cache and control
- it avoids a class of failures caused by runtime access to remote module URLs

Use remote `https:` imports only when there is a strong reason and the runtime tradeoff is explicit.

## Starter Utility Set

The starter includes a small utility baseline that is useful for testing and operations:

- `debug-log`
- `test-cors`
- `env-debug`
- `text-diff`
- `github-send`
- `whoami`

These functions are intentionally generic enough to justify inclusion before any project-specific business functions exist.

## Auth And Caller Separation

- user-facing endpoints should derive a client from the request JWT
- service-only endpoints should use service-role paths explicitly
- do not mix service-role clients with user-controlled authorization
- internal Edge-to-Edge calls should use the helpers in `_shared/edge.ts`

The canonical minimal user-auth example in this starter is:

- `supabase/functions/whoami`

## Runtime SQL Prerequisites

Some utility functions depend on small runtime SQL helpers.

Current examples:

- `debug-log` expects `public.debug_events`
- DB-driven publication helpers may use `public.call_edge_function(...)`

These runtime SQL helpers belong under `supabase/sql/` because they are project-owned operational SQL, not starter template SQL.
