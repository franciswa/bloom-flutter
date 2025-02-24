import { testSupabaseConnection } from '../services/testSupabase';

jest.setTimeout(30000); // Set timeout for all tests

describe('Supabase Connection Tests', () => {
  it('should connect to Supabase and verify messages table', async () => {
    const result = await testSupabaseConnection();
    console.log('Supabase Connection Test Result:', JSON.stringify(result, null, 2));

    // Log any errors from the connection attempt
    if (result.error) {
      console.error('Connection Error:', result.error);
    }
    
    // Test connection
    expect(result.connected).toBe(true);
    
    if (!result.messagesTableExists) {
      console.warn(`
WARNING: Messages table does not exist in Supabase.
Please create the following tables in your Supabase database:

CREATE TABLE messages (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  match_id UUID NOT NULL,
  sender_id UUID NOT NULL,
  content TEXT NOT NULL,
  is_system_message BOOLEAN DEFAULT false,
  read BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now())
);

CREATE TABLE archived_messages (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  match_id UUID NOT NULL,
  sender_id UUID NOT NULL,
  content TEXT NOT NULL,
  is_system_message BOOLEAN DEFAULT false,
  read BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE,
  updated_at TIMESTAMP WITH TIME ZONE,
  archived_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now())
);

-- Enable Row Level Security (RLS)
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE archived_messages ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can read messages in their matches" ON messages
  FOR SELECT USING (
    auth.uid() IN (
      SELECT user1_id FROM matches WHERE id = match_id
      UNION
      SELECT user2_id FROM matches WHERE id = match_id
    )
  );

CREATE POLICY "Users can insert messages in their matches" ON messages
  FOR INSERT WITH CHECK (
    auth.uid() IN (
      SELECT user1_id FROM matches WHERE id = match_id
      UNION
      SELECT user2_id FROM matches WHERE id = match_id
    )
  );

-- Create indexes
CREATE INDEX messages_match_id_idx ON messages(match_id);
CREATE INDEX messages_sender_id_idx ON messages(sender_id);
CREATE INDEX archived_messages_match_id_idx ON archived_messages(match_id);
CREATE INDEX archived_messages_sender_id_idx ON archived_messages(sender_id);

-- Enable realtime
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
`);
    }
  });
});
