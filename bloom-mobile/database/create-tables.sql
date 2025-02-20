-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Messages table
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_system_message BOOLEAN DEFAULT false,
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Archived messages table
CREATE TABLE IF NOT EXISTS public.archived_messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    match_id UUID NOT NULL,
    sender_id UUID NOT NULL,
    content TEXT NOT NULL,
    is_system_message BOOLEAN DEFAULT false,
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS messages_match_id_idx ON messages(match_id);
CREATE INDEX IF NOT EXISTS messages_sender_id_idx ON messages(sender_id);
CREATE INDEX IF NOT EXISTS archived_messages_match_id_idx ON archived_messages(match_id);
CREATE INDEX IF NOT EXISTS archived_messages_sender_id_idx ON archived_messages(sender_id);

-- Enable RLS
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE archived_messages ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can read messages in their matches" ON messages;
DROP POLICY IF EXISTS "Users can insert messages in their matches" ON messages;
DROP POLICY IF EXISTS "Users can update their own messages" ON messages;
DROP POLICY IF EXISTS "Users can read their archived messages" ON archived_messages;

-- Create policies
CREATE POLICY "Users can read messages in their matches"
    ON messages FOR SELECT
    USING (
        auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
        )
    );

CREATE POLICY "Users can insert messages in their matches"
    ON messages FOR INSERT
    WITH CHECK (
        auth.uid() = sender_id AND
        auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
        )
    );

CREATE POLICY "Users can update their own messages"
    ON messages FOR UPDATE
    USING (auth.uid() = sender_id)
    WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Users can read their archived messages"
    ON archived_messages FOR SELECT
    USING (
        auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
        )
    );

-- Add trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_messages_updated_at ON messages;
CREATE TRIGGER update_messages_updated_at
    BEFORE UPDATE ON messages
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable realtime
BEGIN;
DROP PUBLICATION IF EXISTS supabase_realtime;
CREATE PUBLICATION supabase_realtime;
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
COMMIT;

-- Grant necessary permissions
GRANT ALL ON messages TO postgres;
GRANT ALL ON archived_messages TO postgres;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO postgres;
