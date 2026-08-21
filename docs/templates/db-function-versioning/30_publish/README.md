# Publication Layer

This folder contains publication helpers that connect DB-side function history to the Git publication Edge Function.

Current responsibilities:

- `github_send_function`
- publication wrappers
- orchestration helpers

This layer should format payloads for the publication boundary, not embed GitHub client logic directly in SQL.
