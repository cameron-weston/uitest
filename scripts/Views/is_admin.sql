create view public.is_admin as
select
  (
    exists (
      select
        1
      from
        user_api
      where
        user_api.id = auth.uid ()
        and user_api.profile = 'admin'::profile_type
    )
  ) as is_admin;