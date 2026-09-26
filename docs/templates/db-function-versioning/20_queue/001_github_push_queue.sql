create table if not exists archive.github_push_queue (
    id bigserial primary key,
    item_type text not null default 'function',
    function_history_id bigint null,
    table_history_id bigint null,
    schema_name text null,
    status text not null default 'pending',
    try_count integer not null default 0,
    last_error text null,
    created_at timestamptz not null default now(),
    pushed_at timestamptz null
);

alter table archive.github_push_queue
    add column if not exists item_type text not null default 'function',
    add column if not exists table_history_id bigint null,
    add column if not exists schema_name text null;

alter table archive.github_push_queue
    alter column function_history_id drop not null;

do $$
begin
    if not exists (
        select 1 from pg_constraint
        where conrelid = 'archive.github_push_queue'::regclass
          and conname = 'github_push_queue_status_check'
    ) then
        alter table archive.github_push_queue
            add constraint github_push_queue_status_check
            check (status in ('pending', 'done', 'dead'));
    end if;

    if not exists (
        select 1 from pg_constraint
        where conrelid = 'archive.github_push_queue'::regclass
          and conname = 'github_push_queue_item_type_check'
    ) then
        alter table archive.github_push_queue
            add constraint github_push_queue_item_type_check
            check (item_type in ('function', 'table_bundle'));
    end if;

    if not exists (
        select 1 from pg_constraint
        where conrelid = 'archive.github_push_queue'::regclass
          and conname = 'github_push_queue_item_ref_check'
    ) then
        alter table archive.github_push_queue
            add constraint github_push_queue_item_ref_check
            check (
                (item_type = 'function'
                 and function_history_id is not null
                 and table_history_id is null
                 and schema_name is null)
                or
                (item_type = 'table_bundle'
                 and function_history_id is null
                 and table_history_id is not null
                 and schema_name is not null)
            );
    end if;
end
$$;

create unique index if not exists github_push_queue_function_history_id_uidx
    on archive.github_push_queue(function_history_id)
    where item_type = 'function';

create unique index if not exists github_push_queue_table_history_id_uidx
    on archive.github_push_queue(table_history_id)
    where item_type = 'table_bundle';

create index if not exists github_push_queue_status_idx
    on archive.github_push_queue(status, id);
