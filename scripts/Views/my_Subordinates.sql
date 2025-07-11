-- Drop any existing view
DROP VIEW IF EXISTS my_subordinates;

-- Create a recursive view of self + all subordinates
CREATE OR REPLACE VIEW my_subordinates AS
WITH RECURSIVE sub_tree AS (
  -- Base case: start with the current user’s own employee row
  SELECT *
  FROM employees
  WHERE user_id = auth.uid()

  UNION ALL

  -- Recursive step: find employees whose manager_id is in the tree so far
  SELECT e.*
  FROM employees e
  JOIN sub_tree st
    ON e.manager_id = st.id
)
SELECT * 
FROM sub_tree
WHERE id <> (
  SELECT id
  FROM employees
  WHERE user_id = auth.uid()
);


-- -- Test: Adding back manager name and excluding current user
-- DROP VIEW IF EXISTS my_subordinates;

-- CREATE OR REPLACE VIEW my_subordinates AS
-- WITH RECURSIVE sub_tree AS (
--   -- Base case: start with employees who report directly to the current user
--   SELECT e.*
--   FROM employees e
--   WHERE e.manager_id = (
--     SELECT id FROM employees WHERE user_id = auth.uid()
--   )

--   UNION ALL

--   -- Recursive step: find employees whose manager_id is in the tree so far
--   SELECT e.*
--   FROM employees e
--   JOIN sub_tree st ON e.manager_id = st.id
-- ),
-- -- Get top level manager info separately
-- manager_info AS (
--   SELECT id, first_name, last_name
--   FROM employees
--   WHERE user_id = auth.uid()
-- )
-- SELECT 
--   st.id,
-- st.created_at,
-- st.salary,
-- st.bonus,
-- st.equity,
-- st.start_date,
-- st.manager_id,
-- st.email,
-- st.department_id,
-- st.job_id,
-- st.user_id,
--   CASE 
--     WHEN st.manager_id = mi.id THEN mi.first_name
--     ELSE st.first_name
--   END as first_name
    -- CASE
    --     WHEN st.manager_id = mi.id THEN mi.last_name
    --     ELSE st.last_name
    -- END as last_name
-- FROM sub_tree st
-- LEFT JOIN manager_info mi ON st.manager_id = mi.id
-- WHERE st.id <> (
--   SELECT id FROM employees WHERE user_id = auth.uid()
-- );