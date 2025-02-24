const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

if (!process.env.EXPO_PUBLIC_SUPABASE_URL || !process.env.SUPABASE_SERVICE_KEY) {
  console.error('Missing required environment variables. Please check your .env file.');
  process.exit(1);
}

const supabase = createClient(
  process.env.EXPO_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

async function setupDatabase() {
  try {
    console.log('Setting up database...');

    // Try to sign in with test user credentials
    const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
      email: 'test@example.com',
      password: 'test123'
    });

    let userId;

    if (signInError) {
      // If sign in fails, try to create the user
      const { data: user, error: createError } = await supabase.auth.admin.createUser({
        email: 'test@example.com',
        password: 'test123',
        email_confirm: true
      });

      if (createError && !createError.message.includes('already exists')) {
        console.error('Error creating test user:', createError);
        return;
      }
      userId = user?.id;
    } else {
      userId = signInData.user?.id;
    }

    if (!userId) {
      console.error('No user ID found');
      return;
    }

    console.log('✓ Test user verified, ID:', userId);

    // Create test profile
    const { error: profileError } = await supabase
      .from('profiles')
      .upsert({
        id: userId,
        user_id: userId,
        name: 'Test User',
        birth_info: {
          date: '1990-01-01',
          time: '12:00',
          latitude: 37.7749,
          longitude: -122.4194,
          city: 'San Francisco'
        },
        photos: [],
        personality_ratings: {},
        lifestyle_ratings: {},
        values_ratings: {}
      });

    if (profileError) {
      console.error('Error creating test profile:', profileError);
      return;
    }
    console.log('✓ Test profile created');

    console.log('\nDatabase setup completed successfully!');

  } catch (error) {
    console.error('Error:', error);
  }
}

setupDatabase();
