const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://yqgssgqzlflqwuahtxbk.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlxZ3NzZ3F6bGZscXd1YWh0eGJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgwMzY4NDUsImV4cCI6MjA1MzYxMjg0NX0.ZBD5Oy1WwdqFIfl8Kgt1nkE2bYOVTYrpFj-WcOEqrYY';

const supabase = createClient(supabaseUrl, supabaseKey);

async function testMessaging() {
  try {
    console.log('Testing messaging functionality...');

    // First, let's check if the messages table exists
    console.log('\nChecking messages table...');
    const { data: tableInfo, error: tableError } = await supabase
      .from('messages')
      .select('*')
      .limit(1);

    if (tableError) {
      console.log('Messages table error:', tableError);
      console.log('Please run the SQL setup script first to create the messages table.');
      return;
    }

    console.log('Messages table exists');

    // Try to get existing messages
    console.log('\nChecking existing messages...');
    const { data: existingMessages, error: messagesError } = await supabase
      .from('messages')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(5);

    if (messagesError) {
      console.error('Error fetching messages:', messagesError);
    } else {
      console.log('Recent messages:', existingMessages);
    }

    // Try to get existing matches
    console.log('\nChecking existing matches...');
    const { data: existingMatches, error: matchesError } = await supabase
      .from('matches')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(5);

    if (matchesError) {
      console.error('Error fetching matches:', matchesError);
    } else {
      console.log('Recent matches:', existingMatches);
    }

    // Test realtime subscription
    console.log('\nTesting realtime subscription...');
    const channel = supabase
      .channel('messages-test')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'messages'
        },
        (payload) => {
          console.log('Received realtime message:', payload.new);
        }
      )
      .subscribe();

    // Wait for a moment to see if we receive any realtime updates
    console.log('\nWaiting for realtime events...');
    await new Promise(resolve => setTimeout(resolve, 5000));

    // Cleanup
    channel.unsubscribe();

    console.log('\nMessaging test completed successfully!');

  } catch (error) {
    console.error('Error testing messaging:', error);
  }
}

testMessaging();
