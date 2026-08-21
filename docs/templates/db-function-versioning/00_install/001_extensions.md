# Extension Install Notes

This starter expects the DB function versioning module to build on:

- `dbdev`
- `mansueli-function_vc`

Practical caveats to verify per deployment mode:

- Supabase Cloud support and permissions
- local CLI support
- self-hosted support
- `pg_tle` availability
- `http` extension availability

Practical install guidance:

- `http` is a runtime prerequisite for DB-to-Edge HTTP calls
- `pg_tle` may be required for the `dbdev` install path
- extension installation may differ or fail depending on platform restrictions

Use `010_install_dbdev_and_function_vc.sql` as the starter scaffold for this layer.
