create or replace view public.unassigned_employees as
select
  e.id,
  e.first_name,
  e.last_name
from public.employees e
  left join public.user_api u on e.id = u.id
where e.user_id is null;