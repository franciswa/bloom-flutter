-- Messages table
CREATE TABLE IF NOT EXISTS messages (
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
CREATE TABLE IF NOT EXISTS archived_messages (
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

-- RLS Policies
CREATE POLICY IF NOT EXISTS "Users can read messages in their matches"
    ON messages FOR SELECT
    USING (
        auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
        )
    );

CREATE POLICY IF NOT EXISTS "Users can insert messages in their matches"
    ON messages FOR INSERT
    WITH CHECK (
        auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
        )
    );

CREATE POLICY IF NOT EXISTS "Users can read their archived messages"
    ON archived_messages FOR SELECT
    USING (
        auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
        )
    );

-- Enable realtime
BEGIN;
DROP PUBLICATION IF EXISTS supabase_realtime;
CREATE PUBLICATION supabase_realtime;
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
COMMIT;

-- Add trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_messages_updated_at
    BEFORE UPDATE ON messages
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
