/*
Reference example for a small user-owned table with RLS.

This file is starter-owned runtime SQL.
Projects may adapt, rename, or delete it after choosing their own data model.
*/

create table if not exists public.user_profiles (
    user_id uuid primary key references auth.users(id) on delete cascade,
    display_name text null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.user_profiles enable row level security;

do $$
begin
    if not exists (
        select 1
        from pg_policies
        where schemaname = 'public'
          and tablename = 'user_profiles'
          and policyname = 'user_profiles_select_own'
    ) then
        create policy user_profiles_select_own
            on public.user_profiles
            for select
            to authenticated
            using (auth.uid() = user_id);
    end if;
end
$$;

do $$
begin
    if not exists (
        select 1
        from pg_policies
        where schemaname = 'public'
          and tablename = 'user_profiles'
          and policyname = 'user_profiles_insert_own'
    ) then
        create policy user_profiles_insert_own
            on public.user_profiles
            for insert
            to authenticated
            with check (auth.uid() = user_id);
    end if;
end
$$;

do $$
begin
    if not exists (
        select 1
        from pg_policies
        where schemaname = 'public'
          and tablename = 'user_profiles'
          and policyname = 'user_profiles_update_own'
    ) then
        create policy user_profiles_update_own
            on public.user_profiles
            for update
            to authenticated
            using (auth.uid() = user_id)
            with check (auth.uid() = user_id);
    end if;
end
$$;

do $$
begin
    if not exists (
        select 1
        from pg_policies
        where schemaname = 'public'
          and tablename = 'user_profiles'
          and policyname = 'user_profiles_delete_own'
    ) then
        create policy user_profiles_delete_own
            on public.user_profiles
            for delete
            to authenticated
            using (auth.uid() = user_id);
    end if;
end
$$;
