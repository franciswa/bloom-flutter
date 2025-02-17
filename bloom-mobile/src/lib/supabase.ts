import 'react-native-url-polyfill/auto';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { createClient } from '@supabase/supabase-js';
import { Database } from '../types/database';
import { SUPABASE_URL, SUPABASE_ANON_KEY } from '@env';

// Validate environment variables
if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
  throw new Error('Missing Supabase configuration. Please check your environment variables.');
}

// Validate URL format
try {
  new URL(SUPABASE_URL);
} catch (error) {
  throw new Error('Invalid Supabase URL format');
}

// Initialize Supabase client with error handling
let supabaseInstance: ReturnType<typeof createClient<Database>>;

try {
  supabaseInstance = createClient<Database>(SUPABASE_URL, SUPABASE_ANON_KEY, {
    auth: {
      storage: AsyncStorage,
      autoRefreshToken: true,
      persistSession: true,
      detectSessionInUrl: false,
    },
    // Add global error handler
    global: {
      fetch: async (url, options) => {
        try {
          const response = await fetch(url, options);
          if (!response.ok) {
            console.error(`Supabase request failed: ${response.status} ${response.statusText}`);
          }
          return response;
        } catch (error) {
          console.error('Supabase request error:', error);
          throw error;
        }
      },
    },
  });
} catch (error) {
  console.error('Failed to initialize Supabase client:', error);
  throw new Error('Failed to initialize Supabase client. Please check your configuration.');
}

export const supabase = supabaseInstance;

// Re-export types from database.ts for convenience
export type { Profile, Match, Message } from '../types/database';
