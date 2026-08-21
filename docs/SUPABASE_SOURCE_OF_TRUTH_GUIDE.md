# Supabase Source Of Truth Guide

This guide defines which parts of the repository are hand-maintained source, which are runtime SQL, and which must be treated as generated artifacts.

## Why This Matters

Without an explicit source-of-truth policy, a Supabase repo drifts quickly:

- an agent edits generated SQL as if it were source
- runtime helper SQL gets mixed with synced DB output
- starter templates get mistaken for project-owned SQL
- manual fixes get overwritten by export or sync flows

The repository must make these boundaries explicit.

## Repository Zones

### `docs/`

Purpose:

- human and agent documentation
- starter templates
- blueprint material

What belongs here:

- agent guides
- runtime guides
- service guides
- starter SQL templates in `docs/templates/`

What does not belong here:

- project runtime code
- deployed Edge Function code
- generated DB sync output

### `supabase/functions/`

Purpose:

- runtime Edge Functions
- shared runtime helpers

What belongs here:

- deployed or deployable function code
- `_shared` helper modules
- per-function README files

What does not belong here:

- starter blueprint-only code
- generated SQL snapshots

### `supabase/sql/`

Purpose:

- small project-owned runtime SQL
- hand-maintained operational SQL required by runtime behavior

Current examples:

- `debug_events`
- `call_edge_function`

What may belong here:

- small helper tables used by utility functions
- helper SQL needed for DB-to-Edge boundaries
- explicit project-owned runtime SQL

What does not belong here:

- starter SQL templates
- generated sync output from DB
- grouped function export artifacts

### `docs/templates/`

Purpose:

- reusable starter source
- SQL template modules for versioning and schema export

What belongs here:

- DB function versioning template SQL
- schema export template SQL
- installation notes and reference patterns

What does not belong here:

- project-owned live SQL
- generated DB sync output

## Artifact Categories

Every SQL file should fit one of these categories.

### 1. Hand-maintained starter source

Examples:

- `docs/templates/**`

Rule:

- safe to edit as starter design evolves

### 2. Hand-maintained project runtime SQL

Examples:

- `supabase/sql/001_debug_events.sql`
- `supabase/sql/010_call_edge_function.sql`

Rule:

- safe to edit as project runtime support changes

### 3. Generated snapshot or sync output

Examples:

- future exported grouped SQL function files
- future JSON or DDL snapshots

Rule:

- do not hand-edit unless the repo explicitly says otherwise

### 4. Database-live state

Examples:

- the actual current function bodies in the database
- the current schema visible through introspection

Rule:

- may be the real source of truth for sync workflows

## Default Rules For Agents

Before editing any SQL file, classify it first.

If a file is:

- in `docs/templates/`: treat it as starter source
- in `supabase/sql/`: treat it as project-owned runtime SQL
- marked generated: do not edit directly

If the file category is unclear, stop and determine whether the file is:

- manual
- generated
- runtime support
- template source

## Versioning Rule

For DB function versioning:

- current DB function definitions are the live source of truth
- `archive.function_history` is the historical source of truth
- Git is the publication target

That means grouped SQL files in Git should generally be treated as generated outputs, not as the primary editing surface.

## Schema Export Rule

For schema export:

- the live DB schema is the source of truth
- exported JSON or DDL files are snapshots

That means schema snapshot files should be clearly marked as generated.

## Practical Rule

If a change is intended to affect runtime behavior directly:

- prefer `supabase/functions/` or `supabase/sql/`

If a change is intended to improve the reusable starter itself:

- prefer `docs/` or `docs/templates/`

