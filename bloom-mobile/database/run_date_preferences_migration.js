const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

// Check environment variables
const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY;

console.log('Environment check:');
console.log('SUPABASE_URL:', supabaseUrl ? 'Found' : 'Missing');
console.log('SERVICE_KEY:', supabaseServiceKey ? 'Found' : 'Missing');

if (!supabaseUrl || !supabaseServiceKey) {
  throw new Error('Missing required environment variables');
}

// Create a Supabase client with the service key for admin operations
const adminSupabase = createClient(
  supabaseUrl,
  supabaseServiceKey,
  {
    auth: {
      persistSession: false,
      autoRefreshToken: false
    },
    db: {
      schema: 'public'
    }
  }
);

async function runMigration() {
  try {
    console.log('Running date preferences migration...');
    
    // First try to create the migrations table
    console.log('Creating migrations table...');
    const { error: migrationsError } = await adminSupabase.from('migrations').insert({
      id: '00000000-0000-0000-0000-000000000000',
      name: 'init',
      executed_at: new Date().toISOString()
    });

    // If table doesn't exist, create it
    if (migrationsError && migrationsError.code === '42P01') {
      console.log('Migrations table does not exist, creating...');
      
      // Create migrations table
      const { error: createError } = await adminSupabase
        .from('migrations')
        .upsert({
          id: '00000000-0000-0000-0000-000000000000',
          name: 'init',
          executed_at: new Date().toISOString()
        }, {
          onConflict: 'name'
        });

      if (createError && !createError.message?.includes('already exists')) {
        throw createError;
      }
    }

    // Check if migration was already executed
    const { data: existingMigration } = await adminSupabase
      .from('migrations')
      .select('*')
      .eq('name', '002_create_date_preferences')
      .single();

    if (existingMigration) {
      console.log('Migration already executed, skipping...');
      return;
    }

    // Create the date_preferences table
    console.log('Creating date_preferences table...');
    const { error: tableError } = await adminSupabase
      .from('date_preferences')
      .upsert({
        id: '00000000-0000-0000-0000-000000000000',
        user_id: '00000000-0000-0000-0000-000000000000',
        desired_zodiac: 'test',
        date_type: 'Dinner',
        preferred_date: new Date().toISOString().split('T')[0],
        status: 'pending',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      });

    if (tableError && !tableError.message?.includes('already exists')) {
      throw tableError;
    }

    // Enable RLS
    console.log('Setting up RLS policies...');
    await adminSupabase.rpc('enable_rls', { table_name: 'date_preferences' });

    // Create policies
    await adminSupabase.rpc('create_policy', {
      table_name: 'date_preferences',
      policy_name: 'Users can view their own date preferences',
      operation: 'SELECT',
      using_expression: 'auth.uid() = user_id'
    });

    await adminSupabase.rpc('create_policy', {
      table_name: 'date_preferences',
      policy_name: 'Users can create their own date preferences',
      operation: 'INSERT',
      check_expression: 'auth.uid() = user_id'
    });

    await adminSupabase.rpc('create_policy', {
      table_name: 'date_preferences',
      policy_name: 'Users can update their own date preferences',
      operation: 'UPDATE',
      using_expression: 'auth.uid() = user_id',
      check_expression: 'auth.uid() = user_id'
    });

    await adminSupabase.rpc('create_policy', {
      table_name: 'date_preferences',
      policy_name: 'Users can delete their own date preferences',
      operation: 'DELETE',
      using_expression: 'auth.uid() = user_id'
    });

    // Record migration
    const { error: recordError } = await adminSupabase
      .from('migrations')
      .insert({
        name: '002_create_date_preferences',
        executed_at: new Date().toISOString()
      });

    if (recordError) {
      throw recordError;
    }

    console.log('Migration completed successfully');
  } catch (error) {
    console.error('Migration failed. Details:', error);
    process.exit(1);
  }
}

runMigration();
