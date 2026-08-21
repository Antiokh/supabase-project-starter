create or replace function archive.push_updated_functions_to_github(
    p_schema text default 'public',
    p_immediate_limit integer default 40
)
returns integer
language plpgsql
as $function$
declare
    v_count integer;
begin
    insert into archive.github_push_queue(function_history_id)
    select function_history_id
    from archive.update_functions(p_schema);
    on conflict (function_history_id) do nothing;

    get diagnostics v_count = row_count;

    perform archive.process_github_push_queue(p_immediate_limit);

    return v_count;
end;
$function$;
