SELECT e.*
FROM public.employees AS e
JOIN public.employees AS m
  ON e.manager_id = m.id
  WHERE m.email = 'david.anderson@example.com';

-- Ensure RLS is on
ALTER TABLE public.employees
  ENABLE ROW LEVEL SECURITY;

-- Create the SELECT policy using auth.jwt()
CREATE POLICY direct_reports_only
  ON public.employees
  FOR SELECT
  USING (
    SELECT e.*
    FROM public.employees AS e
    JOIN public.employees AS m
      ON e.manager_id = m.id
      WHERE m.email = 'david.anderson@example.com';
  );
