# Threads Optional Helper

Purpose:

- direct Threads publish helpers for Edge Functions
- wraps creation and publish steps for text posts

Expected env:

- `META_GRAPH_ACCESS_TOKEN`
- `THREADS_USER_ID`

Current helper surface:

- `threads_get_me(...)`
- `threads_create_text_post(...)`
- `threads_publish_creation(...)`
- `threads_publish_text(...)`

This helper is intentionally small and should stay transport-focused.
