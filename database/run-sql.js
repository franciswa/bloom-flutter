const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const supabase = createClient(
  process.env.EXPO_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

async function runSQL() {
  try {
    console.log('Reading SQL file...');
    const sql = fs.readFileSync(path.join(__dirname, 'create-tables.sql'), 'utf8');

    console.log('Executing SQL...');
    const { error } = await supabase.rpc('exec_sql', { sql_query: sql });
    
    if (error) {
      console.error('Error executing SQL:', error);
      return;
    }

    console.log('SQL executed successfully');
  } catch (error) {
    console.error('Error:', error);
  }
}

runSQL();
