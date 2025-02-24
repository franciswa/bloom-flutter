import { Message } from '../types/database';
import { supabase } from '../lib/supabase';

export async function sendMessage(matchId: string, senderId: string, content: string): Promise<Message> {
  try {
    const { data, error } = await supabase
      .from('messages')
      .insert({
        match_id: matchId,
        sender_id: senderId,
        content,
        is_system_message: false
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to send message');
  }
}

export async function getMessages(matchId: string, limit = 20, offset = 0): Promise<Message[]> {
  try {
    const { data, error } = await supabase
      .from('messages')
      .select('*')
      .eq('match_id', matchId)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) throw error;
    return data || [];
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to fetch messages');
  }
}

export async function archiveMessage(messageId: string): Promise<void> {
  try {
    const { error: selectError, data: message } = await supabase
      .from('messages')
      .select('*')
      .eq('id', messageId)
      .single();
    
    if (selectError) throw selectError;
    if (!message) throw new Error('Message not found');

    const { error: insertError } = await supabase
      .from('archived_messages')
      .insert({
        ...message,
        archived_at: new Date().toISOString()
      });
    
    if (insertError) throw insertError;

    const { error: deleteError } = await supabase
      .from('messages')
      .delete()
      .eq('id', messageId);
    
    if (deleteError) throw deleteError;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to archive message');
  }
}

export function subscribeToMessages(matchId: string, onMessage: (message: Message) => void): () => void {
  const channel = supabase
    .channel(`messages:${matchId}`)
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'messages',
        filter: `match_id=eq.${matchId}`
      },
      (payload) => {
        const newMessage = payload.new as Message;
        onMessage(newMessage);
      }
    )
    .subscribe();

  return () => {
    channel.unsubscribe();
  };
}

// New function to mark messages as read
export async function markMessagesAsRead(matchId: string, userId: string): Promise<void> {
  try {
    const { error } = await supabase
      .from('messages')
      .update({ read: true })
      .eq('match_id', matchId)
      .eq('sender_id', userId)
      .is('read', false);

    if (error) throw error;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to mark messages as read');
  }
}

// New function to get unread message count
export async function getUnreadMessageCount(userId: string): Promise<number> {
  try {
    const { data, error, count } = await supabase
      .from('messages')
      .select('*', { count: 'exact', head: true })
      .eq('sender_id', userId)
      .is('read', false);

    if (error) throw error;
    return count || 0;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to get unread message count');
  }
}

// Typing indicator functions
export async function setTypingStatus(matchId: string, userId: string, isTyping: boolean): Promise<void> {
  try {
    const channel = supabase.channel(`typing:${matchId}`);
    await channel.subscribe();
    
    await channel.send({
      type: 'broadcast',
      event: 'typing',
      payload: { userId, isTyping }
    });
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to update typing status');
  }
}

export function subscribeToTypingStatus(
  matchId: string, 
  onTypingChange: (userId: string, isTyping: boolean) => void
): () => void {
  const channel = supabase
    .channel(`typing:${matchId}`)
    .on('broadcast', { event: 'typing' }, (payload) => {
      const { userId, isTyping } = payload.payload;
      onTypingChange(userId, isTyping);
    })
    .subscribe();

  return () => {
    channel.unsubscribe();
  };
}

// Message editing functions
export async function editMessage(messageId: string, newContent: string): Promise<Message> {
  try {
    const { data, error } = await supabase
      .from('messages')
      .update({ 
        content: newContent,
        edited_at: new Date().toISOString()
      })
      .eq('id', messageId)
      .select()
      .single();

    if (error) throw error;
    if (!data) throw new Error('Failed to edit message');

    return data;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to edit message');
  }
}

export async function deleteMessage(messageId: string): Promise<void> {
  try {
    const { error } = await supabase
      .from('messages')
      .delete()
      .eq('id', messageId);

    if (error) throw error;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to delete message');
  }
}
