import { createClient, PostgrestError, RealtimeChannel } from '@supabase/supabase-js';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Database } from '../types/database';
import { AppError, ErrorCodes, withErrorHandling } from '../utils/errorHandling';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

const baseClient = createClient<Database>(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: AsyncStorage,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
  },
});

// Maximum number of retries for failed requests
const MAX_RETRIES = 3;

// Base delay for exponential backoff (in milliseconds)
const BASE_DELAY = 1000;

// Maximum delay between retries (in milliseconds)
const MAX_DELAY = 10000;

const wait = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

class EnhancedSupabaseClient {
  private client = baseClient;

  private calculateDelay(attempt: number): number {
    const delay = Math.min(
      Math.pow(2, attempt) * BASE_DELAY + Math.random() * 1000,
      MAX_DELAY
    );
    return delay;
  }

  private async withRetry<T>(
    operation: () => Promise<T>,
    context: string,
    customRetries?: number
  ): Promise<T> {
    const maxRetries = customRetries ?? MAX_RETRIES;
    let lastError: Error | null = null;

    for (let attempt = 0; attempt < maxRetries; attempt++) {
      try {
        return await operation();
      } catch (error) {
        lastError = error instanceof Error ? error : new Error(String(error));

        // Don't retry if it's an auth error or validation error
        if (
          lastError.message.includes('auth') ||
          lastError.message.includes('validation') ||
          lastError.message.includes('permission') ||
          attempt === maxRetries - 1
        ) {
          throw new AppError(
            lastError.message,
            this.getErrorCode(lastError),
            lastError
          );
        }

        // Wait before retrying
        const delay = this.calculateDelay(attempt);
        await wait(delay);
      }
    }

    throw lastError;
  }

  private getErrorCode(error: Error | PostgrestError): string {
    const message = error.message.toLowerCase();
    if (message.includes('network')) return ErrorCodes.NETWORK;
    if (message.includes('auth')) return ErrorCodes.AUTHENTICATION;
    if (message.includes('permission')) return ErrorCodes.AUTHENTICATION;
    if (message.includes('validation')) return ErrorCodes.VALIDATION;
    if (message.includes('database')) return ErrorCodes.DATABASE;
    return ErrorCodes.UNKNOWN;
  }

  // Wrap Supabase operations with retry logic and error handling
  private async query<T extends any[]>(
    operation: () => Promise<{ data: T | null; error: PostgrestError | null }>,
    context: string
  ): Promise<T> {
    return await this.withRetry(async () => {
      const { data, error } = await operation();
      
      if (error) {
        throw new AppError(
          error.message,
          this.getErrorCode(error),
          error
        );
      }

      if (data === null) {
        throw new AppError(
          'No data returned from query',
          ErrorCodes.DATABASE,
          new Error('Null result')
        );
      }

      return data;
    }, context);
  }

  // Helper methods for common operations
  public async select<TableName extends keyof Database['public']['Tables']>(
    table: TableName,
    query: string,
    context: string
  ): Promise<Database['public']['Tables'][TableName]['Row'][]> {
    return await this.query(
      async () => await this.client.from(table).select(query),
      context
    );
  }

  public async insert<TableName extends keyof Database['public']['Tables']>(
    table: TableName,
    data: Database['public']['Tables'][TableName]['Insert'],
    context: string
  ): Promise<Database['public']['Tables'][TableName]['Row'][]> {
    return await this.query(
      async () => await this.client.from(table).insert(data).select(),
      context
    );
  }

  public async update<TableName extends keyof Database['public']['Tables']>(
    table: TableName,
    query: Partial<Database['public']['Tables'][TableName]['Row']>,
    data: Database['public']['Tables'][TableName]['Update'],
    context: string
  ): Promise<Database['public']['Tables'][TableName]['Row'][]> {
    return await this.query(
      async () => await this.client.from(table).update(data).match(query).select(),
      context
    );
  }

  public async delete<TableName extends keyof Database['public']['Tables']>(
    table: TableName,
    query: Partial<Database['public']['Tables'][TableName]['Row']>,
    context: string
  ): Promise<Database['public']['Tables'][TableName]['Row'][]> {
    return await this.query(
      async () => await this.client.from(table).delete().match(query).select(),
      context
    );
  }

  // Realtime subscription support
  public channel(name: string): RealtimeChannel {
    return this.client.channel(name);
  }

  // Auth methods with retry and error handling
  public auth = {
    getUser: withErrorHandling(
      async () => {
        const { data, error } = await this.client.auth.getUser();
        if (error) throw error;
        return data;
      },
      'Auth.GetUser'
    ),

    signUp: withErrorHandling(
      async (credentials: { email: string; password: string }) =>
        await this.withRetry(
          async () => {
            const { data, error } = await this.client.auth.signUp(credentials);
            if (error) throw error;
            return data;
          },
          'Auth.SignUp'
        ),
      'Auth.SignUp'
    ),

    signIn: withErrorHandling(
      async (credentials: { email: string; password: string }) =>
        await this.withRetry(
          async () => {
            const { data, error } = await this.client.auth.signInWithPassword(credentials);
            if (error) throw error;
            return data;
          },
          'Auth.SignIn'
        ),
      'Auth.SignIn'
    ),

    signOut: withErrorHandling(
      async () =>
        await this.withRetry(
          async () => {
            const { error } = await this.client.auth.signOut();
            if (error) throw error;
          },
          'Auth.SignOut'
        ),
      'Auth.SignOut'
    ),

    getSession: withErrorHandling(
      async () =>
        await this.withRetry(
          async () => {
            const { data, error } = await this.client.auth.getSession();
            if (error) throw error;
            return data.session;
          },
          'Auth.GetSession'
        ),
      'Auth.GetSession'
    ),
  };
}

export const supabase = new EnhancedSupabaseClient();
