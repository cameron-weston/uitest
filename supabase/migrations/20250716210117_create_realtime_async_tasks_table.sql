CREATE TYPE public.status AS ENUM (
  'in_progress',
  'done',
  'error'
);

CREATE TABLE public.async_tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  endpoint text        NOT NULL,
  status   public.status NOT NULL DEFAULT 'in_progress',
  payload  jsonb       NOT NULL,
  errors   text[]      NULL,  -- New column for error messages
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER PUBLICATION supabase_realtime
  ADD TABLE public.async_tasks;
