import { createClient } from '@supabase/supabase-js';
import { Message } from '../types/database';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!;

const supabase = createClient(supabaseUrl, supabaseKey);

async function testMessaging() {
  try {
    console.log('Testing messaging functionality...');

    // Create test users
    console.log('\nCreating test users...');
    const { data: user1, error: error1 } = await supabase.auth.signUp({
      email: `test1_${Date.now()}@example.com`,
      password: 'testpassword123',
      options: {
        data: {
          email_confirmed: true
        }
      }
    });

    if (error1) throw error1;

    const { data: user2, error: error2 } = await supabase.auth.signUp({
      email: `test2_${Date.now()}@example.com`,
      password: 'testpassword123',
      options: {
        data: {
          email_confirmed: true
        }
      }
    });

    if (error2) throw error2;

    console.log('Test users created:', {
      user1: user1.user?.id,
      user2: user2.user?.id
    });

    // Create a test match
    console.log('\nCreating test match...');
    const { data: match, error: matchError } = await supabase
      .from('matches')
      .insert({
        user1_id: user1.user!.id,
        user2_id: user2.user!.id,
        status: 'pending',
        compatibility_score: 0,
        date_type: 'Coffee',
        match_date: new Date().toISOString()
      })
      .select()
      .single();

    if (matchError) throw matchError;

    console.log('Test match created:', match.id);

    // Test sending a message
    console.log('\nTesting message sending...');
    const { data: message1, error: messageError1 } = await supabase
      .from('messages')
      .insert({
        match_id: match.id,
        sender_id: user1.user!.id,
        content: 'Hello from user 1!',
        is_system_message: false,
        read: false
      })
      .select()
      .single();

    if (messageError1) throw messageError1;

    console.log('Message 1 sent:', message1);

    // Test message retrieval
    console.log('\nTesting message retrieval...');
    const { data: messages, error: retrievalError } = await supabase
      .from('messages')
      .select('*')
      .eq('match_id', match.id)
      .order('created_at', { ascending: false });

    if (retrievalError) throw retrievalError;

    console.log('Retrieved messages:', messages);

    // Test realtime subscription
    console.log('\nTesting realtime subscription...');
    const channel = supabase
      .channel('messages-test')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'messages',
          filter: `match_id=eq.${match.id}`
        },
        (payload) => {
          console.log('Received realtime message:', payload.new);
        }
      )
      .subscribe();

    // Send another message to test realtime
    console.log('\nSending another message to test realtime...');
    const { error: messageError2 } = await supabase
      .from('messages')
      .insert({
        match_id: match.id,
        sender_id: user2.user!.id,
        content: 'Hello from user 2!',
        is_system_message: false,
        read: false
      });

    if (messageError2) throw messageError2;

    // Wait for realtime event
    await new Promise(resolve => setTimeout(resolve, 2000));

    // Cleanup
    channel.unsubscribe();

    console.log('\nMessaging test completed successfully!');

  } catch (error) {
    console.error('Error testing messaging:', error);
  }
}

testMessaging();
