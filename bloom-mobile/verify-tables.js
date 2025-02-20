const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

async function checkTables() {
  if (!supabaseUrl || !supabaseAnonKey) {
    console.error('Missing Supabase credentials');
    return;
  }

  const supabase = createClient(supabaseUrl, supabaseAnonKey);

  try {
    // Check profiles table
    console.log('\nChecking profiles table...');
    const { data: profileData, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .limit(1);

    if (profileError) {
      console.error('Profiles table error:', profileError);
    } else {
      console.log('Profiles table exists');
      if (profileData.length > 0) {
        console.log('Profile structure:', Object.keys(profileData[0]));
      } else {
        console.log('Profiles table is empty');
      }
    }

    // Check matches table
    console.log('\nChecking matches table...');
    const { data: matchData, error: matchError } = await supabase
      .from('matches')
      .select('*')
      .limit(1);

    if (matchError) {
      console.error('Matches table error:', matchError);
    } else {
      console.log('Matches table exists');
      if (matchData.length > 0) {
        console.log('Match structure:', Object.keys(matchData[0]));
      } else {
        console.log('Matches table is empty');
      }
    }

    // Check messages table
    console.log('\nChecking messages table...');
    const { data: messageData, error: messageError } = await supabase
      .from('messages')
      .select('*')
      .limit(1);

    if (messageError) {
      console.error('Messages table error:', messageError);
    } else {
      console.log('Messages table exists');
      if (messageData.length > 0) {
        console.log('Message structure:', Object.keys(messageData[0]));
      } else {
        console.log('Messages table is empty');
      }
    }

  } catch (err) {
    console.error('Error checking tables:', err);
  }
}

checkTables();
