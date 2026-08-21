# Runtime SQL Notes

This folder is reserved for project-owned SQL that belongs to the runtime scaffold.

Do not place starter SQL templates here.

Examples of what may eventually belong here in a real project:

- migrations
- tests
- project-owned hand-maintained SQL
- operational helper SQL required by starter functions

Current starter-owned runtime SQL:

- `001_debug_events.sql`
- `010_call_edge_function.sql`
- `020_reference_user_profiles_rls.sql`

Reference pattern included:

- a minimal user-owned table with owner-based RLS using `auth.uid()`

Examples of what should not live here:

- starter templates for DB function versioning
- starter templates for schema export
- generated sync artifacts mixed with template source
