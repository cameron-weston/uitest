on "public"."employees"
to authenticated
using (
  ((auth.jwt() ->> 'email'::text) = (email)::text)
);