const { createClient } = require('@supabase/supabase-js');
const { readFileSync } = require('fs');
const { join } = require('path');
require('dotenv').config();

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('Missing required environment variables');
  process.exit(1);
}

// Create Supabase client with anon key
const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function clearDatabase() {
  try {
    console.log('Starting database cleanup...');

    // Read clear tables SQL file
    const clearTablesPath = join(__dirname, 'clear_tables.sql');
    const clearTablesSql = readFileSync(clearTablesPath, 'utf8');

    // Execute clear tables SQL
    await supabase.rpc('exec', { query: clearTablesSql });

    console.log('Database cleanup completed successfully');
  } catch (error) {
    console.error('Error clearing database:', error);
    process.exit(1);
  }
}

// Run database cleanup
clearDatabase();
