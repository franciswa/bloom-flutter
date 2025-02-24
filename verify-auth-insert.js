const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

async function testAuthAndInsert() {
  if (!supabaseUrl || !supabaseAnonKey) {
    console.error('Missing Supabase credentials');
    return;
  }

  const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: {
      autoRefreshToken: true,
      persistSession: true,
      detectSessionInUrl: false
    }
  });

  // Use a test user that's already confirmed
  const testEmail = 'test@bloomapp.dev';
  const testPassword = 'test123456';

  try {
    // Sign in with test account
    console.log('Signing in with test account...');
    const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
      email: testEmail,
      password: testPassword
    });

    if (signInError) {
      console.error('Sign in error:', signInError);
      return;
    }

    if (!signInData.session) {
      console.error('No session after sign in');
      return;
    }

    const userId = signInData.user.id;
    console.log('Successfully signed in as:', userId);

    // Create a test match
    console.log('Creating test match...');
    const { data: matchData, error: matchError } = await supabase
      .from('matches')
      .insert({
        user1_id: userId,
        user2_id: '00000000-0000-0000-0000-000000000000',
        status: 'pending',
        compatibility_score: 0
      })
      .select()
      .single();

    if (matchError) {
      console.error('Match creation error:', matchError);
      return;
    }

    console.log('Test match created:', matchData.id);

    // Insert a message
    console.log('Attempting to insert a message...');
    const { data: messageData, error: messageError } = await supabase
      .from('messages')
      .insert({
        match_id: matchData.id,
        sender_id: userId,
        content: 'Test message from authenticated user'
      })
      .select();

    if (messageError) {
      console.error('Message insert error:', messageError);
    } else {
      console.log('Successfully inserted message:', messageData);
      console.log('Message structure:', Object.keys(messageData[0]));
    }

  } catch (err) {
    console.error('Error during test:', err);
  }
}

testAuthAndInsert();
