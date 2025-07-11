-- Add admin policy for jobs table (keep existing policies)
CREATE POLICY "Admin users see all jobs"
  ON jobs
  FOR SELECT
  USING (
    (SELECT is_admin FROM is_admin)
  );