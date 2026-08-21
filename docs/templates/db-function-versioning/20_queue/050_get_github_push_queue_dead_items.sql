create or replace function archive.get_github_push_queue_dead_items(
    p_limit integer default 50
)
returns table (
    queue_id bigint,
    function_history_id bigint,
    schema_name text,
    function_name text,
    args text,
    return_type text,
    try_count integer,
    last_error text,
    created_at timestamptz
)
language sql
stable
as $function$
    select
        q.id as queue_id,
        q.function_history_id,
        fh.schema_name,
        fh.function_name,
        fh.args,
        fh.return_type,
        q.try_count,
        q.last_error,
        q.created_at
    from archive.github_push_queue q
    join archive.function_history fh
      on fh.id = q.function_history_id
    where q.status = 'dead'
    order by q.id desc
    limit p_limit;
$function$;
