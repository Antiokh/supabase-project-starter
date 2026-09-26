# github-send

## 1) Purpose
Commit generated SQL function files, table-schema bundles, and generic generated artifacts into a GitHub repository.

## 2) Auth / RBAC
Treat this as a service-only endpoint. It is intended to be called by trusted DB or internal automation paths, not by browsers.

## 3) Inputs
Methods: `POST`
Headers: service-only authorization recommended
Query: none
Body (JSON): grouped SQL function payload, table bundle payload, legacy SQL function payload, or generic file payload
Env: `GITHUB_TOKEN`, `GITHUB_OWNER`, `GITHUB_REPO`, optional `GITHUB_BRANCH`, optional `GITHUB_GENERATED_COMMIT_PREFIX`
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


## 8) Generated Commit / Cloudflare Pages Behavior

All commits created by this Edge Function are generated artifacts.

By default their commit message is prefixed with:

`[CF-Pages-Skip]`

Cloudflare Pages recognizes this prefix and skips the build/deployment for the
generated commit. This prevents DB function versioning and schema-export
publication from rebuilding a frontend in the same repository.

This prefix is Cloudflare-specific. It does not suppress Supabase GitHub
Integration checks on commits to the production branch. Generated `db/**` commits
should contain no migrations or deployable Supabase runtime changes, but Supabase
may still start its integration workflow for the commit.

Override with:

- `GITHUB_GENERATED_COMMIT_PREFIX=<custom prefix>`
- `GITHUB_GENERATED_COMMIT_PREFIX=none` to disable prefixing

For repositories also connected to Cloudflare Pages, Build watch paths may still
be used as a second layer, but the default generated commit prefix is sufficient
to skip the Pages deployment.

If generated exports live elsewhere, exclude those generated paths as well.

Do not exclude application source paths or migration paths merely to save builds;
the path exclusion is for generated publication artifacts.



## 9) Table Bundle Mode

Table versioning publishes a schema-wide bundle:

`db/<schema>.sql`

Example payload:

```json
{
  "schema": "public",
  "tables": [
    {
      "table_name": "profiles",
      "ddl": "CREATE TABLE public.profiles (...);"
    }
  ]
}
```

The same `[CF-Pages-Skip]` generated-commit prefix applies.
