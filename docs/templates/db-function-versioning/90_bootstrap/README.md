# Bootstrap Layer

Bootstrap initializes both histories and enqueues initial Git artifacts.

Use:

- `archive.bootstrap_functions_to_github(...)`
- `archive.bootstrap_tables_to_github(...)`

Bootstrap enqueues by default. Drain with
`archive.process_github_push_queue(...)` in bounded batches instead of publishing
a large database synchronously.
