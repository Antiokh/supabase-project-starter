# Supabase Cron Guide

This guide defines the starter's minimal scheduler model.

## Goal

Use a small number of explicit jobs.

Do not create overlapping cron jobs that perform the same work in different places.

## Recommended Jobs

### 1. SQL function publication

Purpose:

- scan target schemas for changed SQL functions
- enqueue changed function versions
- process a limited publication batch

Starter SQL entrypoint:

- `archive.push()`

Recommended cadence:

- every 5 to 15 minutes

### 2. Schema export

Purpose:

- refresh machine-readable schema snapshot artifacts
- keep agent context and repository snapshots current

Starter SQL entrypoint:

- `public.refresh_and_publish_schema_export()`

Recommended cadence:

- every 30 to 120 minutes

This job should usually run less often than function publication.

## Scheduler Backends

The starter should treat scheduler choice as environment-specific.

Examples:

- `pg_cron`
- Supabase Scheduled Functions
- external scheduler calling SQL or an Edge Function
- self-hosted orchestrator

The stable part is the SQL entrypoint, not the scheduler product.

## Failure Boundary

Cron jobs should call small orchestration functions.

Good:

- `select archive.push();`
- `select public.refresh_and_publish_schema_export();`

Bad:

- large copy-pasted SQL blocks in scheduler setup
- multiple cron jobs racing on the same queue without a clear reason

## Operational Checks

For SQL function publication, inspect:

- `archive.github_push_queue_summary()`
- `archive.get_github_push_queue_dead_items(...)`

For schema export, inspect:

- the current schema snapshot row
- the last refreshed timestamp
- the downstream publication path if export files are pushed to Git

## Repository Mapping

Cron-related starter SQL belongs under:

- `docs/templates/db-function-versioning/50_cron/`
- `docs/templates/schema-export/`

Project-specific installed SQL belongs under:

- `supabase/sql/`
