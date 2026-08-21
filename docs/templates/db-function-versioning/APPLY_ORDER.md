# DB Function Versioning Apply Order

Apply the starter SQL in this order:

1. `00_install/`
2. `10_history/`
3. `20_queue/`
4. `30_publish/`
5. `50_cron/`
6. `90_bootstrap/`

## Notes

- install `supabase/sql/010_call_edge_function.sql` before the publish layer
- bootstrap is last because it assumes history, queue, and publication helpers already exist
- cron setup is optional, but if used, it should point only at small orchestration entrypoints
