/*
Starter install scaffold for DB function versioning.

This is intentionally not a production-ready one-click installer.

Reason:
- extension availability depends on deployment mode
- Cloud, local CLI, and self-hosted setups may differ
- some environments may not allow all required steps

Use this file as a starter reference and adapt it per project.
*/

create extension if not exists http with schema extensions;

/*
If your environment supports pg_tle and dbdev:

1. install or enable pg_tle
2. install supabase-dbdev
3. install mansueli-function_vc

Example flow from prior projects:

select pgtle.uninstall_extension_if_exists('supabase-dbdev');
drop extension if exists "supabase-dbdev";

select pgtle.install_extension(
    'supabase-dbdev',
    resp.contents ->> 'version',
    'PostgreSQL package manager',
    resp.contents ->> 'sql'
)
from http((
    'GET',
    'https://api.database.dev/rest/v1/'
        || 'package_versions?select=sql,version'
        || '&package_name=eq.supabase-dbdev'
        || '&order=version.desc'
        || '&limit=1',
    array[
        ('apiKey', '__SET_DBDEV_API_KEY__')::http_header
    ],
    null,
    null
)) x,
lateral (
    select ((row_to_json(x) -> 'content') #>> '{}')::json -> 0
) resp(contents);

create extension "supabase-dbdev";
select dbdev.install('supabase-dbdev');
select dbdev.install('mansueli-function_vc');
create extension "mansueli-function_vc" version '1.0.1';
*/

/*
After the extension layer is installed, apply starter-specific baseline changes such as:

- `active` flag support
- latest-version views
- queue objects
- publication helpers
*/

