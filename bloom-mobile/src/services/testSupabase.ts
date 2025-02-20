import { supabase } from '../lib/supabase';

export async function testSupabaseConnection() {
  try {
    // Test basic connection
    const { data: tableInfo, error: tableError } = await supabase
      .from('messages')
      .select('*')
      .limit(1);

    if (tableError) {
      if (tableError.code === 'PGRST116') {
        return {
          connected: true,
          messagesTableExists: false,
          error: 'Messages table does not exist'
        };
      }
      throw tableError;
    }

    // Test realtime subscription
    const channel = supabase.channel('test')
      .on('presence', { event: 'sync' }, () => {})
      .subscribe();

    await new Promise(resolve => setTimeout(resolve, 1000));
    channel.unsubscribe();

    return {
      connected: true,
      messagesTableExists: true,
      error: null
    };
  } catch (err) {
    return {
      connected: false,
      messagesTableExists: false,
      error: err instanceof Error ? err.message : 'Unknown error'
    };
  }
}
