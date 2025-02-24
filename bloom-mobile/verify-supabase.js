const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

async function verifyConnection() {
  console.log('Supabase URL:', supabaseUrl);
  console.log('Supabase Key:', supabaseAnonKey ? '***' + supabaseAnonKey.slice(-4) : 'missing');

  if (!supabaseUrl || !supabaseAnonKey) {
    console.error('Missing Supabase credentials');
    return;
  }

  const supabase = createClient(supabaseUrl, supabaseAnonKey);

  try {
    console.log('Testing Supabase connection...');
    
    // Test basic connection
    const { data, error } = await supabase
      .from('messages')
      .select('*')
      .limit(1);

    if (error) {
      if (error.code === 'PGRST116') {
        console.log('Connected to Supabase, but messages table does not exist');
        return;
      }
      throw error;
    }

    console.log('Successfully connected to Supabase and messages table exists');
    console.log('Sample data:', data);

  } catch (err) {
    console.error('Failed to connect to Supabase:', err);
  }
}

verifyConnection();
