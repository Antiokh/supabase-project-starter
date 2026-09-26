create or replace function archive.push_cron()
returns void
language plpgsql
as $function$
begin
    perform archive.push();
end;
$function$;

create or replace function archive.process_github_push_queue_cron(
    p_limit integer default 5
)
returns integer
language plpgsql
as $function$
begin
    return archive.process_github_push_queue(p_limit);
end;
$function$;
