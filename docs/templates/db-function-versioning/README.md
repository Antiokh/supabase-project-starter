# DB Code Versioning

This module versions two kinds of database code:

- SQL functions
- table DDL

It detects changes in the live database, stores history in `archive`, enqueues
Git publications, and drains publication work in bounded retryable batches.

Generated artifacts:

- functions: `db/<schema>/<function_name>.sql`
- table bundles: `db/<schema>.sql`

The table layer is based on the AndroERP implementation and adds the missing
durable-queue step so table publication does not run as one long synchronous
export.

This is separate from the broader JSON schema snapshot exporter
(`db/ddl.json`), which is optimized for architecture/context inspection.

See `APPLY_ORDER.md`.
