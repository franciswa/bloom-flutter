import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import { Match, Profile } from '../types/database';
import * as Notifications from 'expo-notifications';
import { enhanceMatchWithCompatibility } from '../utils/matchUtils';
import { useAuth } from './useAuth';
import { useProfile } from './useProfile';
import { ErrorType, handleError, tryCatch } from '../utils/errorHandling';
import { 
  getCachedOrFetch, 
  createMatchesKey, 
  createPaginationResult 
} from '../utils/cacheUtils';

export interface MatchWithProfile extends Match {
  partner_profile: Partial<Profile>;
  compatibility_details?: {
    zodiac_compatibility: number;
    personality_match: number;
    lifestyle_match: number;
    values_match: number;
    overall_compatibility: number;
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
  loadMore: () => Promise<void>;
  hasMore: boolean;
  page: number;
}

export function useMatches(pageSize: number = 10): UseMatchesResult {
  const [matches, setMatches] = useState<MatchWithProfile[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [page, setPage] = useState(1);
  const [totalCount, setTotalCount] = useState(0);
  const { user } = useAuth();
  const { profile } = useProfile();

  // Calculate if there are more matches to load
  const hasMore = matches.length < totalCount;

  // Fetch matches with pagination
  const fetchMatches = useCallback(async (currentPage: number = 1, refresh: boolean = false) => {
    try {
      if (!user) throw new Error('No user found');
      if (!profile) throw new Error('No profile found');

      setLoading(true);

      // Create cache key
      const cacheKey = createMatchesKey(user.id, undefined, currentPage, pageSize);

      // Fetch matches with caching
      const result = await getCachedOrFetch(
        cacheKey,
        async () => {
          // Get total count first
          const { count, error: countError } = await supabase
            .from('matches')
            .select('id', { count: 'exact', head: true })
            .or(`user1_id.eq.${user.id},user2_id.eq.${user.id}`);

          if (countError) throw countError;

          // Calculate pagination
          const from = (currentPage - 1) * pageSize;
          const to = from + pageSize - 1;

          // Fetch paginated matches
          const { data, error: dbError } = await supabase
            .from('matches')
            .select(`
              *,
              partner_profile:profiles!matches_user2_id_fkey(
                id,
                email,
                birth_date,
                birth_time,
                birth_location,
                location,
                personality_ratings,
                lifestyle_ratings,
                values_ratings
              )
            `)
            .or(`user1_id.eq.${user.id},user2_id.eq.${user.id}`)
            .order('created_at', { ascending: false })
            .range(from, to);

          if (dbError) throw dbError;

          // Transform matches to include correct partner profile and calculate compatibility
          const transformedMatches = await Promise.all((data || []).map(async (match) => {
            const isUser1 = match.user1_id === user.id;
            
            // If current user is user1, we already have user2's profile
            if (isUser1) {
              return enhanceMatchWithCompatibility(match as MatchWithProfile, profile);
            }

            // If current user is user2, we need to fetch user1's profile
            const { data: user1Profile } = await supabase
              .from('profiles')
              .select(`
                id,
                email,
                birth_date,
                birth_time,
                birth_location,
                location,
                personality_ratings,
                lifestyle_ratings,
                values_ratings
              `)
              .eq('id', match.user1_id)
              .single();

            const matchWithProfile = {
              ...match,
              partner_profile: user1Profile || {}
            } as MatchWithProfile;

            return enhanceMatchWithCompatibility(matchWithProfile, profile);
          }));

          return createPaginationResult(
            transformedMatches,
            currentPage,
            pageSize,
            count || 0
          );
        },
        { expiryTime: 5 * 60 * 1000 } // 5 minutes cache
      );

      // Update state
      setTotalCount(result.totalCount);
      
      if (refresh) {
        setMatches(result.data);
      } else {
        setMatches(prev => [...prev, ...result.data]);
      }
      
      setError(null);
    } catch (err) {
      const appError = handleError(err, ErrorType.DATABASE);
      setError(appError.message);
      console.error('Error loading matches:', appError);
    } finally {
      setLoading(false);
    }
  }, [user, profile, pageSize]);

  // Load more matches
  const loadMore = useCallback(async () => {
    if (loading || !hasMore) return;
    const nextPage = page + 1;
    await fetchMatches(nextPage, false);
    setPage(nextPage);
  }, [loading, hasMore, page, fetchMatches]);

  // Refresh matches
  const refresh = useCallback(async () => {
    setPage(1);
    await fetchMatches(1, true);
  }, [fetchMatches]);

  // Accept a match
  const acceptMatch = useCallback(async (matchId: string) => {
    return tryCatch(
      async () => {
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

        await refresh();
      },
      ErrorType.DATABASE,
      true,
      'Accept Match Error'
    );
  }, [refresh, matches]);

  // Reject a match
  const rejectMatch = useCallback(async (matchId: string) => {
    return tryCatch(
      async () => {
        const { error: dbError } = await supabase
          .from('matches')
          .update({ status: 'rejected' })
          .eq('id', matchId);

        if (dbError) throw dbError;

        await refresh();
      },
      ErrorType.DATABASE,
      true,
      'Reject Match Error'
    );
  }, [refresh]);

  // Subscribe to match changes and handle notifications
  useEffect(() => {
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
  }, [user, fetchMatches]);

  // Initial fetch when component mounts
  useEffect(() => {
    if (user && profile) {
      fetchMatches(1, true);
    }
  }, [user, profile]);

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
    refresh,
    loadMore,
    hasMore,
    page
  };
}
