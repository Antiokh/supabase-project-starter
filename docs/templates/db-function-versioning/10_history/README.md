# History Layer

This folder contains the custom history logic that sits on top of the baseline extension objects.

Current responsibilities:

- `save_function_history`
- `update_function_history`
- `update_functions`
- `diff_text`
- optional helper views such as latest active versions

This layer owns change detection.

It should decide whether a function version actually changed before anything reaches the queue.
