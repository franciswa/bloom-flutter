const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

async function testInsert() {
  if (!supabaseUrl || !supabaseAnonKey) {
    console.error('Missing Supabase credentials');
    return;
  }

  const supabase = createClient(supabaseUrl, supabaseAnonKey);

  try {
    console.log('Attempting to insert a basic message...');
    
    // Try inserting with minimal required fields
    const { data, error } = await supabase
      .from('messages')
      .insert({
        match_id: '00000000-0000-0000-0000-000000000000',
        sender_id: '00000000-0000-0000-0000-000000000000',
        content: 'Test message'
      })
      .select();

    if (error) {
      console.error('Insert error:', error);
      
      // If insert failed, try to describe the table
      console.log('\nAttempting to fetch table information...');
      const { data: tableData, error: tableError } = await supabase
        .from('messages')
        .select('*')
        .limit(0);
      
      if (tableError) {
        console.error('Table info error:', tableError);
      } else {
        console.log('Table exists but might be empty');
      }
    } else {
      console.log('Successfully inserted message:', data);
      console.log('Message structure:', Object.keys(data[0]));
    }

  } catch (err) {
    console.error('Error during test:', err);
  }
}

testInsert();
