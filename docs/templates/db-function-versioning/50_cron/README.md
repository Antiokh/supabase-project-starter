# Cron Layer

This folder contains small SQL entrypoints intended to be called by a scheduler.

Keep these functions small.

They should orchestrate existing history, queue, and publication helpers rather than duplicating their logic.
