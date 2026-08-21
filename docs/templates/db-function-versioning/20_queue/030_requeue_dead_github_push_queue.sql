create or replace function archive.requeue_dead_github_push_queue(
    p_limit integer default 100
)
returns integer
language plpgsql
as $function$
declare
    v_count integer;
begin
    with target_rows as (
        select q.id
        from archive.github_push_queue q
        where q.status = 'dead'
        order by q.id
        limit p_limit
        for update skip locked
    )
    update archive.github_push_queue q
    set status = 'pending',
        try_count = 0,
        last_error = null
    from target_rows t
    where q.id = t.id;

    get diagnostics v_count = row_count;
    return v_count;
end;
$function$;
