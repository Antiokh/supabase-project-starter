# Meta Graph Optional Helper

Purpose:

- shared transport helper for Meta-owned social APIs inside Supabase Edge Functions
- centralizes access token handling and Graph base URL selection

Expected env:

- `META_GRAPH_ACCESS_TOKEN`
- optional `META_GRAPH_BASE_URL`

Use this helper as the base transport for:

- Instagram Graph helpers
- Threads helpers

Do not duplicate Graph request boilerplate in every network-specific helper.
