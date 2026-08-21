# Helpers Reference

This file defines the current shared helper surface for Edge Functions in this starter.

## Core Helpers

- `env.ts`
  - lazy env access, validation, optional overrides for local/dev
  - `isLocalEnv()` for centralized local-runtime detection
- `supabase.ts`
  - anon, service, and request-derived clients
- `cors.ts`
  - browser-safe CORS handling for WeWeb and non-browser callers
- `edge.ts`
  - internal Edge Function calling helpers
- `dbg.ts`
  - centralized debug and operational logging helper

## Expected Rules

- no import-time env assumptions in shared helpers
- no module-scope service client that depends on runtime-injected env
- local/prod branching should live in shared helpers, not be reimplemented ad hoc
- helper contracts must be documented when changed
- prefer `npm:` for external dependencies when a helper or function needs a package
- for Telegram, use small native `fetch`-based wrappers
- do not add `grammy` to the starter helper layer

## Optional Helpers

- `../_optional/telegram_bot_api.ts`
  - optional native Telegram Bot API helper for projects that need more than `debug-log`
- `../_optional/meta_graph_api.ts`
  - optional shared Meta Graph transport helper for Meta-owned social networks
- `../_optional/instagram_graph_api.ts`
  - optional Instagram publish helper for direct media publish flows
- `../_optional/threads_api.ts`
  - optional Threads publish helper for direct text-post flows

## Compatibility Notes

- `_shared/telegram.ts` is kept as a small compatibility re-export
- new optional Telegram work should point at `_optional/telegram_bot_api.ts`
