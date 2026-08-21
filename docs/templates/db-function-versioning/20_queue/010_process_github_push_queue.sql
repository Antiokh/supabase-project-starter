create or replace function archive.process_github_push_queue(p_limit integer default 5)
returns integer
language plpgsql
as $function$
declare
    r record;
    v_count integer := 0;
begin
    for r in
        select id, function_history_id, try_count
        from archive.github_push_queue
        where status = 'pending'
          and try_count < 10
        order by id
        limit p_limit
        for update skip locked
    loop
        begin
            perform archive.github_send_function(r.function_history_id);

            update archive.github_push_queue
            set status = 'done',
                pushed_at = now()
            where id = r.id;

            v_count := v_count + 1;
        exception when others then
            update archive.github_push_queue
            set try_count = try_count + 1,
                last_error = SQLERRM,
                status = case
                    when try_count + 1 >= 10 then 'dead'
                    else 'pending'
                end
            where id = r.id;
        end;
    end loop;

    return v_count;
end;
$function$;
