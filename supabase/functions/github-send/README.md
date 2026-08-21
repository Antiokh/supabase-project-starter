# github-send

## 1) Purpose
Commit generated SQL function files into a GitHub repository.

## 2) Auth / RBAC
Treat this as a service-only endpoint. It is intended to be called by trusted DB or internal automation paths, not by browsers.

## 3) Inputs
Methods: `POST`
Headers: service-only authorization recommended
Query: none
Body (JSON): grouped SQL function payload, legacy SQL function payload, or generic file payload
Env: `GITHUB_TOKEN`, `GITHUB_OWNER`, `GITHUB_REPO`, optional `GITHUB_BRANCH`
Helpers: `../_shared/dbg.ts`, `../_shared/env.ts`
Libraries: `npm:octokit`

## 4) Errors
- `400`: invalid payload
- `500`: upstream GitHub or runtime failure

## 5) Logging
Uses shared debug logging helper when available.

## 6) Plain-English Flow
1. Parse either a SQL-function payload or a generic file payload.
2. Build file content or accept provided content as-is.
3. Load the existing GitHub file SHA if it exists.
4. Create or update the file in GitHub.

## 7) Inputs/Outputs (Schema)
Methods: `POST`
Response JSON (success): `{ ok, mode, path, overloads, commit, message }`
Response JSON (error): `{ error: string }`

Generic file payload example:

```json
{
  "path": "db/ddl.json",
  "content": "{\n  \"hello\": \"world\"\n}",
  "message": "schema export refresh: db/ddl.json"
}
```
