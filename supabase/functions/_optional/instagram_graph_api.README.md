# Instagram Graph Optional Helper

Purpose:

- direct Instagram publish helpers for Edge Functions
- wraps the common create-media and publish-media flow

Expected env:

- `META_GRAPH_ACCESS_TOKEN`
- `INSTAGRAM_BUSINESS_ACCOUNT_ID`

Current helper surface:

- `instagram_get_me(...)`
- `instagram_create_media(...)`
- `instagram_publish_media(...)`
- `instagram_publish_photo(...)`

This helper is intentionally small and should stay transport-focused.
