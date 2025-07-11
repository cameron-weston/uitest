CREATE VIEW public.is_admin AS
SELECT
  (
    EXISTS (
      SELECT
        1
      FROM
        user_api
      WHERE
        user_api.id = auth.uid ()
        AND user_api.profile = 'admin'::profile_type
    )
  ) AS is_admin;