# Shared Helpers

This folder contains shared helpers for Supabase Edge Functions.

Current intent:

- lazy environment access
- explicit auth-context separation
- reusable CORS handling
- reusable internal Edge call helpers
- centralized debug logging

Note:

- `telegram.ts` is a compatibility shim
- the canonical Telegram helper lives in `../_optional/telegram_bot_api.ts`
- Meta-owned social network helpers should live in `../_optional/` and share transport through `../_optional/meta_graph_api.ts`
