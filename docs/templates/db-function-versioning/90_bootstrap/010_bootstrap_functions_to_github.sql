create or replace function archive.bootstrap_functions_to_github(
    p_schema text default 'public',
    p_immediate_limit integer default 50
)
returns integer
language plpgsql
as $function$
declare
    v_count integer;
begin
    insert into archive.github_push_queue(function_history_id)
    select id
    from archive.function_history
    where schema_name = p_schema
      and active = true
    on conflict do nothing;

    get diagnostics v_count = row_count;

    perform archive.process_github_push_queue(p_immediate_limit);

    return v_count;
end;
$function$;

