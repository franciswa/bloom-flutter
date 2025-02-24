import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { supabase } from '../lib/supabase';
import { User } from '@supabase/supabase-js';
import { authRateLimiter, passwordResetRateLimiter } from '../utils/rateLimiter';

interface AuthContextType {
  user: User | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  resetPassword: (email: string) => Promise<void>;
}

interface AuthProviderProps {
  children: ReactNode;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check active sessions and sets the user
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      setLoading(false);
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
    });

    return () => subscription.unsubscribe();
  }, []);

  const signIn = async (email: string, password: string) => {
    // Check rate limiter
    const { limited, remainingAttempts, resetTime } = await authRateLimiter.check();
    if (limited) {
      const resetDate = new Date(resetTime);
      const minutes = Math.ceil((resetTime - Date.now()) / 60000);
      throw new Error(`Too many login attempts. Please try again in ${minutes} minutes (${resetDate.toLocaleTimeString()}).`);
    }

    try {
      const { error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) throw error;
      
      // Successful login, reset rate limiter
      await authRateLimiter.reset();
    } catch (error) {
      // Don't reset on error - this counts toward rate limit
      throw error;
    }
  };

  const signUp = async (email: string, password: string) => {
    // Check rate limiter
    const { limited, remainingAttempts, resetTime } = await authRateLimiter.check();
    if (limited) {
      const resetDate = new Date(resetTime);
      const minutes = Math.ceil((resetTime - Date.now()) / 60000);
      throw new Error(`Too many signup attempts. Please try again in ${minutes} minutes (${resetDate.toLocaleTimeString()}).`);
    }

    try {
      const { error } = await supabase.auth.signUp({ email, password });
      if (error) throw error;

      // Successful signup, reset rate limiter
      await authRateLimiter.reset();
    } catch (error) {
      // Don't reset on error - this counts toward rate limit
      throw error;
    }
  };

  const signOut = async () => {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
  };

  const resetPassword = async (email: string) => {
    // Check rate limiter for password resets
    const { limited, remainingAttempts, resetTime } = await passwordResetRateLimiter.check();
    if (limited) {
      const resetDate = new Date(resetTime);
      const minutes = Math.ceil((resetTime - Date.now()) / 60000);
      throw new Error(`Too many password reset attempts. Please try again in ${minutes} minutes (${resetDate.toLocaleTimeString()}).`);
    }

    try {
      const { error } = await supabase.auth.resetPasswordForEmail(email);
      if (error) throw error;
    } catch (error) {
      // Don't reset on error - this counts toward rate limit
      throw error;
    }
  };

  const value: AuthContextType = {
    user,
    loading,
    signIn,
    signUp,
    signOut,
    resetPassword,
  };

  return (
    <AuthContext.Provider value={value}>
      {!loading && children}
    </AuthContext.Provider>
  );
};

export function useAuth(): AuthContextType {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
