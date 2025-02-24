import { supabase } from '../lib/supabase';

async function verifySupabase() {
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

// Run the verification
verifySupabase();
