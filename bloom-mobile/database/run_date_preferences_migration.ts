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

// Test connection
async function testConnection() {
  try {
    const { error } = await adminSupabase.from('_test').select('*').limit(1);
    if (error) {
      console.error('Connection test failed:', error);
    } else {
      console.log('Connection test successful');
    }
  } catch (err) {
    console.error('Connection test error:', err);
  }
}

testConnection();

async function setupDatabase() {
  try {
    console.log('Creating migrations table...');
    // Create migrations table
    console.log('Creating migrations table...');
    // First create the exec_sql function
    const { data: functionData, error: functionError } = await adminSupabase.rpc('exec_sql', {
      sql_text: `
        CREATE OR REPLACE FUNCTION exec_sql(sql_text text)
        RETURNS void AS $$
        BEGIN
          EXECUTE sql_text;
        END;
        $$ LANGUAGE plpgsql SECURITY DEFINER;
    `);

    if (functionError) {
      console.error('Failed to create exec_sql function:', functionError);
      throw functionError;
    }
    console.log('exec_sql function created successfully');

    // Now create the migrations table
    const { data: createData, error: createError } = await adminSupabase.rpc('exec_sql', {
      sql_text: `
        CREATE TABLE IF NOT EXISTS migrations (
          id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
          name TEXT UNIQUE NOT NULL,
          executed_at TIMESTAMP WITH TIME ZONE NOT NULL
        );
      `
    });

    if (createError) {
      console.error('Failed to create migrations table:', createError);
      throw createError;
    }

    // Read and execute migration SQL
    console.log('Creating date preferences table...');
    const migrationSql = fs.readFileSync(path.join(__dirname, 'migrations', '002_create_date_preferences.sql'), 'utf8');
    
    // Split SQL into individual statements
    const statements = migrationSql
      .split(';')
      .map((statement: string) => statement.trim())
      .filter((statement: string) => statement.length > 0);

    // Execute each statement
    for (const statement of statements) {
      const { data: stmtData, error: stmtError } = await adminSupabase.rpc('exec_sql', {
        sql_text: statement
      });

      if (stmtError) {
        console.error('Failed to execute statement:', statement);
        console.error('Error:', stmtError);
        throw stmtError;
      }
    }
    console.log('Date preferences table created/verified');
  } catch (error) {
    console.error('Failed to setup database:', error);
    throw error;
  }
}

async function runMigration() {
  try {
    console.log('Running date preferences migration...');
    
    // Setup database with required function and table
    await setupDatabase();
    
    const migrationPath = path.join(__dirname, 'migrations', '002_create_date_preferences.sql');
    console.log('Reading migration file from:', migrationPath);
    const migrationSql = fs.readFileSync(migrationPath, 'utf8');
    console.log('Migration SQL loaded successfully');

    // Record migration in migrations table
    const { error: recordError } = await adminSupabase.from('migrations').insert({
      name: '002_create_date_preferences',
      executed_at: new Date().toISOString(),
    });

    if (recordError) {
      if (recordError.code === '23505') { // Unique violation
        console.log('Migration already executed, skipping...');
        return;
      }
      console.error('Failed to record migration:', recordError);
      throw recordError;
    }

    console.log('Migration completed successfully');
  } catch (error) {
    console.error('Migration failed. Details:', JSON.stringify(error, null, 2));
    process.exit(1);
  }
}

runMigration();
