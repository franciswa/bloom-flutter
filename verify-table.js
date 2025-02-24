const { createClient } = require('@supabase/supabase-js');
const fetch = require('node-fetch');
require('dotenv').config();

const SERVICE_ROLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlxZ3NzZ3F6bGZscXd1YWh0eGJrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczODAzNjg0NSwiZXhwIjoyMDUzNjEyODQ1fQ.-HeV8LzAprwgFaJ8gSjD2c7xaYzi_ugU9ukrviNPyog';

const supabase = createClient(
  process.env.EXPO_PUBLIC_SUPABASE_URL,
  SERVICE_ROLE_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  }
);

async function verifyTable() {
  try {
    console.log('Verifying table structure...');

    // Try to create the table using direct REST API
    const response = await fetch(`${process.env.EXPO_PUBLIC_SUPABASE_URL}/rest/v1/rpc/create_profiles_table`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${SERVICE_ROLE_KEY}`,
        'apikey': SERVICE_ROLE_KEY
      },
      body: JSON.stringify({})
    });

    // First create the stored procedure
    await supabase.rpc('create_stored_procedure', {
      sql: `
        CREATE OR REPLACE FUNCTION create_profiles_table()
        RETURNS void AS $$
        BEGIN
          CREATE TABLE IF NOT EXISTS public.profiles (
            id UUID REFERENCES auth.users(id) PRIMARY KEY,
            user_id UUID REFERENCES auth.users(id),
            name TEXT,
            birth_info JSONB DEFAULT '{}'::jsonb,
            photos JSONB[] DEFAULT ARRAY[]::jsonb[],
            personality_ratings JSONB DEFAULT '{}'::jsonb,
            lifestyle_ratings JSONB DEFAULT '{}'::jsonb,
            values_ratings JSONB DEFAULT '{}'::jsonb,
            created_at TIMESTAMPTZ DEFAULT now(),
            updated_at TIMESTAMPTZ DEFAULT now()
          );

          ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

          DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
          DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
          DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;

          CREATE POLICY "Users can view their own profile"
            ON profiles FOR SELECT
            USING (auth.uid() = user_id);

          CREATE POLICY "Users can update their own profile"
            ON profiles FOR UPDATE
            USING (auth.uid() = user_id)
            WITH CHECK (auth.uid() = user_id);

          CREATE POLICY "Users can insert their own profile"
            ON profiles FOR INSERT
            WITH CHECK (auth.uid() = user_id);
        END;
        $$ LANGUAGE plpgsql;
      `
    });

    // Then call the stored procedure
    await supabase.rpc('create_profiles_table');

    // Wait for changes to propagate
    console.log('Waiting for changes to propagate...');
    await new Promise(resolve => setTimeout(resolve, 5000));

    // Try to create a test profile
    console.log('Creating test profile...');
    const testProfile = {
      id: '00000000-0000-0000-0000-000000000000',
      user_id: '00000000-0000-0000-0000-000000000000',
      name: 'Test User',
      birth_info: {
        date: '1990-01-01',
        time: '12:00',
        latitude: 0,
        longitude: 0,
        city: 'Test City'
      },
      photos: [],
      personality_ratings: {},
      lifestyle_ratings: {},
      values_ratings: {},
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };

    const { error: insertError } = await supabase
      .from('profiles')
      .insert(testProfile);

    if (insertError) {
      console.error('Error inserting test profile:', insertError);
      return;
    }

    // Clean up test profile
    await supabase
      .from('profiles')
      .delete()
      .eq('id', testProfile.id);

    console.log('Table structure verified and updated successfully');
  } catch (error) {
    console.error('Error:', error);
  }
}

verifyTable();
