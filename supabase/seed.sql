-- supabase/seed.sql
--
-- create test users
INSERT INTO
    auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        recovery_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
    ) values (
            '00000000-0000-0000-0000-000000000000',
            uuid_generate_v4 (),
            'authenticated',
            'authenticated',
            'david.anderson@example.com',
            crypt ('password123', gen_salt ('bf')),
            current_timestamp,
            current_timestamp,
            current_timestamp,
            '{"provider":"email","providers":["email"]}',
            '{}',
            current_timestamp,
            current_timestamp,
            '',
            '',
            '',
            ''
    ),
    (
            '00000000-0000-0000-0000-000000000000',
            uuid_generate_v4 (),
            'authenticated',
            'authenticated',
            'emma.williams@example.com',
            crypt ('password123', gen_salt ('bf')),
            current_timestamp,
            current_timestamp,
            current_timestamp,
            '{"provider":"email","providers":["email"]}',
            '{}',
            current_timestamp,
            current_timestamp,
            '',
            '',
            '',
            ''
    );

INSERT INTO
    auth.identities (
        id,
        user_id,
        provider_id,
        identity_data,
        provider,
        last_sign_in_at,
        created_at,
        updated_at
    ) (
        select
            uuid_generate_v4 (),
            id,
            id as user_id,
            format('{"sub":"%s","email":"%s"}', id::text, email)::jsonb,
            'email',
            current_timestamp,
            current_timestamp,
            current_timestamp
        from
            auth.users
        where
          email LIKE '%@example.com' -- here
    );

INSERT INTO public.departments (id, created_at, name) VALUES
('8ec83f57-4f5d-4fd6-a8d2-4d7c153f7ad1', '2023-11-27 12:00:00+00', 'Sales'),
('e4ac31a5-719f-4a7f-89e0-6fba3306b48b', '2023-11-27 13:15:00+00', 'Marketing'),
('3a5a4d96-12ef-4d3e-9fb7-890efc1f2e9d', '2023-11-27 14:30:00+00', 'Finance'),
('b58282c8-8b41-4a6f-9fe4-c6c0c6da61f0', '2023-11-27 15:45:00+00', 'IT'),
('f22e0e02-1f91-42a2-bb69-4d8bb33bdf51', '2023-11-27 16:00:00+00', 'Human Resources'),
('6a4397e1-b57e-4c21-83fc-d8dbb853bb58', '2023-11-27 17:30:00+00', 'Research and Development'),
('a02daab7-8a15-4f04-b5d1-ea4e51dd6d37', '2023-11-27 18:45:00+00', 'Customer Support'),
('d0c32595-9205-4fcf-aeb4-371b8ce1ad6a', '2023-11-27 19:15:00+00', 'Legal'),
('25c90e15-336d-4874-91cc-26c94458b9e5', '2023-11-27 20:30:00+00', 'Product Management'),
('9c50897e-e35d-42f9-aaac-70a08bbf3d76', '2023-11-27 21:00:00+00', 'Quality Assurance');

INSERT INTO public.jobs (id, created_at, name, department_id) VALUES
('c24f0343-8f05-4829-9e35-3f3a248ff65a', '2023-11-28 05:28:05.201892+00', 'Software Engineer', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58'),
('0813a92f-2b7e-4c8d-9803-e0f88187741d', '2023-11-28 05:28:05.201892+00', 'Data Scientist', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58'),
('b4c07b36-0bf9-4f69-b1fc-0d8f7e30adbf', '2023-11-28 05:28:05.201892+00', 'Research Analyst', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58'),
('9d0a70c1-66f8-415d-8f03-3f22f3a5b769', '2023-11-28 05:28:05.201892+00', 'Machine Learning Engineer', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58'),
('8c5f341e-5e3e-4aae-8a36-eeb80d1c38cf', '2023-11-28 05:28:05.201892+00', 'Quality Assurance Engineer', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58'),
('ac3e0d1b-0572-465f-bb82-924ee42ef4a7', '2023-11-28 05:28:05.201892+00', 'Product Manager', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58'),
('1ff3ddc1-89a4-4cf9-82d2-7f2255804d69', '2023-11-28 05:28:05.201892+00', 'Research Scientist', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58'),
('34ea8b42-0921-4774-84b1-6d6ed4f1872b', '2023-11-28 05:28:05.201892+00', 'Data Engineer', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58'),
('257d170c-87b0-4e53-8de0-c43bc1bb24c4', '2023-11-28 05:28:05.201892+00', 'DevOps Engineer', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58'),
('990ea64b-30d1-43db-ba09-7081c49b6ba4', '2023-11-28 05:28:05.201892+00', 'UX/UI Designer', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58'),
('5f1ef614-bef5-448b-8b29-2a43823a0cc5', '2023-11-28 05:37:43.241977+00', 'Marketing Specialist', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b'),
('b98c7ad1-8af0-4c54-a1a7-1564da67481a', '2023-11-28 05:37:43.241977+00', 'Content Writer', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b'),
('cd73133e-5974-4cfd-a748-2533e703a335', '2023-11-28 05:37:43.241977+00', 'Digital Marketing Manager', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b'),
('8a8fb450-3b37-4df5-93df-5cbb2ac48e0f', '2023-11-28 05:37:43.241977+00', 'Social Media Coordinator', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b'),
('a52b366d-865f-4ed0-a3cd-5ab23c758e2d', '2023-11-28 05:37:43.241977+00', 'SEO Specialist', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b'),
('7d3cf249-b312-4a43-bf1f-831a9b64a99c', '2023-11-28 05:37:43.241977+00', 'Brand Manager', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b'),
('cc3bb2d7-6cc5-44e3-8c69-ee55a1bf731c', '2023-11-28 05:37:43.241977+00', 'Event Coordinator', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b'),
('bfd2a2fe-5403-47d4-85db-3e1d8316e5c5', '2023-11-28 05:37:43.241977+00', 'Graphic Designer', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b'),
('b27bc186-8d27-4306-8554-1730f65182d1', '2023-11-28 05:37:43.241977+00', 'Market Research Analyst', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b'),
('aed64cfb-6e8d-44ec-9be6-cb8490e68c1d', '2023-11-28 05:37:43.241977+00', 'Public Relations Specialist', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b');

INSERT INTO public.employees (id, created_at, first_name, last_name, salary, bonus, equity, start_date, manager_id, email, department_id, job_id) VALUES
('6f902f1a-c3f3-4d82-ba1a-4c93d0b5bf2e', '2023-11-28 05:32:41.367011+00', 'David', 'Anderson', 85000.00, 5500.00, 25000.00, '2023-06-15', '80b77e11-7b42-4ec9-8be4-12ce58180f91', 'david.anderson@example.com', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58', 'ac3e0d1b-0572-465f-bb82-924ee42ef4a7'),
('80b77e11-7b42-4ec9-8be4-12ce58180f91', '2023-11-28 05:34:15.560608+00', 'John', 'Doe', 80000.00, 5000.00, 20000.00, '2023-01-15', NULL, 'john.doe@example.com', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58', 'c24f0343-8f05-4829-9e35-3f3a248ff65a'),
('b2ac02fb-dcb2-41d1-892d-c20677a68ec9', '2023-11-28 05:34:15.560608+00', 'Alice', 'Johnson', 70000.00, 4000.00, 30000.00, '2023-02-01', '6f902f1a-c3f3-4d82-ba1a-4c93d0b5bf2e', 'alice.johnson@example.com', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58', '0813a92f-2b7e-4c8d-9803-e0f88187741d'),
('f5daa68f-c7df-4de7-8d3a-93fb1728a7a9', '2023-11-28 05:34:15.560608+00', 'Michael', 'Smith', 90000.00, 6000.00, 40000.00, '2023-03-10', '6f902f1a-c3f3-4d82-ba1a-4c93d0b5bf2e', 'michael.smith@example.com', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58', 'b4c07b36-0bf9-4f69-b1fc-0d8f7e30adbf'),
('8c3d51f7-cac4-4014-8db3-79d017e81a3a', '2023-11-28 05:34:15.560608+00', 'Emily', 'Brown', 75000.00, 4500.00, 15000.00, '2023-04-20', '6f902f1a-c3f3-4d82-ba1a-4c93d0b5bf2e', 'emily.brown@example.com', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58', '9d0a70c1-66f8-415d-8f03-3f22f3a5b769'),
('bb97f8b8-6e7b-4b0f-b535-8790ea0a6fb2', '2023-11-28 05:34:15.560608+00', 'Jessica', 'White', 100000.00, 7000.00, 30000.00, '2023-05-05', 'b2ac02fb-dcb2-41d1-892d-c20677a68ec9', 'jessica.white@example.com', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58', '8c5f341e-5e3e-4aae-8a36-eeb80d1c38cf'),
('2be3f354-c51b-446b-bb9d-58d89e61e73e', '2023-11-28 05:34:15.560608+00', 'Sophia', 'Taylor', 72000.00, 4200.00, 30000.00, '2023-07-01', 'b2ac02fb-dcb2-41d1-892d-c20677a68ec9', 'sophia.taylor@example.com', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58', '1ff3ddc1-89a4-4cf9-82d2-7f2255804d69'),
('a0c8f7aa-f4e1-4f6f-8a77-3528f729d5c2', '2023-11-28 05:34:15.560608+00', 'Ryan', 'Miller', 95000.00, 6500.00, 12000.00, '2023-08-10', 'f5daa68f-c7df-4de7-8d3a-93fb1728a7a9', 'ryan.miller@example.com', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58', '34ea8b42-0921-4774-84b1-6d6ed4f1872b'),
('7b75de78-77d7-4e71-9e3f-67cb6f01bc9c', '2023-11-28 05:34:15.560608+00', 'Olivia', 'Martinez', 110000.00, 8000.00, 45000.00, '2023-09-20', 'f5daa68f-c7df-4de7-8d3a-93fb1728a7a9', 'olivia.martinez@example.com', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58', '257d170c-87b0-4e53-8de0-c43bc1bb24c4'),
('3e5543c3-e2f9-4c13-a88c-305a2eacfa48', '2023-11-28 05:34:15.560608+00', 'Daniel', 'Wilson', 80000.00, 5000.00, 20000.00, '2023-10-05', '8c3d51f7-cac4-4014-8db3-79d017e81a3a', 'daniel.wilson@example.com', '6a4397e1-b57e-4c21-83fc-d8dbb853bb58', '990ea64b-30d1-43db-ba09-7081c49b6ba4'),
('c344cd0d-55b7-42f7-9f86-50b1bbf696c2', '2023-11-28 05:40:30.579724+00', 'Emma', 'Williams', 75000.00, 4000.00, 15000.00, '2023-01-15', '8c3d51f7-cac4-4014-8db3-79d017e81a3a', 'emma.williams@example.com', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b', '5f1ef614-bef5-448b-8b29-2a43823a0cc5'),
('a7f256d9-1a15-4e4e-879f-c4f7b7f4c4f4', '2023-11-28 05:41:14.900017+00', 'James', 'Davis', 80000.00, 5000.00, 20000.00, '2023-02-01', 'c344cd0d-55b7-42f7-9f86-50b1bbf696c2', 'james.davis@example.com', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b', 'b98c7ad1-8af0-4c54-a1a7-1564da67481a'),
('be31a890-3091-48de-a7c8-c5e4ba93f646', '2023-11-28 05:41:14.900017+00', 'Sophie', 'Smith', 90000.00, 6000.00, 25000.00, '2023-03-10', 'c344cd0d-55b7-42f7-9f86-50b1bbf696c2', 'sophie.smith@example.com', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b', 'cd73133e-5974-4cfd-a748-2533e703a335'),
('79e1192c-0d7a-4c3e-92ce-4603871092f0', '2023-11-28 05:41:14.900017+00', 'Benjamin', 'Jones', 70000.00, 4500.00, 18000.00, '2023-04-20', 'c344cd0d-55b7-42f7-9f86-50b1bbf696c2', 'benjamin.jones@example.com', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b', '8a8fb450-3b37-4df5-93df-5cbb2ac48e0f'),
('eb37b598-c8cb-45d8-a6c8-e8e8c77a4aef', '2023-11-28 05:41:14.900017+00', 'Olivia', 'Johnson', 85000.00, 5500.00, 20000.00, '2023-05-05', 'c344cd0d-55b7-42f7-9f86-50b1bbf696c2', 'olivia.johnson@example.com', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b', 'a52b366d-865f-4ed0-a3cd-5ab23c758e2d'),
('ad3f62cd-3357-4e3f-8ebc-665d4bb735ec', '2023-11-28 05:41:14.900017+00', 'Daniel', 'Taylor', 95000.00, 6500.00, 30000.00, '2023-06-15', NULL, 'daniel.taylor@example.com', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b', '7d3cf249-b312-4a43-bf1f-831a9b64a99c'),
('78e2e295-e2e9-4a25-94cf-bc8c1f939c18', '2023-11-28 05:41:14.900017+00', 'Amelia', 'Miller', 72000.00, 4200.00, 18000.00, '2023-07-01', 'c344cd0d-55b7-42f7-9f86-50b1bbf696c2', 'amelia.miller@example.com', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b', 'cc3bb2d7-6cc5-44e3-8c69-ee55a1bf731c'),
('0c800a45-4b0b-44ab-bb2c-cb3f99c26863', '2023-11-28 05:41:14.900017+00', 'William', 'Brown', 80000.00, 5000.00, 25000.00, '2023-08-10', 'c344cd0d-55b7-42f7-9f86-50b1bbf696c2', 'william.brown@example.com', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b', 'bfd2a2fe-5403-47d4-85db-3e1d8316e5c5'),
('a2c5855b-0db0-4af2-b073-bc94c30be0f4', '2023-11-28 05:41:14.900017+00', 'Grace', 'Davis', 110000.00, 8000.00, 45000.00, '2023-09-20', NULL, 'grace.davis@example.com', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b', 'b27bc186-8d27-4306-8554-1730f65182d1'),
('b6cfd06b-2d92-4a9a-b9c1-071b2de2c4ee', '2023-11-28 05:41:14.900017+00', 'Jack', 'Wilson', 80000.00, 5000.00, 20000.00, '2023-10-05', 'c344cd0d-55b7-42f7-9f86-50b1bbf696c2', 'jack.wilson@example.com', 'e4ac31a5-719f-4a7f-89e0-6fba3306b48b', 'aed64cfb-6e8d-44ec-9be6-cb8490e68c1d');

-- Add user_id column to employees table
ALTER TABLE public.employees ADD COLUMN IF NOT EXISTS user_id uuid;

-- Add index for better query performance
CREATE INDEX IF NOT EXISTS idx_employees_user_id ON public.employees(user_id);

-- NOTE: When I started this project I did not realize there was an auth.users table.
-- I realized later that instead of using auth.uid(), you probably wanted me to use
-- JWT.Email() to match the authenticated user to the employees table. I decided against this in the 
-- beginning because I thought it might be more secure to match on an id rather than an email.

-- Update existing employees with matching user_id from auth.users
UPDATE public.employees 
SET user_id = auth_users.id
FROM auth.users auth_users
WHERE employees.email = auth_users.email;

-- Create profile_type enum if it doesn't exist
DO $$ BEGIN
    CREATE TYPE profile_type AS ENUM ('admin', 'manager');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Create user_api table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.user_api (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  profile profile_type NOT NULL
);

-- Add indexes
CREATE INDEX IF NOT EXISTS idx_user_api_email ON public.user_api(email);
CREATE INDEX IF NOT EXISTS idx_user_api_profile ON public.user_api(profile);

-- Seed users into user_api table
INSERT INTO public.user_api (id, name, email, profile)
SELECT 
  au.id,
  CASE 
    WHEN au.email = 'david.anderson@example.com' THEN 'David Anderson'
    WHEN au.email = 'emma.williams@example.com' THEN 'Emma Williams'
  END as name,
  au.email,
  CASE 
    WHEN au.email = 'david.anderson@example.com' THEN 'manager'::profile_type
    WHEN au.email = 'emma.williams@example.com' THEN 'admin'::profile_type
  END as profile
FROM auth.users au
WHERE au.email IN ('david.anderson@example.com', 'emma.williams@example.com')
ON CONFLICT (id) DO NOTHING;

-- Grant permissions
GRANT SELECT ON user_api TO authenticated;

