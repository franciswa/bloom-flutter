import { createClient } from '@supabase/supabase-js';
import { readFileSync } from 'fs';
import { join } from 'path';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('Missing required environment variables');
  process.exit(1);
}

// Create Supabase client with service key for admin access
const supabase = createClient(supabaseUrl, supabaseServiceKey);

// List migrations in order
const migrations = [
  'setup.sql',
  '002_add_notifications.sql',
  '003_add_archived_messages.sql',
];

async function runMigrations() {
  try {
    // Check if migrations table exists
    const { data: migrationTableExists } = await supabase
      .from('pg_tables')
      .select('tablename')
      .eq('tablename', 'migrations')
      .single();

    // Create migrations table if it doesn't exist
    if (!migrationTableExists) {
      await supabase.rpc('exec', {
        query: `
          CREATE TABLE migrations (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            executed_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
          );
        `
      });
    }

    // Get executed migrations
    const { data: executedMigrations } = await supabase
      .from('migrations')
      .select('name');

    const executedMigrationNames = new Set(
      executedMigrations?.map(m => m.name) || []
    );

    // Run each migration that hasn't been executed
    for (const migrationFile of migrations) {
      if (!executedMigrationNames.has(migrationFile)) {
        console.log(`Running migration: ${migrationFile}`);

        // Read migration file
        const migrationPath = join(__dirname, migrationFile);
        const migrationSql = readFileSync(migrationPath, 'utf8');

        // Execute migration
        await supabase.rpc('exec', { query: migrationSql });

        // Record migration
        await supabase
          .from('migrations')
          .insert({ name: migrationFile });

        console.log(`Completed migration: ${migrationFile}`);
      } else {
        console.log(`Skipping already executed migration: ${migrationFile}`);
      }
    }

    console.log('All migrations completed successfully');
  } catch (error) {
    console.error('Error running migrations:', error);
    process.exit(1);
  }
}

// Run migrations
runMigrations();
