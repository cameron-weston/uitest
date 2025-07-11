-- First, drop the existing policy
DROP POLICY IF EXISTS "Managers view subordinates via view" ON employees;

ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

-- Grant usage on the view to your authenticated role
GRANT SELECT ON my_subordinates TO authenticated;

-- Policy: allow SELECT only if the row is in the view
CREATE POLICY "Managers view subordinates via view"
  ON employees
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM my_subordinates ms
      WHERE ms.id = employees.id 
    )
  );
