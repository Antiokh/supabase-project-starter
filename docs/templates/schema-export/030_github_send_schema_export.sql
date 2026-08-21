create or replace function public.github_send_schema_export(
    p_path text default 'db/ddl.json'
)
returns jsonb
language plpgsql
as $function$
declare
    v_snapshot jsonb;
begin
    select snapshot
    into v_snapshot
    from public.schema_export_snapshots
    order by created_at desc, id desc
    limit 1;

    if v_snapshot is null then
        raise exception 'no schema export snapshot available';
    end if;

    return public.call_edge_function(
        'github-send',
        jsonb_build_object(
            'path', p_path,
            'content', jsonb_pretty(v_snapshot),
            'message', 'schema export refresh: ' || p_path
        )
    );
end;
$function$;
