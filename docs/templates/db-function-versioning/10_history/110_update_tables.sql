CREATE OR REPLACE FUNCTION archive.update_tables(schema_name text DEFAULT 'public'::text)
 RETURNS TABLE(table_history_id bigint, schema text, table_name text)
 LANGUAGE plpgsql
AS $function$
DECLARE
  table_record record;
  v_changed boolean;
  v_last_id bigint;
  v_ddl text;
BEGIN
  UPDATE archive.table_history th
  SET active = false
  WHERE th.schema_name = update_tables.schema_name;

  FOR table_record IN (
    SELECT
      n.nspname AS schema_name,
      c.relname AS table_name
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = update_tables.schema_name
      AND c.relkind IN ('r', 'p')
  )
  LOOP
    v_ddl := archive.build_table_ddl(table_record.table_name, table_record.schema_name);

    v_changed := archive.update_table_history(
      table_record.table_name,
      v_ddl,
      table_record.schema_name
    );

    IF v_changed THEN
      SELECT th.id
      INTO v_last_id
      FROM archive.table_history th
      WHERE th.schema_name = table_record.schema_name
        AND th.table_name  = table_record.table_name
      ORDER BY th.id DESC
      LIMIT 1;

      table_history_id := v_last_id;
      schema := table_record.schema_name;
      table_name := table_record.table_name;

      RETURN NEXT;
    END IF;
  END LOOP;
END;
$function$
