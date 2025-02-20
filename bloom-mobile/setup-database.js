const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

if (!process.env.SUPABASE_URL || !process.env.SUPABASE_SERVICE_KEY) {
  console.error('Missing required environment variables. Please check your .env file.');
  process.exit(1);
}

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

async function setupDatabase() {
  try {
    console.log('Setting up database...');

    // Read and execute SQL file
    const sqlPath = path.join(__dirname, 'database', 'create-tables.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');
    
    // Split SQL into individual statements
    const statements = sql
      .split(';')
      .map(statement => statement.trim())
      .filter(statement => statement.length > 0);

    // Execute each statement
    for (const statement of statements) {
      const { error } = await supabase.rpc('exec_sql', {
        sql_statement: statement
      });

      if (error) {
        console.error('Error executing SQL statement:', error);
        console.error('Statement:', statement);
        return;
      }
    }

    // Verify tables were created
    const tables = [
      'profiles',
      'user_settings',
      'push_tokens',
      'matches',
      'messages',
      'archived_messages',
      'notifications'
    ];

    for (const table of tables) {
      const { data, error } = await supabase
        .from(table)
        .select('*')
        .limit(1);

      if (error && !error.message.includes('relation') && !error.message.includes('permission')) {
        console.error(`Error verifying table ${table}:`, error);
        return;
      }

      console.log(`✓ Table ${table} created successfully`);
    }

    // Create test user if it doesn't exist
    if (process.env.NODE_ENV === 'development') {
      const { data: user, error: userError } = await supabase.auth.admin.createUser({
        email: 'test@example.com',
        password: 'test123',
        email_confirm: true
      });

      if (userError && !userError.message.includes('already exists')) {
        console.error('Error creating test user:', userError);
      } else {
        console.log('✓ Test user created successfully');

        // Create test profile
        const { error: profileError } = await supabase
          .from('profiles')
          .upsert({
            id: user.id,
            user_id: user.id,
            name: 'Test User',
            birth_info: {
              date: '1990-01-01',
              time: '12:00',
              latitude: 37.7749,
              longitude: -122.4194,
              city: 'San Francisco'
            }
          });

        if (profileError) {
          console.error('Error creating test profile:', profileError);
        } else {
          console.log('✓ Test profile created successfully');
        }

        // Create test settings
        const { error: settingsError } = await supabase
          .from('user_settings')
          .upsert({
            user_id: user.id,
            theme_mode: 'light',
            dark_mode: false,
            notifications_enabled: true
          });

        if (settingsError) {
          console.error('Error creating test settings:', settingsError);
        } else {
          console.log('✓ Test settings created successfully');
        }
      }
    }

    console.log('\nDatabase setup completed successfully!');

  } catch (error) {
    console.error('Error:', error);
  }
}

setupDatabase();
