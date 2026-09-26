# History Layer

History covers SQL functions and table DDL.

Table DDL history uses:

- `archive.table_history`
- `archive.build_table_ddl`
- `archive.save_table_history`
- `archive.update_table_history`
- `archive.update_tables`
- `archive.setup_table_history`

The generated table DDL includes columns/defaults, constraints, indexes, triggers,
RLS state, and policies. Dropped tables create tombstone history rows so a DROP
also triggers a new schema bundle.

History functions detect change only. They do not perform network publication.
