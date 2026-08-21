# Queue Layer

This folder contains queue objects for Git publication.

Contents:

- queue table definition
- queue processing function
- dead-item inspection helpers
- dead-item requeue helpers

Operational rule:

- the queue should deduplicate by `function_history_id`
- recovery should reset existing dead rows, not create duplicate queue rows
