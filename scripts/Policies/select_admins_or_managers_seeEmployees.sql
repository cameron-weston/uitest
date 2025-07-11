-- First, drop the existing policy
DROP POLICY IF EXISTS "Admins see all and managers see subordinates" ON employees;

-- Create a new policy that handles both admins and managers
CREATE POLICY "Admins see all and managers see subordinates"
  ON employees
  FOR SELECT
  USING (
    -- Check if user is admin
    EXISTS (
      SELECT 1 
      FROM employees e 
      JOIN user_api ua ON e.user_id = ua.id
      WHERE ua.id = auth.uid() 
      AND ua.profile = 'admin'
    )
    OR
    -- If not admin, use the existing subordinates view logic
    EXISTS (
      SELECT 1
      FROM my_subordinates ms
      WHERE ms.id = employees.id 
    )
  );