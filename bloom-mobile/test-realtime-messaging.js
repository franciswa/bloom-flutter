const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://yqgssgqzlflqwuahtxbk.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlxZ3NzZ3F6bGZscXd1YWh0eGJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgwMzY4NDUsImV4cCI6MjA1MzYxMjg0NX0.ZBD5Oy1WwdqFIfl8Kgt1nkE2bYOVTYrpFj-WcOEqrYY';

const supabase = createClient(supabaseUrl, supabaseKey);

async function testRealtimeMessaging() {
  try {
    console.log('Testing realtime messaging functionality...');

    // First, let's check the table structure
    console.log('\nChecking table structure...');
    const { data: tableInfo, error: tableError } = await supabase
      .from('messages')
      .select('*')
      .limit(1);

    if (tableError) {
      console.error('Table error:', tableError);
      console.log('Please run the SQL setup script in the Supabase dashboard first.');
      return;
    }

    // Set up realtime subscription
    console.log('\nSetting up realtime subscription...');
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
          console.log('\nReceived realtime message:', JSON.stringify(payload.new, null, 2));
        }
      )
      .subscribe((status) => {
        console.log('Subscription status:', status);
      });

    // Wait a moment for subscription to be established
    await new Promise(resolve => setTimeout(resolve, 1000));

    // Get existing messages
    console.log('\nChecking existing messages...');
    const { data: messages, error: messagesError } = await supabase
      .from('messages')
      .select(`
        id,
        match_id,
        sender_id,
        content,
        created_at,
        updated_at
      `)
      .order('created_at', { ascending: false })
      .limit(5);

    if (messagesError) {
      console.error('Error fetching messages:', messagesError);
    } else {
      console.log('Recent messages:', JSON.stringify(messages, null, 2));
    }

    // Create test users if needed
    console.log('\nCreating test users...');
    const { data: user1, error: error1 } = await supabase.auth.signUp({
      email: `test1_${Date.now()}@example.com`,
      password: 'testpassword123'
    });

    if (error1) {
      console.error('Error creating test user 1:', error1);
      return;
    }

    const { data: user2, error: error2 } = await supabase.auth.signUp({
      email: `test2_${Date.now()}@example.com`,
      password: 'testpassword123'
    });

    if (error2) {
      console.error('Error creating test user 2:', error2);
      return;
    }

    // Create a test match
    console.log('\nCreating test match...');
    const { data: match, error: matchError } = await supabase
      .from('matches')
      .insert({
        user1_id: user1.user.id,
        user2_id: user2.user.id,
        status: 'pending',
        compatibility_score: 0
      })
      .select()
      .single();

    if (matchError) {
      console.error('Error creating match:', matchError);
      return;
    }

    console.log('Test match created:', JSON.stringify(match, null, 2));

    // Try to insert a test message
    console.log('\nAttempting to insert a test message...');
    const { data: newMessage, error: insertError } = await supabase
      .from('messages')
      .insert({
        match_id: match.id,
        sender_id: user1.user.id,
        content: 'Test message for realtime updates'
      })
      .select()
      .single();

    if (insertError) {
      console.error('Error inserting test message:', insertError);
    } else {
      console.log('Successfully inserted test message:', JSON.stringify(newMessage, null, 2));
    }

    // Wait for realtime updates
    console.log('\nWaiting for realtime updates (5 seconds)...');
    await new Promise(resolve => setTimeout(resolve, 5000));

    // Cleanup
    console.log('\nCleaning up...');
    await channel.unsubscribe();

    console.log('\nTest completed successfully!');

  } catch (error) {
    console.error('Error during test:', error);
  }
}

// Run the test
testRealtimeMessaging();
