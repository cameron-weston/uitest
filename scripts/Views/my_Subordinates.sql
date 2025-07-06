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
