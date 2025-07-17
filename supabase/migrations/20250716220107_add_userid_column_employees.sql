-- Add user_id column to employees table
ALTER TABLE public.employees 
ADD COLUMN user_id uuid;

-- Add index for better query performance
CREATE INDEX idx_employees_user_id ON public.employees(user_id);

-- Update existing employees with matching user_id from auth.users
UPDATE public.employees 
SET user_id = auth_users.id
FROM auth.users auth_users
WHERE employees.email = auth_users.email;

-- Optional: Add foreign key constraint to maintain referential integrity
ALTER TABLE public.employees 
ADD CONSTRAINT fk_employees_user_id 
FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;

-- NOTE: When I started this project I did not realize there was an auth.users table.
-- I realized later that instead of using auth.uid(), you probably wanted me to use
-- JWT.Email() to match the authenticated user to the employees table. I decided against this in the 
-- beginning because I thought it might be more secure to match on an id rather than an email.