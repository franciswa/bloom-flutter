const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

const supabaseUrl = 'https://yqgssgqzlflqwuahtxbk.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlxZ3NzZ3F6bGZscXd1YWh0eGJrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczODAzNjg0NSwiZXhwIjoyMDUzNjEyODQ1fQ.-HeV8LzAprwgFaJ8gSjD2c7xaYzi_ugU9ukrviNPyog';

const supabase = createClient(supabaseUrl, supabaseKey);

async function setupDatabase() {
  try {
    console.log('Setting up database...');

    // Create messages table
    console.log('\nCreating messages table...');
    const { error: messagesError } = await supabase
      .from('messages')
      .insert({
        id: '00000000-0000-0000-0000-000000000000',
        match_id: '00000000-0000-0000-0000-000000000000',
        sender_id: '00000000-0000-0000-0000-000000000000',
        content: 'test',
        is_system_message: false,
        read: false
      });

    if (messagesError && !messagesError.message.includes('duplicate key')) {
      console.error('Error creating messages table:', messagesError);
      return;
    }

    // Create RLS policies
    console.log('\nCreating RLS policies...');
    const { error: policyError } = await supabase.rpc('apply_rls_policies', {
      table_name: 'messages',
      policies: [
        {
          name: 'Users can read messages in their matches',
          operation: 'SELECT',
          using: `auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
          )`
        },
        {
          name: 'Users can insert messages in their matches',
          operation: 'INSERT',
          check: `auth.uid() = sender_id AND
          auth.uid() IN (
            SELECT user1_id FROM matches WHERE id = match_id
            UNION
            SELECT user2_id FROM matches WHERE id = match_id
          )`
        }
      ]
    });

    if (policyError) {
      console.error('Error creating RLS policies:', policyError);
      return;
    }

    // Enable realtime
    console.log('\nEnabling realtime...');
    const { error: realtimeError } = await supabase.rpc('enable_realtime', {
      table_name: 'messages'
    });

    if (realtimeError) {
      console.error('Error enabling realtime:', realtimeError);
      return;
    }

    console.log('\nDatabase setup completed successfully!');

  } catch (error) {
    console.error('Error:', error);
  }
}

setupDatabase();
