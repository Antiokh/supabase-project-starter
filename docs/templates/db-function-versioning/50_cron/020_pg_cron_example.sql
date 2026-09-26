/*
Scan and publication are intentionally separate.
The scan only detects and enqueues changes.
The queue job performs bounded network work.
*/

select cron.schedule(
    'archive-versioning-scan',
    '*/10 * * * *',
    $$select archive.push_cron();$$
);

select cron.schedule(
    'archive-github-push-queue',
    '* * * * *',
    $$select archive.process_github_push_queue_cron(5);$$
);
