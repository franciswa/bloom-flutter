import { useState, useEffect, useCallback } from 'react';
import { Message } from '../types/database';
import { 
  sendMessage, 
  getMessages, 
  subscribeToMessages, 
  markMessagesAsRead 
} from '../services/messages';

interface UseChatResult {
  messages: Message[];
  loading: boolean;
  error: string | null;
  sendMessage: (content: string) => Promise<void>;
  loadMoreMessages: () => Promise<void>;
  hasMoreMessages: boolean;
}

export function useChat(matchId: string, userId: string): UseChatResult {
  const [messages, setMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [offset, setOffset] = useState(0);
  const [hasMore, setHasMore] = useState(true);
  const limit = 20;

  const loadMessages = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      const fetchedMessages = await getMessages(matchId, limit, offset);
      setMessages(prev => {
        const combined = [...prev, ...fetchedMessages];
        // Remove duplicates and sort by date
        return Array.from(new Map(combined.map(msg => [msg.id, msg])).values())
          .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
      });
      setHasMore(fetchedMessages.length === limit);

      // Mark messages as read
      const unreadMessages = fetchedMessages.filter(
        msg => msg.sender_id !== userId && !msg.read
      );
      if (unreadMessages.length > 0) {
        await markMessagesAsRead(matchId, userId);
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load messages');
    } finally {
      setLoading(false);
    }
  }, [matchId, userId, offset, limit]);

  // Load initial messages
  useEffect(() => {
    loadMessages();
  }, [matchId, loadMessages]);

  // Subscribe to new messages
  useEffect(() => {
    const unsubscribe = subscribeToMessages(matchId, async (newMessage) => {
      setMessages(prev => {
        // Check if message already exists
        if (prev.some(msg => msg.id === newMessage.id)) {
          return prev;
        }
        return [newMessage, ...prev];
      });

      // Mark new messages as read if they're from the other user
      if (newMessage.sender_id !== userId) {
        try {
          await markMessagesAsRead(matchId, userId);
        } catch (err) {
          console.error('Failed to mark message as read:', err);
        }
      }
    });

    return () => {
      unsubscribe();
    };
  }, [matchId, userId]);

  const loadMoreMessages = async () => {
    if (!hasMore || loading) return;
    setOffset(prev => prev + limit);
    await loadMessages();
  };

  const handleSendMessage = async (content: string) => {
    try {
      setError(null);
      await sendMessage(matchId, userId, content);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to send message');
      throw err;
    }
  };

  return {
    messages,
    loading,
    error,
    sendMessage: handleSendMessage,
    loadMoreMessages,
    hasMoreMessages: hasMore,
  };
}
