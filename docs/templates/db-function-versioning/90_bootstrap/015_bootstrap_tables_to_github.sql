create or replace function archive.bootstrap_tables_to_github(
    p_schema text default 'public',
    p_immediate_limit integer default 0
)
returns integer
language plpgsql
as $function$
declare
    v_revision_id bigint;
    v_count integer;
begin
    perform archive.setup_table_history(p_schema);

    select max(th.id), count(*)
    into v_revision_id, v_count
    from archive.table_history th
    where th.schema_name = p_schema
      and th.active = true;

    if v_revision_id is not null then
        insert into archive.github_push_queue(
            item_type, table_history_id, schema_name
        )
        values ('table_bundle', v_revision_id, p_schema)
        on conflict (table_history_id)
            where item_type = 'table_bundle'
            do nothing;
    end if;

    if p_immediate_limit > 0 then
        perform archive.process_github_push_queue(p_immediate_limit);
    end if;

    return coalesce(v_count, 0);
end;
$function$;
