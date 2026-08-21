/*
Example pg_cron wiring for DB function publication.

Adjust cadence for your project.
Do not assume pg_cron is available in every environment.
*/

select cron.schedule(
    'archive-push',
    '*/10 * * * *',
    $$select archive.push_cron();$$
);
