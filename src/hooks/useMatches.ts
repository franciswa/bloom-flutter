import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import { Match, Profile } from '../types/database';
import * as Notifications from 'expo-notifications';

export interface MatchWithProfile extends Match {
  partner_profile: Partial<Profile>;
  compatibility_details?: {
    zodiac_compatibility: number;
    personality_match: number;
    lifestyle_match: number;
    values_match: number;
  };
}

export interface UseMatchesResult {
  matches: MatchWithProfile[];
  pendingMatches: MatchWithProfile[];
  activeMatches: MatchWithProfile[];
  loading: boolean;
  error: string | null;
  acceptMatch: (matchId: string) => Promise<void>;
  rejectMatch: (matchId: string) => Promise<void>;
  refresh: () => Promise<void>;
}

export function useMatches(): UseMatchesResult {
  const [matches, setMatches] = useState<MatchWithProfile[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchMatches = useCallback(async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error('No user found');

      const { data, error: dbError } = await supabase
        .from('matches')
        .select(`
          *,
          partner_profile:profiles!matches_user2_id_fkey(
            id,
            email,
            birth_date,
            location_city,
            personality_ratings,
            lifestyle_ratings,
            values_ratings
          )
        `)
        .or(`user1_id.eq.${user.id},user2_id.eq.${user.id}`)
        .order('created_at', { ascending: false });

      if (dbError) throw dbError;

      // Transform matches to include correct partner profile
      const transformedMatches = await Promise.all((data || []).map(async (match) => {
        const isUser1 = match.user1_id === user.id;
        
        // If current user is user1, we already have user2's profile
        if (isUser1) {
          return match as MatchWithProfile;
        }

        // If current user is user2, we need to fetch user1's profile
        const { data: user1Profile } = await supabase
          .from('profiles')
          .select(`
            id,
            email,
            birth_date,
            location_city,
            personality_ratings,
            lifestyle_ratings,
            values_ratings
          `)
          .eq('id', match.user1_id)
          .single();

        return {
          ...match,
          partner_profile: user1Profile || {}
        } as MatchWithProfile;
      }));

      setMatches(transformedMatches);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load matches');
      console.error('Error loading matches:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  const acceptMatch = useCallback(async (matchId: string) => {
    try {
      const match = matches.find(m => m.id === matchId);
      if (!match) throw new Error('Match not found');

      const { error: dbError } = await supabase
        .from('matches')
        .update({ status: 'accepted' })
        .eq('id', matchId);

      if (dbError) throw dbError;

      // Schedule local notification
      await Notifications.scheduleNotificationAsync({
        content: {
          title: 'Match Accepted! 🎉',
          body: `You've accepted a match with ${match.partner_profile.email?.split('@')[0]}. Start chatting now!`,
          data: { matchId, type: 'match_accepted' },
        },
        trigger: null, // Send immediately
      });

      await fetchMatches();
    } catch (err) {
      console.error('Error accepting match:', err);
      throw err;
    }
  }, [fetchMatches, matches]);

  const rejectMatch = useCallback(async (matchId: string) => {
    try {
      const { error: dbError } = await supabase
        .from('matches')
        .update({ status: 'rejected' })
        .eq('id', matchId);

      if (dbError) throw dbError;

      await fetchMatches();
    } catch (err) {
      console.error('Error rejecting match:', err);
      throw err;
    }
  }, [fetchMatches]);

  // Subscribe to match changes and handle notifications
  useEffect(() => {
    const setupSubscription = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      const subscription = supabase
        .channel('matches_changes')
        .on(
          'postgres_changes',
          {
            event: 'INSERT',
            schema: 'public',
            table: 'matches',
            filter: `or(user1_id.eq.${user.id},user2_id.eq.${user.id})`,
          },
          async (payload) => {
            // Show notification for new matches
            const newMatch = payload.new as Match;
            const partnerId = newMatch.user1_id === user.id ? newMatch.user2_id : newMatch.user1_id;
            
            // Fetch partner profile
            const { data: partnerProfile } = await supabase
              .from('profiles')
              .select('email')
              .eq('id', partnerId)
              .single();

            if (partnerProfile) {
              await Notifications.scheduleNotificationAsync({
                content: {
                  title: 'New Match! 💝',
                  body: `You've been matched with ${partnerProfile.email.split('@')[0]}! Check it out!`,
                  data: { matchId: newMatch.id, type: 'new_match' },
                },
                trigger: null,
              });
            }

            await fetchMatches();
          }
        )
        .on(
          'postgres_changes',
          {
            event: 'UPDATE',
            schema: 'public',
            table: 'matches',
            filter: `or(user1_id.eq.${user.id},user2_id.eq.${user.id})`,
          },
          async () => {
            await fetchMatches();
          }
        )
        .subscribe();

      return () => {
        subscription.unsubscribe();
      };
    };

    setupSubscription();
  }, [fetchMatches]);

  // Initial fetch
  useEffect(() => {
    fetchMatches();
  }, [fetchMatches]);

  // Filter matches by status
  const pendingMatches = matches.filter(match => match.status === 'pending');
  const activeMatches = matches.filter(match => match.status === 'accepted');

  return {
    matches,
    pendingMatches,
    activeMatches,
    loading,
    error,
    acceptMatch,
    rejectMatch,
    refresh: fetchMatches,
  };
}
