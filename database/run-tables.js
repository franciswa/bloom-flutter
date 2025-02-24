const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const supabase = createClient(
  process.env.EXPO_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

async function createTables() {
  try {
    console.log('Reading SQL file...');
    const sql = fs.readFileSync(path.join(__dirname, 'create-tables.sql'), 'utf8');

    // First create the SQL function
    console.log('Creating SQL function...');
    const functionSql = fs.readFileSync(path.join(__dirname, 'create-function.sql'), 'utf8');
    
    const { error: functionError } = await supabase.rpc('run_sql', {
      sql_query: functionSql
    });

    if (functionError && !functionError.message.includes('already exists')) {
      console.error('Error creating function:', functionError);
      return;
    }

    // Now create the tables
    console.log('Creating tables...');
    const { error: tablesError } = await supabase.rpc('run_sql', {
      sql_query: sql
    });

    if (tablesError) {
      console.error('Error creating tables:', tablesError);
      return;
    }

    console.log('Tables created successfully');
  } catch (error) {
    console.error('Error:', error);
  }
}

createTables();
