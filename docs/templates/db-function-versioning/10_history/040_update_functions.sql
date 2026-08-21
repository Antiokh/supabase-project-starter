create or replace function archive.update_functions(schema_name text default 'public')
returns table(
    function_history_id bigint,
    schema text,
    function_name text,
    args text,
    return_type text
)
language plpgsql
as $function$
declare
    function_record record;
    v_changed boolean;
    v_last_id bigint;
begin
    update archive.function_history fh
    set active = false
    where fh.schema_name = update_functions.schema_name;

    for function_record in (
        select
            n.nspname as schema_name,
            p.proname as function_name,
            pg_catalog.pg_get_function_arguments(p.oid) as args,
            pg_catalog.pg_get_function_result(p.oid) as return_type,
            pg_catalog.pg_get_functiondef(p.oid) as source_code,
            l.lanname as lang_settings
        from pg_catalog.pg_proc p
        join pg_catalog.pg_namespace n on n.oid = p.pronamespace
        join pg_catalog.pg_language l on l.oid = p.prolang
        where n.nspname = update_functions.schema_name
    )
    loop
        v_changed := archive.update_function_history(
            function_record.function_name,
            function_record.args,
            function_record.return_type,
            function_record.source_code,
            function_record.schema_name,
            function_record.lang_settings
        );

        if v_changed then
            select fh.id
            into v_last_id
            from archive.function_history fh
            where fh.schema_name = function_record.schema_name
              and fh.function_name = function_record.function_name
              and fh.args = function_record.args
              and fh.return_type = function_record.return_type
              and fh.lang_settings = function_record.lang_settings
            order by fh.id desc
            limit 1;

            function_history_id := v_last_id;
            schema := function_record.schema_name;
            function_name := function_record.function_name;
            args := function_record.args;
            return_type := function_record.return_type;

            return next;
        end if;
    end loop;
end;
$function$;

