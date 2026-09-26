create or replace function archive.push_updated_functions_to_github(
    p_schema text default 'public',
    p_immediate_limit integer default 0
)
returns integer
language plpgsql
as $function$
declare
    v_count integer;
begin
    insert into archive.github_push_queue(item_type, function_history_id)
    select 'function', function_history_id
    from archive.update_functions(p_schema)
    on conflict (function_history_id)
        where item_type = 'function'
        do nothing;

    get diagnostics v_count = row_count;

    if p_immediate_limit > 0 then
        perform archive.process_github_push_queue(p_immediate_limit);
    end if;

    return v_count;
end;
$function$;
