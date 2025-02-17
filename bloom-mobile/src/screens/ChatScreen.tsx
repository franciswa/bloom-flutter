import React, { useState, useRef } from 'react';
import { FlatList, KeyboardAvoidingView, Platform, ActivityIndicator } from 'react-native';
import {
  YStack,
  XStack,
  Text,
  Input,
  Button,
  Card,
  Separator,
  styled,
  Stack,
} from 'tamagui';
import { Ionicons } from '@expo/vector-icons';
import { useRoute, RouteProp } from '@react-navigation/native';
import { useMatch } from '../hooks/useMatch';
import { RootStackParamList } from '../types/navigation';
import { Message } from '../types/database';

type ChatScreenRouteProp = RouteProp<RootStackParamList, 'Chat'>;

const MainContainer = styled(KeyboardAvoidingView, {
  flex: 1,
  backgroundColor: '$background',
});

const Header = styled(YStack, {
  backgroundColor: '$backgroundStrong',
  padding: '$4',
});

const HeaderTitle = styled(Text, {
  fontSize: '$5',
  fontWeight: 'bold',
  color: '$text',
  fontFamily: '$body',
});

const HeaderSubtitle = styled(Text, {
  fontSize: '$3',
  color: '$gray10',
  marginTop: '$1',
  fontFamily: '$body',
});

const MessageList = styled(YStack, {
  padding: '$4',
});

type MessageType = 'self' | 'other' | 'system';

const MessageBubble = styled(Card, {
  maxWidth: '80%',
  borderRadius: '$6',
  padding: '$3',
  marginBottom: '$2',
  
  variants: {
    messageType: {
      self: {
        alignSelf: 'flex-end',
        borderBottomRightRadius: '$1',
        backgroundColor: '$primary',
      },
      other: {
        alignSelf: 'flex-start',
        borderBottomLeftRadius: '$1',
        backgroundColor: '$backgroundHover',
      },
      system: {
        alignSelf: 'center',
        backgroundColor: 'transparent',
        padding: '$2',
      },
    },
  } as const,
});

const MessageText = styled(Text, {
  fontSize: '$4',
  lineHeight: 20,
  fontFamily: '$body',
  
  variants: {
    messageType: {
      self: {
        color: 'white',
      },
      other: {
        color: '$text',
      },
      system: {
        color: '$gray10',
        fontSize: '$2',
        textAlign: 'center',
      },
    },
  } as const,
});

const MessageTime = styled(Text, {
  fontSize: '$2',
  marginTop: '$1',
  alignSelf: 'flex-end',
  fontFamily: '$body',
  
  variants: {
    messageType: {
      self: {
        color: 'white',
      },
      other: {
        color: '$gray10',
      },
      system: {
        color: '$gray10',
      },
    },
  } as const,
});

const InputContainer = styled(XStack, {
  backgroundColor: '$backgroundStrong',
  padding: '$2',
  borderTopWidth: 1,
  borderColor: '$borderColor',
  alignItems: 'center',
});

const ChatInput = styled(Input, {
  flex: 1,
  backgroundColor: '$background',
  borderRadius: '$5',
  marginRight: '$2',
  height: 'auto',
  minHeight: 40,
  maxHeight: 100,
  paddingHorizontal: '$4',
  fontSize: '$4',
  color: '$text',
  fontFamily: '$body',
});

const LoadingContainer = styled(YStack, {
  flex: 1,
  justifyContent: 'center',
  alignItems: 'center',
  backgroundColor: '$background',
});

const ErrorText = styled(Text, {
  fontSize: '$4',
  color: '$red10',
  textAlign: 'center',
  fontFamily: '$body',
});

export default function ChatScreen() {
  const route = useRoute<ChatScreenRouteProp>();
  const { match, messages, loading, error, sendMessage } = useMatch(route.params.matchId);
  const [newMessage, setNewMessage] = useState('');
  const [sending, setSending] = useState(false);
  const flatListRef = useRef<FlatList>(null);

  const handleSend = async () => {
    if (!newMessage.trim()) return;

    setSending(true);
    try {
      await sendMessage(newMessage.trim());
      setNewMessage('');
      // Scroll to bottom after sending
      flatListRef.current?.scrollToOffset({ offset: 0, animated: true });
    } catch (err) {
      // Error is handled by the hook
    } finally {
      setSending(false);
    }
  };

  const renderMessage = ({ item: message }: { item: Message }) => {
    const isSystem = message.is_system_message;
    const isSelf = message.sender_id === match?.user1_id;
    const messageType = isSystem ? 'system' : isSelf ? 'self' : 'other' as const;

    return (
      <MessageBubble messageType={messageType} elevate={!isSystem}>
        <MessageText messageType={messageType}>{message.content}</MessageText>
        {!isSystem && (
          <MessageTime messageType={messageType}>
            {new Date(message.created_at).toLocaleTimeString([], {
              hour: '2-digit',
              minute: '2-digit'
            })}
          </MessageTime>
        )}
      </MessageBubble>
    );
  };

  if (loading) {
    return (
      <LoadingContainer>
        <ActivityIndicator size="large" color="$primary" />
      </LoadingContainer>
    );
  }

  if (error || !match) {
    return (
      <LoadingContainer>
        <ErrorText>{error || 'Failed to load chat'}</ErrorText>
      </LoadingContainer>
    );
  }

  return (
    <MainContainer
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      keyboardVerticalOffset={Platform.OS === 'ios' ? 88 : 0}
    >
      <Header>
        <HeaderTitle>
          {match.partner_profile.email?.split('@')[0]}
        </HeaderTitle>
        <HeaderSubtitle>
          {match.date_type} • {new Date(match.match_date).toLocaleDateString()}
        </HeaderSubtitle>
      </Header>

      <Separator />

      <FlatList
        ref={flatListRef}
        data={messages}
        renderItem={renderMessage}
        keyExtractor={item => item.id}
        inverted
        contentContainerStyle={{ padding: 16 }}
        showsVerticalScrollIndicator={false}
      />

      <InputContainer>
        <ChatInput
          placeholder="Type a message..."
          value={newMessage}
          onChangeText={setNewMessage}
          multiline
          maxLength={500}
          disabled={sending}
        />
        <Button
          onPress={handleSend}
          disabled={sending || !newMessage.trim()}
          backgroundColor={sending || !newMessage.trim() ? '$gray8' : '$primary'}
          borderRadius="$4"
          padding="$3"
          pressStyle={{ opacity: 0.8 }}
        >
          <Ionicons 
            name="send" 
            size={24} 
            color={sending || !newMessage.trim() ? '$gray10' : 'white'} 
          />
        </Button>
      </InputContainer>
    </MainContainer>
  );
}
