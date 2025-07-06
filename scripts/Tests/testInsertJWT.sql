-- 1. Set the role to 'authenticated'
set role authenticated;

-- 2. Set a fake JWT payload with your desired values
select set_config(
  'request.jwt.claims',
  '{"sub": "c8f019fc-73a4-48e8-909e-5ae50e49812a", "email": "david.anderson@example.com", "role": "authenticated"}',
  true
);

-- 3. Inspect the spoofed JWT
select auth.jwt();
