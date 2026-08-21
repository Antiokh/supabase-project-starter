create extension if not exists pgcrypto;

create table if not exists public.debug_events (
    id uuid primary key default gen_random_uuid(),
    created_at timestamptz not null default now(),
    source text not null,
    message text not null,
    payload jsonb null
);

create index if not exists debug_events_created_at_idx
    on public.debug_events (created_at desc);

create index if not exists debug_events_source_idx
    on public.debug_events (source);

