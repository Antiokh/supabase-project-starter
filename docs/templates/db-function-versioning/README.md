# SQL Function Versioning

This folder contains the starter's reusable DB-side module for:

- function history
- change detection
- queueing
- Git publication
- bootstrap and cron flows

## Intended Layout

- `00_install/`
  - extension installation and baseline setup
- `10_history/`
  - function history helpers and comparison logic
- `20_queue/`
  - queue tables and queue processors
- `30_publish/`
  - publication helpers and orchestration functions
- `40_recovery/`
  - recovery notes for queue-backed publication
- `50_cron/`
  - scheduler entrypoints and examples
- `90_bootstrap/`
  - bootstrap helpers for first-time initialization

## Notes

- SQL here should be treated as starter source, not generated sync output
- publication logic should call an Edge Function boundary for Git provider integration
- this module is focused on SQL functions, not full schema snapshots
- apply order is documented in `APPLY_ORDER.md`
