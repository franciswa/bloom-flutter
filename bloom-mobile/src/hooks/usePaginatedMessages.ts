import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';

interface Message {
  id: string;
  match_id: string;
  sender_id: string;
  receiver_id: string;
  content: string;
  read: boolean;
  created_at: string;
}

interface UsePaginatedMessagesParams {
  matchId: string;
  pageSize?: number;
  initialLoad?: boolean;
}

interface UsePaginatedMessagesResult {
  messages: Message[];
  loading: boolean;
  error: string | null;
  loadMore: () => Promise<void>;
  hasMore: boolean;
  refresh: () => Promise<void>;
}

/**
 * Custom hook for paginated message loading with realtime updates
 */
export function usePaginatedMessages({
  matchId,
  pageSize = 20,
  initialLoad = true,
}: UsePaginatedMessagesParams): UsePaginatedMessagesResult {
  const [messages, setMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [hasMore, setHasMore] = useState(true);
  const [page, setPage] = useState(0);
  const [subscription, setSubscription] = useState<any>(null);

  // Function to load messages for a specific page
  const loadMessages = useCallback(async (pageNumber: number, reset: boolean = false) => {
    if (!matchId) return;
    
    try {
      setLoading(true);
      setError(null);
      
      const from = pageNumber * pageSize;
      const to = from + pageSize - 1;
      
      const { data, error: fetchError, count } = await supabase
        .from('messages')
        .select('*', { count: 'exact' })
        .eq('match_id', matchId)
        .order('created_at', { ascending: false })
        .range(from, to);
      
      if (fetchError) throw fetchError;
      
      const newMessages = data as Message[];
      
      // Update state
      setMessages(prevMessages => 
        reset ? newMessages : [...prevMessages, ...newMessages]
      );
      
      // Check if there are more messages to load
      setHasMore(count !== null ? from + newMessages.length < count : false);
      
      // Update page counter
      setPage(pageNumber);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load messages');
      console.error('Error loading messages:', err);
    } finally {
      setLoading(false);
    }
  }, [matchId, pageSize]);

  // Function to load more messages
  const loadMore = useCallback(async () => {
    if (!loading && hasMore) {
      await loadMessages(page + 1);
    }
  }, [loading, hasMore, loadMessages, page]);

  // Function to refresh messages
  const refresh = useCallback(async () => {
    await loadMessages(0, true);
  }, [loadMessages]);

  // Initial load
  useEffect(() => {
    if (initialLoad && matchId) {
      loadMessages(0, true);
    }
  }, [initialLoad, matchId, loadMessages]);

  // Set up realtime subscription
  useEffect(() => {
    if (!matchId) return;

    // Clean up previous subscription if exists
    if (subscription) {
      subscription.unsubscribe();
    }

    // Subscribe to new messages
    const newSubscription = supabase
      .channel(`messages:match_id=eq.${matchId}`)
      .on('postgres_changes', 
        { 
          event: 'INSERT', 
          schema: 'public', 
          table: 'messages',
          filter: `match_id=eq.${matchId}`
        }, 
        (payload) => {
          const newMessage = payload.new as Message;
          
          // Add to messages array (at the beginning since we sort by created_at desc)
          setMessages(prev => [newMessage, ...prev]);
        }
      )
      .subscribe();

    setSubscription(newSubscription);

    // Cleanup subscription
    return () => {
      if (newSubscription) {
        newSubscription.unsubscribe();
      }
    };
  }, [matchId]);

  return {
    messages,
    loading,
    error,
    loadMore,
    hasMore,
    refresh,
  };
}