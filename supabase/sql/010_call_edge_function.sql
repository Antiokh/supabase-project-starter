/*
Starter helper for calling an Edge Function from SQL.

Important:
- Do not commit real service keys in this file.
- Replace the placeholder settings with your own secure configuration approach.
- Recommended options:
  - database vault / secret store
  - deployment-time substitution
  - controlled manual install outside git
*/

create extension if not exists http with schema extensions;

create or replace function public.call_edge_function(function_path text, payload jsonb)
returns jsonb
language plpgsql
as $function$
declare
    /*
     * Replace these placeholders with a project-specific secure setup.
     *
     * Examples:
     * - a project-local constant injected during deployment
     * - a value read from a secure DB-side secret mechanism
     */
    edge_base_url text := '__SET_EDGE_BASE_URL__';
    service_role_key text := '__SET_SERVICE_ROLE_KEY__';
    full_url text;
    response_json jsonb;
begin
    if edge_base_url like '__SET_%' or service_role_key like '__SET_%' then
        raise exception 'call_edge_function is not configured';
    end if;

    full_url := rtrim(edge_base_url, '/') || '/' || ltrim(function_path, '/');

    response_json := (
        select content::jsonb
        from extensions.http((
            'POST',
            full_url,
            array[
                extensions.http_header('Content-Type', 'application/json'),
                extensions.http_header('apikey', service_role_key),
                extensions.http_header('Authorization', 'Bearer ' || service_role_key)
            ],
            'application/json',
            payload::text
        )::extensions.http_request)
    );

    return response_json;
end;
$function$;

