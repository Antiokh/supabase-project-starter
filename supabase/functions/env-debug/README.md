# env-debug

## 1) Purpose
Inspect which environment variables are visible to the function runtime and optionally load a local env file.

## 2) Auth / RBAC
No Supabase JWT required by default. Restrict or remove this function in production if that exposure is not acceptable.

## 3) Inputs
Methods: `GET`
Headers: none
Query: none
Body (JSON): none
Env: optional `DENO_ENV_FILE`
Helpers: `../_shared/env.ts`
Libraries: none

## 4) Errors
- file loading failures are returned as status information, not hard failures

## 5) Logging
No structured DB logging by default.

## 6) Plain-English Flow
1. Optionally load a file referenced by `DENO_ENV_FILE`.
2. Report whether that load succeeded.
3. Return the currently visible env variable names.

## 7) Inputs/Outputs (Schema)
Methods: `GET`
Response JSON (success): `{ env_file_status: string, variables_from_deno_env: string[] }`

