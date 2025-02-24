-- Create push_tokens table
CREATE TABLE IF NOT EXISTS push_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  token TEXT NOT NULL,
  device_id TEXT NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('ios', 'android', 'web')),
  is_valid BOOLEAN NOT NULL DEFAULT true,
  last_used_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT TIMEZONE('utc', NOW())
);

-- Add unique constraint to prevent duplicate tokens
CREATE UNIQUE INDEX IF NOT EXISTS push_tokens_token_unique_idx ON push_tokens(token) WHERE is_valid = true;
CREATE UNIQUE INDEX IF NOT EXISTS push_tokens_device_user_unique_idx ON push_tokens(device_id, user_id) WHERE is_valid = true;

-- Add indexes for common queries
CREATE INDEX IF NOT EXISTS push_tokens_user_id_idx ON push_tokens(user_id);
CREATE INDEX IF NOT EXISTS push_tokens_platform_idx ON push_tokens(platform) WHERE is_valid = true;
CREATE INDEX IF NOT EXISTS push_tokens_last_used_idx ON push_tokens(last_used_at DESC);

-- Add RLS policies
ALTER TABLE push_tokens ENABLE ROW LEVEL SECURITY;

-- Users can only view and manage their own tokens
CREATE POLICY "Users can view their own push tokens"
  ON push_tokens FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert their own push tokens"
  ON push_tokens FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their own push tokens"
  ON push_tokens FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete their own push tokens"
  ON push_tokens FOR DELETE
  USING (user_id = auth.uid());

-- Create function to update token last_used timestamp
CREATE OR REPLACE FUNCTION update_push_token_last_used()
RETURNS TRIGGER AS $$
BEGIN
  NEW.last_used_at = TIMEZONE('utc', NOW());
  NEW.updated_at = TIMEZONE('utc', NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to update last_used_at on token update
CREATE TRIGGER update_push_token_last_used_trigger
  BEFORE UPDATE ON push_tokens
  FOR EACH ROW
  EXECUTE FUNCTION update_push_token_last_used();

-- Create function to cleanup old/unused tokens
CREATE OR REPLACE FUNCTION cleanup_old_push_tokens()
RETURNS void AS $$
BEGIN
  -- Invalidate tokens not used in the last 30 days
  UPDATE push_tokens
  SET is_valid = false
  WHERE last_used_at < NOW() - INTERVAL '30 days'
  AND is_valid = true;

  -- Delete tokens that have been invalid for more than 90 days
  DELETE FROM push_tokens
  WHERE is_valid = false
  AND updated_at < NOW() - INTERVAL '90 days';
END;
$$ LANGUAGE plpgsql;

-- Create scheduled job for cleanup (runs daily)
SELECT cron.schedule(
  'cleanup-push-tokens',
  '0 0 * * *',  -- At midnight every day
  'SELECT cleanup_old_push_tokens()'
);

-- Create rollback function
CREATE OR REPLACE FUNCTION rollback_004_add_push_tokens()
RETURNS void AS $$
BEGIN
  -- Remove scheduled job
  SELECT cron.unschedule('cleanup-push-tokens');
  
  -- Remove functions and triggers
  DROP TRIGGER IF EXISTS update_push_token_last_used_trigger ON push_tokens;
  DROP FUNCTION IF EXISTS update_push_token_last_used();
  DROP FUNCTION IF EXISTS cleanup_old_push_tokens();
  
  -- Remove table and all associated objects
  DROP TABLE IF EXISTS push_tokens;
END;
$$ LANGUAGE plpgsql;
