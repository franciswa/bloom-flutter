import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import { Match, Message, DatePreference } from '../types/database';

export interface MatchDetails extends Match {
  date_preference: DatePreference;
  partner_profile: {
    email: string;
    birth_date: string | null;
    location_city: string | null;
    personality_ratings: any;
    lifestyle_ratings: any;
  };
}

export interface UseMatchResult {
  match: MatchDetails | null;
  messages: Message[];
  loading: boolean;
  error: string | null;
  sendMessage: (content: string) => Promise<void>;
  acceptMatch: () => Promise<void>;
  rejectMatch: () => Promise<void>;
  loadMoreMessages: () => Promise<void>;
}

export function useMatch(matchId: string): UseMatchResult {
  const [match, setMatch] = useState<MatchDetails | null>(null);
  const [messages, setMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [hasMoreMessages, setHasMoreMessages] = useState(true);

  const fetchMatch = useCallback(async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error('No user found');

      const { data, error: dbError } = await supabase
        .from('matches')
        .select(`
          *,
          date_preference:date_preferences(*),
          partner_profile:profiles!matches_user2_id_fkey(
            email,
            birth_date,
            location_city,
            personality_ratings,
            lifestyle_ratings
          )
        `)
        .eq('id', matchId)
        .single();

      if (dbError) throw dbError;

      // If current user is user2, swap the partner profile
      if (data && data.user2_id === user.id) {
        const { data: user1Profile } = await supabase
          .from('profiles')
          .select('email, birth_date, location_city, personality_ratings, lifestyle_ratings')
          .eq('id', data.user1_id)
          .single();

        data.partner_profile = user1Profile;
      }

      setMatch(data);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load match');
      console.error('Error loading match:', err);
    }
  }, [matchId]);

  const fetchMessages = useCallback(async (lastMessageId?: string) => {
    try {
      let query = supabase
        .from('messages')
        .select('*')
        .eq('match_id', matchId)
        .order('created_at', { ascending: false })
        .limit(20);

      if (lastMessageId) {
        query = query.lt('id', lastMessageId);
      }

      const { data, error: dbError } = await query;

      if (dbError) throw dbError;

      if (!lastMessageId) {
        setMessages(data || []);
      } else {
        setMessages(prev => [...prev, ...(data || [])]);
      }

      setHasMoreMessages((data || []).length === 20);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load messages');
      console.error('Error loading messages:', err);
    }
  }, [matchId]);

  const sendMessage = useCallback(async (content: string) => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error('No user found');

      const { data, error: dbError } = await supabase
        .from('messages')
        .insert({
          match_id: matchId,
          sender_id: user.id,
          content
        })
        .select()
        .single();

      if (dbError) throw dbError;

      setMessages(prev => [data, ...prev]);
    } catch (err) {
      console.error('Error sending message:', err);
      throw err;
    }
  }, [matchId]);

  const acceptMatch = useCallback(async () => {
    try {
      const { error: dbError } = await supabase
        .from('matches')
        .update({ status: 'accepted' })
        .eq('id', matchId);

      if (dbError) throw dbError;

      await fetchMatch();
    } catch (err) {
      console.error('Error accepting match:', err);
      throw err;
    }
  }, [matchId, fetchMatch]);

  const rejectMatch = useCallback(async () => {
    try {
      const { error: dbError } = await supabase
        .from('matches')
        .update({ status: 'rejected' })
        .eq('id', matchId);

      if (dbError) throw dbError;

      await fetchMatch();
    } catch (err) {
      console.error('Error rejecting match:', err);
      throw err;
    }
  }, [matchId, fetchMatch]);

  const loadMoreMessages = useCallback(async () => {
    if (!hasMoreMessages || messages.length === 0) return;
    const lastMessage = messages[messages.length - 1];
    await fetchMessages(lastMessage.id);
  }, [messages, hasMoreMessages, fetchMessages]);

  // Subscribe to real-time messages
  useEffect(() => {
    const subscription = supabase
      .channel(`match_${matchId}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'messages',
          filter: `match_id=eq.${matchId}`,
        },
        (payload) => {
          const newMessage = payload.new as Message;
          setMessages(prev => [newMessage, ...prev]);
        }
      )
      .subscribe();

    return () => {
      subscription.unsubscribe();
    };
  }, [matchId]);

  // Subscribe to match status changes
  useEffect(() => {
    const subscription = supabase
      .channel(`match_status_${matchId}`)
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'matches',
          filter: `id=eq.${matchId}`,
        },
        () => {
          fetchMatch();
        }
      )
      .subscribe();

    return () => {
      subscription.unsubscribe();
    };
  }, [matchId, fetchMatch]);

  // Initial data fetch
  useEffect(() => {
    const loadData = async () => {
      setLoading(true);
      try {
        await Promise.all([
          fetchMatch(),
          fetchMessages()
        ]);
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, [fetchMatch, fetchMessages]);

  return {
    match,
    messages,
    loading,
    error,
    sendMessage,
    acceptMatch,
    rejectMatch,
    loadMoreMessages,
  };
}
