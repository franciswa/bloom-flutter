import { useState, useCallback, useEffect } from 'react';
import { signUp, signIn, signOut, getAuthState } from '../services/auth';
import type { Profile } from '../types/database';

interface UseAuthResult {
  user: { id: string; email: string } | null;
  profile: Profile | null;
  loading: boolean;
  error: string | null;
  signUp: (data: {
    email: string;
    password: string;
    birthDate: string;
    birthTime: string;
    birthLocation: {
      city: string;
      latitude: number;
      longitude: number;
    };
  }) => Promise<void>;
  signIn: (data: {
    email: string;
    password: string;
  }) => Promise<void>;
  signOut: () => Promise<void>;
}

export function useAuth(): UseAuthResult {
  const [state, setState] = useState(getAuthState());

  // Update local state when auth state changes
  useEffect(() => {
    const interval = setInterval(() => {
      const newState = getAuthState();
      if (JSON.stringify(newState) !== JSON.stringify(state)) {
        setState(newState);
      }
    }, 1000);

    return () => clearInterval(interval);
  }, [state]);

  const handleSignUp = useCallback(async (data: {
    email: string;
    password: string;
    birthDate: string;
    birthTime: string;
    birthLocation: {
      city: string;
      latitude: number;
      longitude: number;
    };
  }) => {
    try {
      await signUp(data);
      setState(getAuthState());
    } catch (err) {
      // Error is already handled in auth service
      throw err;
    }
  }, []);

  const handleSignIn = useCallback(async (data: {
    email: string;
    password: string;
  }) => {
    try {
      await signIn(data);
      setState(getAuthState());
    } catch (err) {
      // Error is already handled in auth service
      throw err;
    }
  }, []);

  const handleSignOut = useCallback(async () => {
    try {
      await signOut();
      setState(getAuthState());
    } catch (err) {
      // Error is already handled in auth service
      throw err;
    }
  }, []);

  return {
    user: state.user,
    profile: state.profile,
    loading: state.loading,
    error: state.error,
    signUp: handleSignUp,
    signIn: handleSignIn,
    signOut: handleSignOut,
  };
}
