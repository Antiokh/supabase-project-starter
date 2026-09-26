create table if not exists archive.table_history (
    id bigserial primary key,
    schema_name text not null,
    table_name text not null,
    ddl text not null,
    updated_at timestamptz not null default now(),
    version integer not null default 1,
    active boolean not null default false,
    dropped boolean not null default false
);

alter table archive.table_history
    add column if not exists dropped boolean not null default false;

create index if not exists table_history_lookup_idx
    on archive.table_history (schema_name, table_name, id desc);

create index if not exists table_history_active_idx
    on archive.table_history (schema_name, table_name)
    where active = true;
