CREATE OR REPLACE FUNCTION archive.github_send_tables(schema_name text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'archive'
AS $function$
DECLARE
  v_table_count integer;
BEGIN
  SELECT count(*)
  INTO v_table_count
  FROM archive.table_history th
  WHERE th.schema_name = github_send_tables.schema_name
    AND th.active = true;

  IF coalesce(v_table_count, 0) = 0 THEN
    RAISE EXCEPTION 'No active table DDL found for schema=%', github_send_tables.schema_name;
  END IF;

  PERFORM public.call_edge_function(
    'github-send',
    jsonb_build_object(
      'schema', github_send_tables.schema_name,
      'tables',
      (
        SELECT jsonb_agg(
          jsonb_build_object(
            'table_name', th.table_name,
            'ddl', th.ddl
          )
          ORDER BY th.table_name
        )
        FROM archive.table_history th
        WHERE th.schema_name = github_send_tables.schema_name
          AND th.active = true
      )
    )
  );
END;
$function$;
