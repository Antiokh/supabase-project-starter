# Queue Layer

One durable queue carries:

- `function` jobs
- `table_bundle` jobs

A table scan that changes several tables enqueues one bundle job, keyed by the
newest table-history revision from that scan. Processing publishes the current
active table set for that schema into `db/<schema>.sql`.

Operational rules:

- bounded batches
- `FOR UPDATE SKIP LOCKED`
- `pending / done / dead`
- retry counter and last error retention
- no unbounded HTTP work in the scan/orchestration path
