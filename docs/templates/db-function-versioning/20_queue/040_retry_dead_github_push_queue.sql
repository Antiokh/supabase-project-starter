create or replace function archive.retry_dead_github_push_queue(
    p_requeue_limit integer default 100,
    p_process_limit integer default 20
)
returns integer
language plpgsql
as $function$
declare
    v_requeued integer;
begin
    v_requeued := archive.requeue_dead_github_push_queue(p_requeue_limit);

    if v_requeued > 0 then
        perform archive.process_github_push_queue(p_process_limit);
    end if;

    return v_requeued;
end;
$function$;
