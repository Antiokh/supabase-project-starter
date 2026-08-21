create or replace function public.refresh_and_publish_schema_export(
    p_path text default 'db/ddl.json'
)
returns jsonb
language plpgsql
as $function$
begin
    perform public.refresh_schema_export();
    return public.github_send_schema_export(p_path);
end;
$function$;
