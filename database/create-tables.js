const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabase = createClient(
  process.env.EXPO_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

async function createTables() {
  try {
    console.log('Creating profiles table...');
    
    // Create profiles table
    await supabase.from('profiles').upsert({
      id: '00000000-0000-0000-0000-000000000000',
      user_id: '00000000-0000-0000-0000-000000000000',
      name: 'temp',
      birth_info: {
        date: '1990-01-01',
        time: '12:00',
        latitude: 0,
        longitude: 0,
        city: 'temp'
      },
      photos: [],
      personality_ratings: {},
      lifestyle_ratings: {},
      values_ratings: {},
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    });

    // Delete temporary row
    await supabase
      .from('profiles')
      .delete()
      .eq('id', '00000000-0000-0000-0000-000000000000');

    console.log('Tables created successfully');
  } catch (error) {
    if (error.message.includes('already exists')) {
      console.log('Tables already exist');
      return;
    }
    console.error('Error:', error);
  }
}

createTables();
