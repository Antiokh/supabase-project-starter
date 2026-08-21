create or replace function archive.github_push_queue_summary()
returns table (
    status text,
    item_count bigint,
    min_created_at timestamptz,
    max_created_at timestamptz,
    max_try_count integer
)
language sql
stable
as $function$
    select
        q.status,
        count(*) as item_count,
        min(q.created_at) as min_created_at,
        max(q.created_at) as max_created_at,
        max(q.try_count) as max_try_count
    from archive.github_push_queue q
    group by q.status
    order by q.status;
$function$;
