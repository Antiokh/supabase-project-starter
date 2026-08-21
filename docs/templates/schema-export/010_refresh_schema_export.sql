create table if not exists public.schema_export_snapshots (
    id bigserial primary key,
    snapshot jsonb not null,
    created_at timestamptz not null default now()
);

create index if not exists schema_export_snapshots_created_at_idx
    on public.schema_export_snapshots (created_at desc);

create or replace function public.refresh_schema_export()
returns bigint
language plpgsql
as $function$
declare
    v_id bigint;
begin
    insert into public.schema_export_snapshots(snapshot)
    values (public.get_complete_schema())
    returning id into v_id;

    return v_id;
end;
$function$;
