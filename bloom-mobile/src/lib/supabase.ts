import 'react-native-url-polyfill/auto';
import { createClient } from '@supabase/supabase-js';
import { Database } from '../types/database';
import secureStorage from '../utils/secureStorage';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

/**
 * Custom storage adapter using our secure storage implementation
 */
const secureStorageAdapter = {
  getItem: (key: string) => {
    return secureStorage.getItem(key);
  },
  setItem: (key: string, value: string) => {
    return secureStorage.setItem(key, value);
  },
  removeItem: (key: string) => {
    return secureStorage.removeItem(key);
  },
};

export const supabase = createClient<Database>(
  supabaseUrl,
  supabaseAnonKey,
  {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: false,
      storage: secureStorageAdapter,
    },
  }
);

// Verify authentication tokens on critical operations
export const verifySuabaseAuth = async () => {
  const { data: { session }} = await supabase.auth.getSession();
  if (!session) {
    throw new Error('Authentication required');
  }
  return session;
};

export const getRealtimeClient = () => supabase.realtime;
