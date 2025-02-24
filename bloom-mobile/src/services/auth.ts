import { supabase } from '../lib/supabase';
import { Profile } from '../types/database';

interface SignUpData {
  email: string;
  password: string;
  birthDate: string;
  birthTime: string;
  birthLocation: {
    city: string;
    latitude: number;
    longitude: number;
  };
}

interface SignInData {
  email: string;
  password: string;
}

interface AuthState {
  user: {
    id: string;
    email: string;
  } | null;
  profile: Profile | null;
  loading: boolean;
  error: string | null;
}

let authState: AuthState = {
  user: null,
  profile: null,
  loading: false,
  error: null,
};

export async function signUp(data: SignUpData): Promise<void> {
  try {
    authState.loading = true;
    authState.error = null;

    const { data: authData, error } = await supabase.auth.signUp({
      email: data.email,
      password: data.password
    });
    if (error) throw error;
    if (!authData.user) throw new Error('No user data returned');

    // Create profile
    const { error: profileError } = await supabase
      .from('profiles')
      .insert({
        id: authData.user.id,
        user_id: authData.user.id,
        name: data.email.split('@')[0], // Temporary name from email
        birth_info: {
          date: data.birthDate,
          time: data.birthTime,
          latitude: data.birthLocation.latitude,
          longitude: data.birthLocation.longitude,
          city: data.birthLocation.city
        },
        photos: [],
        personality_ratings: {},
        lifestyle_ratings: {},
        values_ratings: {},
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })
      .single();
    
    if (profileError) throw profileError;

    authState.user = {
      id: authData.user.id,
      email: authData.user.email || ''
    };

    // Fetch the created profile
    const { data: profile, error: fetchError } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', authData.user.id)
      .single();
    
    if (fetchError) throw fetchError;
    authState.profile = profile;

  } catch (err) {
    authState.error = err instanceof Error ? err.message : 'Failed to sign up';
    throw new Error(authState.error);
  } finally {
    authState.loading = false;
  }
}

export async function signIn(data: SignInData): Promise<void> {
  try {
    authState.loading = true;
    authState.error = null;

    const { data: authData, error } = await supabase.auth.signInWithPassword({
      email: data.email,
      password: data.password
    });
    if (error) throw error;
    if (!authData.user) throw new Error('No user data returned');

    // Get profile
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', authData.user.id)
      .single();
    
    if (profileError) throw profileError;

    authState.user = {
      id: authData.user.id,
      email: authData.user.email || ''
    };
    authState.profile = profile;

  } catch (err) {
    authState.error = err instanceof Error ? err.message : 'Failed to sign in';
    throw new Error(authState.error);
  } finally {
    authState.loading = false;
  }
}

export async function signOut(): Promise<void> {
  try {
    authState.loading = true;
    authState.error = null;

    const { error } = await supabase.auth.signOut();
    if (error) throw error;

    authState.user = null;
    authState.profile = null;
  } catch (err) {
    authState.error = err instanceof Error ? err.message : 'Failed to sign out';
    throw new Error(authState.error);
  } finally {
    authState.loading = false;
  }
}

export function getAuthState(): AuthState {
  return { ...authState };
}

// Initialize auth state from session
supabase.auth.getSession().then(async ({ data: { session }, error }) => {
  if (error) {
    console.error('Error fetching session:', error.message);
    return;
  }

  if (session?.user) {
    try {
      const { data: profile, error: profileError } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', session.user.id)
        .single();
      
      if (profileError) throw profileError;

      authState.user = {
        id: session.user.id,
        email: session.user.email || ''
      };
      authState.profile = profile;
    } catch (err) {
      console.error('Error fetching profile:', err);
    }
  }
});
