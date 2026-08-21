# Supabase Security Rules

These are the highest-priority rules for this starter.

## Auth And Roles

- never combine service-role credentials with user JWTs
- use user-scoped clients for RLS-protected work
- use service-role clients only for server-owned operations
- do not move privileged logic into browser code
- do not accept user-controlled authorization into service-role execution paths

## Runtime Safety

- do not read runtime env at import time
- do not create Supabase clients at module scope
- do not rely on `ENV=local` as the only local-runtime signal
- do not depend on fire-and-forget async work after a response is returned
- do not assume Cloud runtime behavior is identical to local CLI or self-hosted Docker
- do not cache env-derived configuration in global mutable state

## Secrets

- do not hardcode real secrets in repository files
- keep env access centralized
- prefer lazy env access inside runtime code
- do not log secrets, tokens, or raw service-role headers

## Request Boundaries

- validate whether a function is user-scoped, service-only, webhook-driven, or public before changing it
- do not trust optional headers to be present or untouched by proxies
- document RBAC changes in the function README in the same edit as the code change
- do not bypass ownership or RLS checks unless the function contract explicitly allows a service-role path

## SQL And Snapshots

- do not treat generated schema snapshots as editable source
- document whether a SQL file is manual, generated, or temporary
- keep SQL function versioning and schema snapshot export as separate workflows
- do not hand-edit generated export artifacts as if they were canonical source

## Long-Running Work

- if work must survive past the response boundary, use a durable pattern
- prefer queue, retry, state transition, or reconciler flows over hopeful background tails
- use `EdgeRuntime.waitUntil(...)` only as an explicit runtime-attached pattern, not as an assumption

## Anti-Pattern Summary

If a change depends on:

- import timing
- container reuse
- undocumented header presence
- manual edits to generated SQL artifacts
- background work that is not attached to runtime or backed by durable state

it should be treated as suspect until proven otherwise.
