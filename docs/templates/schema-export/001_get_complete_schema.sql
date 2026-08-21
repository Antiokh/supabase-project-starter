create or replace function public.get_complete_schema()
returns jsonb
language plpgsql
as $function$
declare
    result jsonb;
begin
    with enum_types as (
        select
            t.typname as enum_name,
            array_agg(e.enumlabel order by e.enumsortorder) as enum_values
        from pg_type t
        join pg_enum e on t.oid = e.enumtypid
        join pg_catalog.pg_namespace n on n.oid = t.typnamespace
        where n.nspname = 'public'
        group by t.typname
    )
    select jsonb_build_object(
        'enums',
        coalesce(
            jsonb_agg(
                jsonb_build_object(
                    'name', enum_name,
                    'values', to_jsonb(enum_values)
                )
            ),
            '[]'::jsonb
        )
    )
    from enum_types
    into result;

    with columns_info as (
        select
            c.oid as table_oid,
            c.relname as table_name,
            a.attname as column_name,
            format_type(a.atttypid, a.atttypmod) as column_type,
            a.attnotnull as notnull,
            pg_get_expr(d.adbin, d.adrelid) as column_default,
            case
                when a.attidentity != '' then true
                when pg_get_expr(d.adbin, d.adrelid) like 'nextval%' then true
                else false
            end as is_identity,
            exists (
                select 1
                from pg_constraint con
                where con.conrelid = c.oid
                  and con.contype = 'p'
                  and a.attnum = any(con.conkey)
            ) as is_pk
        from pg_class c
        join pg_namespace n on n.oid = c.relnamespace
        left join pg_attribute a on a.attrelid = c.oid
        left join pg_attrdef d on d.adrelid = c.oid and d.adnum = a.attnum
        where n.nspname = 'public'
          and c.relkind = 'r'
          and a.attnum > 0
          and not a.attisdropped
    ),
    fk_info as (
        select
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', con.conname,
                    'column', col.attname,
                    'foreign_schema', fs.nspname,
                    'foreign_table', ft.relname,
                    'foreign_column', fcol.attname,
                    'on_delete', case con.confdeltype
                        when 'a' then 'NO ACTION'
                        when 'c' then 'CASCADE'
                        when 'r' then 'RESTRICT'
                        when 'n' then 'SET NULL'
                        when 'd' then 'SET DEFAULT'
                        else null
                    end
                )
            ) as foreign_keys
        from pg_class c
        join pg_constraint con on con.conrelid = c.oid
        join pg_attribute col on col.attrelid = con.conrelid and col.attnum = any(con.conkey)
        join pg_class ft on ft.oid = con.confrelid
        join pg_namespace fs on fs.oid = ft.relnamespace
        join pg_attribute fcol on fcol.attrelid = con.confrelid and fcol.attnum = any(con.confkey)
        where con.contype = 'f'
        group by c.oid
    ),
    index_info as (
        select
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', i.relname,
                    'using', am.amname,
                    'columns', (
                        select jsonb_agg(a.attname order by array_position(ix.indkey, a.attnum))
                        from unnest(ix.indkey) with ordinality as u(attnum, ord)
                        join pg_attribute a on a.attrelid = c.oid and a.attnum = u.attnum
                    )
                )
            ) as indexes
        from pg_class c
        join pg_index ix on ix.indrelid = c.oid
        join pg_class i on i.oid = ix.indexrelid
        join pg_am am on am.oid = i.relam
        where not ix.indisprimary
        group by c.oid
    ),
    policy_info as (
        select
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', pol.polname,
                    'command', case pol.polcmd
                        when 'r' then 'SELECT'
                        when 'a' then 'INSERT'
                        when 'w' then 'UPDATE'
                        when 'd' then 'DELETE'
                        when '*' then 'ALL'
                    end,
                    'roles', (
                        select string_agg(quote_ident(r.rolname), ', ')
                        from pg_roles r
                        where r.oid = any(pol.polroles)
                    ),
                    'using', pg_get_expr(pol.polqual, pol.polrelid),
                    'check', pg_get_expr(pol.polwithcheck, pol.polrelid)
                )
            ) as policies
        from pg_class c
        join pg_policy pol on pol.polrelid = c.oid
        group by c.oid
    ),
    trigger_info as (
        select
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', t.tgname,
                    'timing', case
                        when t.tgtype & 2 = 2 then 'BEFORE'
                        when t.tgtype & 4 = 4 then 'AFTER'
                        when t.tgtype & 64 = 64 then 'INSTEAD OF'
                    end,
                    'events', case
                        when t.tgtype & 1 = 1 then 'INSERT'
                        when t.tgtype & 8 = 8 then 'DELETE'
                        when t.tgtype & 16 = 16 then 'UPDATE'
                        when t.tgtype & 32 = 32 then 'TRUNCATE'
                    end,
                    'statement', pg_get_triggerdef(t.oid)
                )
            ) as triggers
        from pg_class c
        join pg_trigger t on t.tgrelid = c.oid
        where not t.tgisinternal
        group by c.oid
    ),
    table_info as (
        select distinct
            c.table_oid,
            c.table_name,
            jsonb_agg(
                jsonb_build_object(
                    'name', c.column_name,
                    'type', c.column_type,
                    'notnull', c.notnull,
                    'default', c.column_default,
                    'identity', c.is_identity,
                    'is_pk', c.is_pk
                ) order by c.column_name
            ) as columns,
            coalesce(fk.foreign_keys, '[]'::jsonb) as foreign_keys,
            coalesce(i.indexes, '[]'::jsonb) as indexes,
            coalesce(p.policies, '[]'::jsonb) as policies,
            coalesce(t.triggers, '[]'::jsonb) as triggers
        from columns_info c
        left join fk_info fk on fk.table_oid = c.table_oid
        left join index_info i on i.table_oid = c.table_oid
        left join policy_info p on p.table_oid = c.table_oid
        left join trigger_info t on t.table_oid = c.table_oid
        group by c.table_oid, c.table_name, fk.foreign_keys, i.indexes, p.policies, t.triggers
    )
    select result || jsonb_build_object(
        'tables',
        coalesce(
            jsonb_agg(
                jsonb_build_object(
                    'name', table_name,
                    'columns', columns,
                    'foreign_keys', foreign_keys,
                    'indexes', indexes,
                    'policies', policies,
                    'triggers', triggers
                )
            ),
            '[]'::jsonb
        )
    )
    from table_info
    into result;

    with function_info as (
        select
            p.proname as name,
            pg_get_function_identity_arguments(p.oid) as identity_args,
            pg_get_function_result(p.oid) as return_type,
            pg_get_functiondef(p.oid) as definition
        from pg_proc p
        join pg_namespace n on n.oid = p.pronamespace
        where n.nspname = 'public'
          and p.prokind = 'f'
    )
    select result || jsonb_build_object(
        'functions',
        coalesce(
            jsonb_agg(
                jsonb_build_object(
                    'name', name,
                    'identity_args', identity_args,
                    'return_type', return_type,
                    'definition', definition
                )
            ),
            '[]'::jsonb
        )
    )
    from function_info
    into result;

    with view_info as (
        select
            n.nspname as schema_name,
            c.relname as name,
            case c.relkind
                when 'v' then 'view'
                when 'm' then 'materialized_view'
            end as kind,
            pg_get_viewdef(c.oid, true) as definition
        from pg_class c
        join pg_namespace n on n.oid = c.relnamespace
        where n.nspname = 'public'
          and c.relkind in ('v', 'm')
    )
    select result || jsonb_build_object(
        'views',
        coalesce(
            jsonb_agg(
                jsonb_build_object(
                    'schema', schema_name,
                    'name', name,
                    'kind', kind,
                    'definition', definition
                )
            ),
            '[]'::jsonb
        )
    )
    from view_info
    into result;

    return result;
end;
$function$;

