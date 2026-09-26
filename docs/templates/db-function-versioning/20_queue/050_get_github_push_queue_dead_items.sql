drop function if exists archive.get_github_push_queue_dead_items(integer);

create function archive.get_github_push_queue_dead_items(
    p_limit integer default 50
)
returns table (
    queue_id bigint,
    item_type text,
    function_history_id bigint,
    table_history_id bigint,
    schema_name text,
    object_name text,
    try_count integer,
    last_error text,
    created_at timestamptz
)
language sql
stable
as $function$
    select
        q.id,
        q.item_type,
        q.function_history_id,
        q.table_history_id,
        coalesce(fh.schema_name, th.schema_name),
        coalesce(fh.function_name, th.table_name),
        q.try_count,
        q.last_error,
        q.created_at
    from archive.github_push_queue q
    left join archive.function_history fh on fh.id = q.function_history_id
    left join archive.table_history th on th.id = q.table_history_id
    where q.status = 'dead'
    order by q.id desc
    limit p_limit;
$function$;
