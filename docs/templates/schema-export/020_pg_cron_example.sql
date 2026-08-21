/*
Example pg_cron wiring for schema export refresh.

Adjust cadence for your project.
Do not assume pg_cron is available in every environment.
*/

select cron.schedule(
    'schema-export-refresh',
    '17 * * * *',
    $$select public.refresh_and_publish_schema_export();$$
);
