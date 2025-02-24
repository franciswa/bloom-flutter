const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://yqgssgqzlflqwuahtxbk.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlxZ3NzZ3F6bGZscXd1YWh0eGJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgwMzY4NDUsImV4cCI6MjA1MzYxMjg0NX0.ZBD5Oy1WwdqFIfl8Kgt1nkE2bYOVTYrpFj-WcOEqrYY';

const supabase = createClient(supabaseUrl, supabaseKey);

async function verifyMessaging() {
  try {
    console.log('Starting messaging verification...');

    // Create test user 1
    console.log('\nCreating test user 1...');
    const { data: user1Data, error: error1 } = await supabase.auth.signUp({
      email: `test1_${Date.now()}@example.com`,
      password: 'testpassword123'
    });

    if (error1) {
      console.error('Error creating test user 1:', error1);
      return;
    }

    const user1 = user1Data.user;
    console.log('Created test user 1:', user1.id);

    // Create test user 2
    console.log('\nCreating test user 2...');
    const { data: user2Data, error: error2 } = await supabase.auth.signUp({
      email: `test2_${Date.now()}@example.com`,
      password: 'testpassword123'
    });

    if (error2) {
      console.error('Error creating test user 2:', error2);
      return;
    }

    const user2 = user2Data.user;
    console.log('Created test user 2:', user2.id);

    // Sign in as user 1
    console.log('\nSigning in as user 1...');
    const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
      email: user1.email,
      password: 'testpassword123'
    });

    if (signInError) {
      console.error('Error signing in:', signInError);
      return;
    }

    // Create a match between the users
    console.log('\nCreating test match...');
    const { data: match, error: matchError } = await supabase
      .from('matches')
      .insert({
        user1_id: user1.id,
        user2_id: user2.id,
        status: 'pending',
        compatibility_score: 0
      })
      .select()
      .single();

    if (matchError) {
      console.error('Error creating match:', matchError);
      return;
    }

    console.log('Created test match:', match.id);

    // Set up realtime subscription
    console.log('\nSetting up realtime subscription...');
    const channel = supabase
      .channel('messaging-test')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'messages'
        },
        (payload) => {
          console.log('\nRealtime message received:', payload.new);
        }
      )
      .subscribe((status) => {
        console.log('Subscription status:', status);
      });

    // Send a test message as user 1
    console.log('\nSending test message as user 1...');
    const { data: message1, error: messageError1 } = await supabase
      .from('messages')
      .insert({
        match_id: match.id,
        sender_id: user1.id,
        content: 'Hello from user 1!'
      })
      .select()
      .single();

    if (messageError1) {
      console.error('Error sending message as user 1:', messageError1);
    } else {
      console.log('Message 1 sent successfully:', message1);
    }

    // Sign in as user 2
    console.log('\nSigning in as user 2...');
    const { error: signInError2 } = await supabase.auth.signInWithPassword({
      email: user2.email,
      password: 'testpassword123'
    });

    if (signInError2) {
      console.error('Error signing in as user 2:', signInError2);
      return;
    }

    // Send a test message as user 2
    console.log('\nSending test message as user 2...');
    const { data: message2, error: messageError2 } = await supabase
      .from('messages')
      .insert({
        match_id: match.id,
        sender_id: user2.id,
        content: 'Hello from user 2!'
      })
      .select()
      .single();

    if (messageError2) {
      console.error('Error sending message as user 2:', messageError2);
    } else {
      console.log('Message 2 sent successfully:', message2);
    }

    // Fetch all messages for this match
    console.log('\nFetching all messages...');
    const { data: messages, error: fetchError } = await supabase
      .from('messages')
      .select('*')
      .eq('match_id', match.id)
      .order('created_at', { ascending: true });

    if (fetchError) {
      console.error('Error fetching messages:', fetchError);
    } else {
      console.log('All messages:', messages);
    }

    // Wait for any realtime events
    console.log('\nWaiting for realtime events (5 seconds)...');
    await new Promise(resolve => setTimeout(resolve, 5000));

    // Cleanup
    console.log('\nCleaning up...');
    await channel.unsubscribe();

    console.log('\nVerification completed successfully!');

  } catch (error) {
    console.error('Error during verification:', error);
  }
}

verifyMessaging();
