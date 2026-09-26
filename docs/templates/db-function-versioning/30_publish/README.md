# Publication Layer

Publication helpers:

- `archive.github_send_function`
- `archive.github_send_tables`
- `archive.push_updated_functions_to_github`
- `archive.push_updated_tables_to_github`

The push helpers enqueue by default. Immediate processing is optional and defaults
to zero.

The Edge Function owns GitHub formatting and authentication.

Outputs:

- `db/<schema>/<function_name>.sql`
- `db/<schema>.sql`
