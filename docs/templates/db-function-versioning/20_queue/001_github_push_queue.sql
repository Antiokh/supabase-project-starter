create table if not exists archive.github_push_queue (
    id bigserial primary key,
    function_history_id bigint not null,
    status text not null default 'pending',
    try_count integer not null default 0,
    last_error text null,
    created_at timestamptz not null default now(),
    pushed_at timestamptz null
);

do $$
begin
    if not exists (
        select 1
        from pg_constraint
        where conname = 'github_push_queue_status_check'
    ) then
        alter table archive.github_push_queue
            add constraint github_push_queue_status_check
            check (status in ('pending', 'done', 'dead'));
    end if;
end
$$;

create unique index if not exists github_push_queue_function_history_id_uidx
    on archive.github_push_queue (function_history_id);

create index if not exists github_push_queue_status_idx
    on archive.github_push_queue (status, id);
