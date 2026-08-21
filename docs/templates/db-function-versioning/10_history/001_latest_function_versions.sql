create or replace view archive.latest_function_versions as
select *
from archive.function_history
where active = true
order by
    schema_name,
    function_name,
    args,
    return_type;

