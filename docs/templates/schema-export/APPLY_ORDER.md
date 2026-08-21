# Schema Export Apply Order

Apply the starter SQL in this order:

1. `001_get_complete_schema.sql`
2. `010_refresh_schema_export.sql`
3. `030_github_send_schema_export.sql`
4. `040_refresh_and_publish_schema_export.sql`
5. `020_pg_cron_example.sql` or other scheduler wiring

## Notes

- install `supabase/sql/010_call_edge_function.sql` before Git publication helpers
- `020_pg_cron_example.sql` is only an example scheduler backend
- `030_` and `040_` are optional if the project stores snapshots only in the database and does not push them to Git
