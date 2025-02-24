const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

async function checkSchema() {
  if (!supabaseUrl || !supabaseAnonKey) {
    console.error('Missing Supabase credentials');
    return;
  }

  const supabase = createClient(supabaseUrl, supabaseAnonKey);

  try {
    console.log('Checking messages table schema...');
    
    // Get table definition
    const { data, error } = await supabase
      .from('messages')
      .select()
      .limit(1)
      .select('*');

    if (error) {
      throw error;
    }

    // Get column information
    const { data: columns, error: columnsError } = await supabase
      .rpc('get_table_columns', { table_name: 'messages' });

    if (columnsError) {
      console.log('Could not get detailed column information:', columnsError);
    } else {
      console.log('Table columns:', columns);
    }

    console.log('Current table structure:', Object.keys(data[0] || {}));

  } catch (err) {
    console.error('Error checking schema:', err);
  }
}

checkSchema();
