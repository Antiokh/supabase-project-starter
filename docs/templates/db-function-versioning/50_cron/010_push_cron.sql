create or replace function archive.push_cron()
returns void
language plpgsql
as $function$
begin
    perform archive.push();
end;
$function$;
