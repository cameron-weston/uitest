-- Enable RLS on tables first
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

-- Create is_admin view to check if the current user is an admin
DROP VIEW IF EXISTS public.is_admin;

CREATE VIEW public.is_admin AS
SELECT
  (
    EXISTS (
      SELECT 1
      FROM user_api
      WHERE user_api.id = auth.uid()
        AND user_api.profile = 'admin'::profile_type
    )
  ) AS is_admin;

-- Create a recursive view of all subordinates (excluding self)
DROP VIEW IF EXISTS my_subordinates;

CREATE VIEW public.my_subordinates AS
WITH RECURSIVE sub_tree AS (
  -- Base case: start with the current user's own employee row
  SELECT *
  FROM employees
  WHERE user_id = auth.uid()

  UNION ALL

  -- Recursive step: find employees whose manager_id is in the tree so far
  SELECT e.*
  FROM employees e
  JOIN sub_tree st ON e.manager_id = st.id
)
SELECT * 
FROM sub_tree
WHERE id <> (
  SELECT id
  FROM employees
  WHERE user_id = auth.uid()
);

-- Create unassigned_employees view to list employees without a user_id
CREATE VIEW public.unassigned_employees AS
SELECT
  e.id,
  e.first_name,
  e.last_name
FROM public.employees e
  LEFT JOIN public.user_api u ON e.id = u.id
WHERE e.user_id IS NULL;

-- Grant necessary permissions
GRANT SELECT ON employees TO authenticated;
GRANT SELECT ON jobs TO authenticated;
GRANT SELECT ON is_admin TO authenticated;
GRANT SELECT ON my_subordinates TO authenticated;
GRANT SELECT ON unassigned_employees TO authenticated;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Admin users see all employees" ON employees;
DROP POLICY IF EXISTS "Admin users see all jobs" ON jobs;
DROP POLICY IF EXISTS "admin_can_view_all_employees" ON employees;
DROP POLICY IF EXISTS "admin_can_view_all_jobs" ON jobs;
DROP POLICY IF EXISTS "Managers view subordinates via view" ON employees;
DROP POLICY IF EXISTS "managers_view_subordinates_via_view" ON employees;
DROP POLICY IF EXISTS "managers_view_jobs_of_subordinates" ON jobs;

-- Admin policies (admins can see everything)
CREATE POLICY "admin_can_view_all_employees"
  ON employees
  FOR SELECT
  USING ((SELECT is_admin FROM is_admin));

CREATE POLICY "admin_can_view_all_jobs"
  ON jobs
  FOR SELECT
  USING ((SELECT is_admin FROM is_admin));

-- Manager policies (managers can see subordinates)
CREATE POLICY "managers_view_subordinates"
  ON employees
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM my_subordinates ms
      WHERE ms.id = employees.id 
    )
  );

CREATE POLICY "managers_view_jobs_of_subordinates"
  ON jobs
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM my_subordinates ms
      WHERE ms.job_id = jobs.id
    )
  );
