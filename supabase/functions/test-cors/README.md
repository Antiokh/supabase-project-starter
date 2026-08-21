# test-cors

## 1) Purpose
Provide a small diagnostics endpoint for CORS, request inspection, and frontend-to-function smoke tests.

## 2) Auth / RBAC
No Supabase JWT required by default.

## 3) Inputs
Methods: `GET`, `POST`, `OPTIONS`
Headers: any
Query: any
Body (JSON): optional
Env: none
Helpers: `../_shared/cors.ts`
Libraries: none

## 4) Errors
- `400`: invalid JSON body when a JSON body is provided but cannot be parsed

## 5) Logging
Logs request metadata to console.

## 6) Plain-English Flow
1. Handle CORS preflight.
2. Read query params and an optional JSON body.
3. Echo request metadata back as JSON.

## 7) Inputs/Outputs (Schema)
Methods: `GET`, `POST`, `OPTIONS`
Response JSON (success): `{ ok: true, method, query, body, headers }`
Response JSON (error): `{ error: string }`

