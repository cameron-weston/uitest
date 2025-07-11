-- 1. Enable RLS on jobs (if not already)
ALTER TABLE jobs
  ENABLE ROW LEVEL SECURITY;

-- 2. Grant SELECT to your authenticated role
GRANT SELECT ON jobs TO authenticated;

-- 3. Policy: allow reading only jobs assigned to your subordinates
CREATE POLICY "Managers view jobs of subordinates"
  ON jobs
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM my_subordinates ms
      WHERE ms.job_id = jobs.id
    )
  );
