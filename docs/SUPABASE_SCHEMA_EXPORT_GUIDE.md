# Supabase Schema Export Guide

This guide describes the starter's schema export layer.

## Mission

The schema export layer should produce a readable, machine-usable snapshot of the current database shape.

It exists for:

- architecture inspection
- agent context building
- snapshot comparison
- export into JSON or DDL-like artifacts

## What It Is Not

Schema export is not the same thing as function version history.

Function history tracks:

- per-function changes over time
- active versions
- Git publication of changed SQL functions

Schema export tracks:

- current schema state as a whole

## Required Coverage

At minimum, the starter schema export should try to cover:

- enums
- tables
- columns
- primary keys
- foreign keys
- indexes
- triggers
- RLS policies
- functions
- views
- materialized views

## Views Matter

Views and materialized views must be treated as first-class export objects.

This is an explicit requirement because they are easy to miss in table-focused exports.

If they are omitted, an agent can build the wrong mental model of the system.

## Output Shapes

The starter may support more than one export shape.

Examples:

- JSON snapshot for agent context
- generated DDL bundle
- partial domain-specific exports

## Repository Rule

Schema export starter source lives under:

- `docs/templates/schema-export/`

Generated exports, when a real project starts using them, should live in project-owned locations and be clearly marked as generated.

## Minimal Refresh Model

The starter uses a small refresh model:

1. `public.get_complete_schema()` builds the JSON snapshot
2. `public.refresh_schema_export()` stores a new snapshot row
3. `public.github_send_schema_export(...)` can publish the latest snapshot to Git
4. an optional scheduler calls the combined entrypoint on a controlled cadence

The starter SQL for this lives under:

- `docs/templates/schema-export/`

The recommended apply order lives here:

- `docs/templates/schema-export/APPLY_ORDER.md`

## Cron Rule

Schema export should usually be scheduled less frequently than SQL function publication.

It is a broader snapshot, not an immediate per-change publication path.

If the project publishes schema snapshots to Git, prefer a single orchestration entrypoint:

- `public.refresh_and_publish_schema_export(...)`
