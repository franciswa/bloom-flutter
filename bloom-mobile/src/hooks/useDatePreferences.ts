import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import { DatePreference, Match } from '../types/database';

export interface ActiveDate extends DatePreference {
  match?: Match;
}

export interface UseDatePreferencesResult {
  activeDates: ActiveDate[];
  loading: boolean;
  error: string | null;
  canCreateNewDate: boolean;
  createDatePreference: (preference: Omit<DatePreference, 'id' | 'user_id' | 'status' | 'created_at' | 'updated_at'>) => Promise<void>;
  cancelDatePreference: (preferenceId: string) => Promise<void>;
  refresh: () => Promise<void>;
}

export function useDatePreferences(): UseDatePreferencesResult {
  const [activeDates, setActiveDates] = useState<ActiveDate[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchActiveDates = useCallback(async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error('No user found');

      // Fetch date preferences with their matches
      const { data, error: dbError } = await supabase
        .from('date_preferences')
        .select(`
          *,
          matches!date_preferences_id_fkey(*)
        `)
        .eq('user_id', user.id)
        .in('status', ['pending', 'matching', 'matched'])
        .order('created_at', { ascending: false });

      if (dbError) throw dbError;

      // Transform the data to include match information
      const activeDatesWithMatches = (data || []).map(date => ({
        ...date,
        match: date.matches?.[0] || undefined
      }));

      setActiveDates(activeDatesWithMatches);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load date preferences');
      console.error('Error loading date preferences:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  const createDatePreference = useCallback(async (
    preference: Omit<DatePreference, 'id' | 'user_id' | 'status' | 'created_at' | 'updated_at'>
  ) => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error('No user found');

      const { error: dbError } = await supabase
        .from('date_preferences')
        .insert({
          ...preference,
          user_id: user.id,
          status: 'pending'
        });

      if (dbError) throw dbError;

      await fetchActiveDates();
    } catch (err) {
      console.error('Error creating date preference:', err);
      throw err;
    }
  }, [fetchActiveDates]);

  const cancelDatePreference = useCallback(async (preferenceId: string) => {
    try {
      const { error: dbError } = await supabase
        .from('date_preferences')
        .update({ status: 'cancelled' })
        .eq('id', preferenceId);

      if (dbError) throw dbError;

      await fetchActiveDates();
    } catch (err) {
      console.error('Error cancelling date preference:', err);
      throw err;
    }
  }, [fetchActiveDates]);

  // Subscribe to date preference changes
  useEffect(() => {
    const setupSubscription = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      const subscription = supabase
        .channel('date_preferences_changes')
        .on(
          'postgres_changes',
          {
            event: '*',
            schema: 'public',
            table: 'date_preferences',
            filter: `user_id=eq.${user.id}`,
          },
          async () => {
            await fetchActiveDates();
          }
        )
        .subscribe();

      return () => {
        subscription.unsubscribe();
      };
    };

    setupSubscription();
  }, [fetchActiveDates]);

  // Subscribe to match changes
  useEffect(() => {
    const setupSubscription = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      const subscription = supabase
        .channel('matches_changes')
        .on(
          'postgres_changes',
          {
            event: '*',
            schema: 'public',
            table: 'matches',
            filter: `or(user1_id.eq.${user.id},user2_id.eq.${user.id})`,
          },
          async () => {
            await fetchActiveDates();
          }
        )
        .subscribe();

      return () => {
        subscription.unsubscribe();
      };
    };

    setupSubscription();
  }, [fetchActiveDates]);

  // Initial fetch
  useEffect(() => {
    fetchActiveDates();
  }, [fetchActiveDates]);

  // Calculate if user can create new dates
  const canCreateNewDate = activeDates.length < 3;

  return {
    activeDates,
    loading,
    error,
    canCreateNewDate,
    createDatePreference,
    cancelDatePreference,
    refresh: fetchActiveDates,
  };
}
