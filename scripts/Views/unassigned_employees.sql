CREATE OR REPLACE VIEW public.unassigned_employees AS
SELECT
  e.id,
  e.first_name,
  e.last_name
FROM public.employees e
  LEFT JOIN public.user_api u ON e.id = u.id
WHERE e.user_id IS NULL;