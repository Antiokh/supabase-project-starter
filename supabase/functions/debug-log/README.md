# debug-log

## 1) Purpose
Store debug events in the database and optionally print enough information for function-level diagnostics.

## 2) Auth / RBAC
Service role only by default. Local development may bypass auth when local runtime detection is active in `_shared/env.ts`.

## 3) Inputs
Methods: `POST`, `OPTIONS`
Headers: `Authorization: Bearer <service_role_key>`
Query: none
Body (JSON): `{ source?: string, message?: string, payload?: unknown, notify?: boolean }`
Env: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, optional `ENV`, optional `TELEGRAM_BOT_TOKEN`, optional `TELEGRAM_DEBUG_CHAT_ID`, optional `TELEGRAM_DEV_CHAT_ID`
Helpers: `../_shared/cors.ts`, `../_shared/env.ts`, `../_shared/supabase.ts`, `../_shared/telegram.ts`
Libraries: `npm:@supabase/supabase-js@2`

## 4) Errors
- `401`: missing authorization
- `403`: forbidden
- `400`: invalid JSON or invalid request body

## 5) Logging
Writes to `debug_events` if that table exists and also logs to console.

## 6) Plain-English Flow
1. Handle CORS preflight.
2. Enforce service-role auth unless local bypass is active.
3. Parse request body.
4. Insert a debug row into `debug_events`.
5. Optionally mirror the event to Telegram when `notify=true`.
6. Return a simple JSON response.

## 7) Inputs/Outputs (Schema)
Methods: `POST`, `OPTIONS`
Request JSON: `{ source?: string, message?: string, payload?: unknown, notify?: boolean }`
Response JSON (success): `{ ok: true }`
Response JSON (error): `{ error: string }`
