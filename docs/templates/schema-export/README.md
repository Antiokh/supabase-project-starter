# Schema Export

This folder contains the starter's schema export and snapshot logic.

Current pieces:

- `001_get_complete_schema.sql`
  - builds the current JSON schema snapshot
- `010_refresh_schema_export.sql`
  - stores a fresh schema snapshot row
- `030_github_send_schema_export.sql`
  - publishes the latest schema snapshot to Git
- `040_refresh_and_publish_schema_export.sql`
  - refreshes and then publishes in one call
- `020_pg_cron_example.sql`
  - optional pg_cron wiring example

Coverage:

- enums
- tables
- foreign keys
- indexes
- triggers
- RLS policies
- functions
- views
- materialized views

The export layer should remain conceptually separate from SQL function versioning.

Apply order is documented in `APPLY_ORDER.md`.
