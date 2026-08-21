create or replace function archive.diff_text(old_text text, new_text text)
returns table(line_no integer, old_line text, new_line text)
language sql
as $function$
    select
        row_number() over () as line_no,
        o.line,
        n.line
    from regexp_split_to_table(coalesce(old_text, ''), E'\n') with ordinality o(line, ord)
    full join regexp_split_to_table(coalesce(new_text, ''), E'\n') with ordinality n(line, ord)
        using (ord)
    where o.line is distinct from n.line;
$function$;

