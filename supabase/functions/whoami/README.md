# whoami

## 1) Purpose
Provide the smallest possible reference endpoint for a user-authenticated Edge Function path.

It is meant to show how the starter expects request JWTs to be handled through `supabaseFromRequest(req)`.

## 2) Auth / RBAC
User JWT required.

This endpoint is intentionally user-scoped and should not use the service role path.

## 3) Inputs
Methods: `GET`, `OPTIONS`
Headers: `Authorization: Bearer <user_jwt>`
Query: none
Body (JSON): none
Env: `SUPABASE_URL`, `SUPABASE_ANON_KEY`
Helpers: `../_shared/cors.ts`, `../_shared/supabase.ts`
Libraries: `npm:@supabase/supabase-js@2`

## 4) Errors
- `401`: missing or invalid user JWT

## 5) Logging
No structured DB logging by default.

## 6) Plain-English Flow
1. Handle CORS preflight.
2. Create a user-scoped Supabase client from the request bearer token.
3. Resolve the current user via `auth.getUser()`.
4. Return a small safe subset of the user object.

## 7) Inputs/Outputs (Schema)
Methods: `GET`, `OPTIONS`
Response JSON (success): `{ ok: true, user: { id, email, phone, role, app_metadata, user_metadata } | null }`
Response JSON (error): `{ error: string }`
