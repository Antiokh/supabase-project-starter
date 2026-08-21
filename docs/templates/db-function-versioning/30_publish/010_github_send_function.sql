create or replace function archive.github_send_function(p_function_history_id bigint)
returns void
language plpgsql
security definer
set search_path to 'public', 'archive'
as $function$
declare
    fh record;
begin
    select
        schema_name,
        function_name
    into fh
    from archive.function_history
    where id = p_function_history_id;

    perform public.call_edge_function(
        'github-send',
        jsonb_build_object(
            'schema', fh.schema_name,
            'function_name', fh.function_name,
            'overloads',
            (
                select jsonb_agg(
                    jsonb_build_object(
                        'language', lang_settings,
                        'args', args,
                        'return_type', return_type,
                        'source_code', source_code
                    )
                    order by lang_settings, args, return_type
                )
                from archive.function_history
                where schema_name = fh.schema_name
                  and function_name = fh.function_name
                  and active = true
            )
        )
    );
end;
$function$;

