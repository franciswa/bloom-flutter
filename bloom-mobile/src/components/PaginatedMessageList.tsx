import React, { useEffect, useRef } from 'react';
import {
  View,
  Text,
  FlatList,
  ActivityIndicator,
  StyleSheet,
  RefreshControl,
  TouchableOpacity,
} from 'react-native';
import { usePaginatedMessages } from '../hooks/usePaginatedMessages';
import { useAuth } from '../hooks/useAuth';
import { format } from 'date-fns';

interface Message {
  id: string;
  match_id: string;
  sender_id: string;
  receiver_id: string;
  content: string;
  read: boolean;
  created_at: string;
}

interface MessageItemProps {
  message: Message;
  isOwnMessage: boolean;
}

const MessageItem = ({ message, isOwnMessage }: MessageItemProps) => {
  const messageTime = format(new Date(message.created_at), 'h:mm a');
  
  return (
    <View style={[
      styles.messageContainer,
      isOwnMessage ? styles.ownMessage : styles.otherMessage
    ]}>
      <Text style={[
        styles.messageText,
        isOwnMessage ? styles.ownMessageText : styles.otherMessageText
      ]}>
        {message.content}
      </Text>
      <Text style={styles.messageTime}>
        {messageTime}
      </Text>
    </View>
  );
};

interface PaginatedMessageListProps {
  matchId: string;
  pageSize?: number;
}

export default function PaginatedMessageList({
  matchId,
  pageSize = 20,
}: PaginatedMessageListProps) {
  const { user } = useAuth();
  const {
    messages,
    loading,
    error,
    loadMore,
    hasMore,
    refresh,
  } = usePaginatedMessages({
    matchId,
    pageSize,
    initialLoad: true,
  });
  
  const flatListRef = useRef<FlatList>(null);
  
  // Handle initial load - scroll to bottom
  useEffect(() => {
    if (messages.length > 0 && !loading) {
      // We delay scrolling to ensure the FlatList has rendered
      setTimeout(() => {
        flatListRef.current?.scrollToOffset({ offset: 0, animated: false });
      }, 100);
    }
  }, []);
  
  const renderItem = ({ item }: { item: Message }) => {
    const isOwnMessage = item.sender_id === user?.id;
    return <MessageItem message={item} isOwnMessage={isOwnMessage} />;
  };
  
  const renderFooter = () => {
    if (!hasMore) return null;
    
    return (
      <TouchableOpacity 
        style={styles.loadMoreButton}
        onPress={loadMore}
        disabled={loading}
      >
        {loading ? (
          <ActivityIndicator size="small" color="#0000ff" />
        ) : (
          <Text style={styles.loadMoreText}>Load Earlier Messages</Text>
        )}
      </TouchableOpacity>
    );
  };
  
  if (error) {
    return (
      <View style={styles.centerContainer}>
        <Text style={styles.errorText}>Error: {error}</Text>
        <TouchableOpacity style={styles.retryButton} onPress={refresh}>
          <Text style={styles.retryText}>Retry</Text>
        </TouchableOpacity>
      </View>
    );
  }
  
  if (loading && messages.length === 0) {
    return (
      <View style={styles.centerContainer}>
        <ActivityIndicator size="large" color="#0000ff" />
      </View>
    );
  }
  
  return (
    <FlatList
      ref={flatListRef}
      data={messages}
      renderItem={renderItem}
      keyExtractor={(item) => item.id}
      style={styles.container}
      inverted
      contentContainerStyle={styles.listContent}
      ListFooterComponent={renderFooter}
      onEndReached={() => {
        if (hasMore && !loading) {
          loadMore();
        }
      }}
      onEndReachedThreshold={0.5}
      refreshControl={
        <RefreshControl refreshing={loading} onRefresh={refresh} />
      }
      ListEmptyComponent={
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyText}>No messages yet</Text>
        </View>
      }
    />
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f0f0f0',
  },
  listContent: {
    paddingVertical: 16,
    paddingHorizontal: 16,
  },
  messageContainer: {
    maxWidth: '80%',
    marginVertical: 4,
    padding: 12,
    borderRadius: 16,
  },
  ownMessage: {
    alignSelf: 'flex-end',
    backgroundColor: '#0084ff',
    borderBottomRightRadius: 4,
  },
  otherMessage: {
    alignSelf: 'flex-start',
    backgroundColor: '#e5e5ea',
    borderBottomLeftRadius: 4,
  },
  messageText: {
    fontSize: 16,
  },
  ownMessageText: {
    color: 'white',
  },
  otherMessageText: {
    color: 'black',
  },
  messageTime: {
    fontSize: 12,
    marginTop: 4,
    opacity: 0.7,
    alignSelf: 'flex-end',
    color: 'rgba(0,0,0,0.5)',
  },
  centerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  errorText: {
    color: 'red',
    marginBottom: 16,
  },
  retryButton: {
    padding: 12,
    backgroundColor: '#0084ff',
    borderRadius: 8,
  },
  retryText: {
    color: 'white',
    fontWeight: 'bold',
  },
  loadMoreButton: {
    padding: 12,
    backgroundColor: '#f0f0f0',
    borderRadius: 8,
    marginVertical: 16,
    alignItems: 'center',
  },
  loadMoreText: {
    color: '#0084ff',
    fontWeight: 'bold',
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    height: 200,
  },
  emptyText: {
    color: '#666',
    fontSize: 16,
  },
});