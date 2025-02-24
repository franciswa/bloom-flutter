const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

async function testRealtime() {
  if (!supabaseUrl || !supabaseAnonKey) {
    console.error('Missing Supabase credentials');
    return;
  }

  const supabase = createClient(supabaseUrl, supabaseAnonKey);

  try {
    console.log('Setting up realtime subscription...');
    
    // Subscribe to changes
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
          console.log('Received new message:', payload.new);
        }
      )
      .subscribe();

    console.log('Subscription active, inserting test message...');

    // Insert a test message
    const { data, error } = await supabase
      .from('messages')
      .insert({
        match_id: '00000000-0000-0000-0000-000000000000', // Test match ID
        sender_id: '00000000-0000-0000-0000-000000000000', // Test sender ID
        content: 'Test message ' + new Date().toISOString(),
        is_system_message: true,
        read: false
      })
      .select();

    if (error) {
      throw error;
    }

    console.log('Test message inserted:', data);
    console.log('Waiting for realtime update...');

    // Wait for a few seconds to receive the realtime update
    await new Promise(resolve => setTimeout(resolve, 5000));

    // Cleanup
    await channel.unsubscribe();
    console.log('Test complete');

  } catch (err) {
    console.error('Error during test:', err);
  }
}

testRealtime();
