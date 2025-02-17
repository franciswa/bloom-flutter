-- Create archived_messages table
CREATE TABLE IF NOT EXISTS archived_messages (
  id UUID PRIMARY KEY,
  match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  content TEXT NOT NULL,
  is_system_message BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
  archived_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Add indexes
CREATE INDEX IF NOT EXISTS archived_messages_match_id_idx ON archived_messages(match_id);
CREATE INDEX IF NOT EXISTS archived_messages_sender_id_idx ON archived_messages(sender_id);
CREATE INDEX IF NOT EXISTS archived_messages_created_at_idx ON archived_messages(created_at DESC);
CREATE INDEX IF NOT EXISTS archived_messages_archived_at_idx ON archived_messages(archived_at DESC);

-- Add RLS policies
ALTER TABLE archived_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own archived messages"
  ON archived_messages FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM matches m
      WHERE m.id = match_id
      AND (m.user1_id = auth.uid() OR m.user2_id = auth.uid())
    )
  );

-- Create function to cleanup old archived messages
CREATE OR REPLACE FUNCTION cleanup_old_archived_messages()
RETURNS void AS $$
BEGIN
  -- Delete archived messages older than 1 year
  DELETE FROM archived_messages
  WHERE archived_at < NOW() - INTERVAL '1 year';
END;
$$ LANGUAGE plpgsql;

-- Create scheduled job for cleanup (runs monthly)
SELECT cron.schedule(
  'cleanup-archived-messages',
  '0 0 1 * *',  -- At midnight on the first day of every month
  'SELECT cleanup_old_archived_messages()'
);
