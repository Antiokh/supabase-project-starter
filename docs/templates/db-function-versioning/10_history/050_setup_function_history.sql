create or replace function archive.setup_function_history(schema_name text default 'public')
returns void
language plpgsql
as $function$
declare
    function_record record;
begin
    update archive.function_history fh
    set active = false
    where fh.schema_name = setup_function_history.schema_name;

    for function_record in (
        select
            n.nspname as schema_name,
            p.proname as function_name,
            pg_catalog.pg_get_function_arguments(p.oid) as args,
            pg_catalog.pg_get_function_result(p.oid) as return_type,
            pg_catalog.pg_get_functiondef(p.oid) as source_code,
            l.lanname as lang_settings
        from pg_catalog.pg_proc p
        left join pg_catalog.pg_namespace n on n.oid = p.pronamespace
        left join pg_catalog.pg_language l on l.oid = p.prolang
        where n.nspname = schema_name
    )
    loop
        perform archive.save_function_history(
            function_record.function_name,
            function_record.args,
            function_record.return_type,
            function_record.source_code,
            function_record.schema_name,
            function_record.lang_settings
        );
    end loop;
end;
$function$;
