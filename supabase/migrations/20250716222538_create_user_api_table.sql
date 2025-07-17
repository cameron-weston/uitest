-- Create user_api table to store users and their profiles
CREATE TABLE public.user_api (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  profile profile_type NOT NULL
);

-- Add index on email for better query performance
CREATE INDEX idx_user_api_email ON public.user_api(email);

-- Add index on profile for filtering
CREATE INDEX idx_user_api_profile ON public.user_api(profile);

-- Seed users into user_api table
INSERT INTO public.user_api (id, name, email, profile)
SELECT 
  au.id,
  CASE 
    WHEN au.email = 'david.anderson@example.com' THEN 'David'
    WHEN au.email = 'emma.williams@example.com' THEN 'Emma'
  END as name,
  au.email,
  CASE 
    WHEN au.email = 'david.anderson@example.com' THEN 'manager'::profile_type
    WHEN au.email = 'emma.williams@example.com' THEN 'admin'::profile_type
  END as profile
FROM auth.users au
WHERE au.email IN ('david.anderson@example.com', 'emma.williams@example.com');

-- Grant permissions
GRANT SELECT ON user_api TO authenticated;