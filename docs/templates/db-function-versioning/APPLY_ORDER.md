# DB Code Versioning Apply Order

Apply in this order:

1. `00_install/`
2. `10_history/`
3. `20_queue/`
4. `30_publish/`
5. `50_cron/`
6. `90_bootstrap/`

Within each folder, apply files in filename order.

Also install `supabase/sql/010_call_edge_function.sql` before the publication
layer.

The recommended scheduler model is two-stage:

- scan/enqueue periodically
- drain a small queue batch more frequently

This separation is deliberate: network publication must not make schema scans or
bootstrap calls hit statement/runtime timeouts.
