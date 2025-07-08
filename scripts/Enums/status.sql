-- Create a new enum type called "status"
CREATE TYPE status AS ENUM (
  'in_progress',
  'done',
  'error'
);
