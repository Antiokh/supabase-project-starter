# text-diff

## 1) Purpose
Compare two text blobs and return a line-by-line diff with basic stats and a content hash.

## 2) Auth / RBAC
No Supabase JWT required by default.

## 3) Inputs
Methods: `POST`
Headers: none
Query: none
Body (JSON): `{ old?: string, new?: string }`
Env: none
Helpers: none
Libraries: `npm:diff`

## 4) Errors
- `400`: invalid JSON or invalid request body

## 5) Logging
No structured DB logging by default.

## 6) Plain-English Flow
1. Normalize both text inputs.
2. Compute a hash for the new normalized content.
3. Return early if content is unchanged.
4. Otherwise compute a line diff and summary stats.

## 7) Inputs/Outputs (Schema)
Methods: `POST`
Request JSON: `{ old?: string, new?: string }`
Response JSON (success): `{ changed, hash, stats, diff }`

