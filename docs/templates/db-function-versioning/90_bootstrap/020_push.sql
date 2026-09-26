create or replace function archive.push()
returns void
language plpgsql
as $function$
begin
    perform archive.push_updated_functions_to_github('archive', 0);
    perform archive.push_updated_functions_to_github('public', 0);
    perform archive.push_updated_tables_to_github('archive', 0);
    perform archive.push_updated_tables_to_github('public', 0);
end;
$function$;
