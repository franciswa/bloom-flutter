const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabase = createClient(
  process.env.EXPO_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  }
);

async function initTables() {
  try {
    console.log('Creating tables...');

    // Try to create profile to test structure
    const { error: profileError } = await supabase.from('profiles').select('*').limit(1);

    // If table doesn't exist, create it
    if (profileError && profileError.code === '42P01') {
      console.log('Creating profiles table...');

      // Create the table using raw SQL
      const { error: createError } = await supabase.from('profiles').insert([
        {
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
        }
      ]);

      if (createError && createError.code === '42P01') {
        // Table doesn't exist, let's try to create it through the management API
        const response = await fetch(`${process.env.EXPO_PUBLIC_SUPABASE_URL}/rest/v1/`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${process.env.SUPABASE_SERVICE_KEY}`,
            'apikey': process.env.SUPABASE_SERVICE_KEY
          },
          body: JSON.stringify({
            command: `
              CREATE TABLE IF NOT EXISTS public.profiles (
                id UUID REFERENCES auth.users(id) PRIMARY KEY,
                user_id UUID REFERENCES auth.users(id),
                name TEXT,
                birth_info JSONB,
                photos JSONB[],
                personality_ratings JSONB,
                lifestyle_ratings JSONB,
                values_ratings JSONB,
                created_at TIMESTAMPTZ DEFAULT now(),
                updated_at TIMESTAMPTZ DEFAULT now()
              );

              ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

              CREATE POLICY "Users can view their own profile"
                ON profiles FOR SELECT
                USING (auth.uid() = user_id);

              CREATE POLICY "Users can update their own profile"
                ON profiles FOR UPDATE
                USING (auth.uid() = user_id)
                WITH CHECK (auth.uid() = user_id);
            `
          })
        });

        if (!response.ok) {
          const error = await response.json();
          console.error('Error creating table:', error);
          return;
        }

        console.log('Table created successfully');
      }
    }

    console.log('Database setup completed successfully');
  } catch (error) {
    console.error('Error:', error);
  }
}

initTables();
