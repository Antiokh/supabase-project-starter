CREATE OR REPLACE FUNCTION archive.update_table_history(table_name text, ddl text, schema_name text DEFAULT 'public'::text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'archive'
AS $function$
DECLARE
  v_prev_id     bigint;
  v_prev_ddl    text;
  v_prev_active boolean;
BEGIN
  SELECT th.id, th.ddl, th.active
  INTO v_prev_id, v_prev_ddl, v_prev_active
  FROM archive.table_history th
  WHERE th.schema_name = update_table_history.schema_name
    AND th.table_name  = update_table_history.table_name
  ORDER BY th.id DESC
  LIMIT 1;

  IF v_prev_ddl IS NOT NULL THEN
    IF NOT EXISTS (
      SELECT 1
      FROM archive.diff_text(v_prev_ddl, ddl)
    ) THEN
      IF NOT v_prev_active THEN
        UPDATE archive.table_history th
        SET active = false
        WHERE th.schema_name = update_table_history.schema_name
          AND th.table_name  = update_table_history.table_name;

        UPDATE archive.table_history
        SET active = true
        WHERE id = v_prev_id;
      END IF;

      RETURN false;
    END IF;
  END IF;

  UPDATE archive.table_history th
  SET active = false
  WHERE th.schema_name = update_table_history.schema_name
    AND th.table_name  = update_table_history.table_name;

  INSERT INTO archive.table_history (
    schema_name,
    table_name,
    ddl,
    active
  )
  VALUES (
    schema_name,
    table_name,
    ddl,
    true
  );

  RETURN true;
END;
$function$
