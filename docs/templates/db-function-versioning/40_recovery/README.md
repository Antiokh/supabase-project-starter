# Recovery Layer

This folder contains small operational helpers for recovery procedures.

In this starter, the recovery path stays intentionally small:

- inspect queue status
- inspect dead queue items
- requeue dead queue items
- process a limited batch immediately

The main SQL helpers currently live in `20_queue/` because they operate directly on queue state.
