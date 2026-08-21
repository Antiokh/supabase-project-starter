create or replace function archive.push()
returns void
language plpgsql
as $function$
begin
    perform archive.push_updated_functions_to_github('archive');
    perform archive.push_updated_functions_to_github('public');
end;
$function$;
