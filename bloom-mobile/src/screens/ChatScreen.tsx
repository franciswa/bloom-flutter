import React, { useState, useRef } from 'react';
import {
  YStack,
  XStack,
  Text,
  Input,
  Button,
  ScrollView,
  Avatar,
  styled,
} from 'tamagui';
import { KeyboardAvoidingView, Platform, TextInput, ScrollView as RNScrollView } from 'react-native';
import { useAuth } from '../hooks/useAuth';
import { useChat } from '../hooks/useChat';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { RootStackParamList } from '../navigation/MainNavigator';

type Props = NativeStackScreenProps<RootStackParamList, 'Chat'>;

const Container = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
});

const MessageList = styled(RNScrollView, {
  flex: 1,
  padding: '$4',
});

import type { GetProps } from '@tamagui/web';

type MessageBubbleProps = GetProps<typeof YStack> & {
  sent?: boolean;
};

const MessageBubble = styled(YStack, {
  name: 'MessageBubble',
  maxWidth: '80%',
  padding: '$3',
  borderRadius: 16,
  marginBottom: '$2',
  variants: {
    sent: {
      true: {
        backgroundColor: '$blue9',
        alignSelf: 'flex-end',
      },
      false: {
        backgroundColor: '$gray5',
        alignSelf: 'flex-start',
      },
    },
  } as const,
  defaultVariants: {
    sent: false,
  },
} as const) as React.FC<MessageBubbleProps>;

type MessageTextProps = GetProps<typeof Text> & {
  sent?: boolean;
};

const MessageText = styled(Text, {
  name: 'MessageText',
  variants: {
    sent: {
      true: {
        color: 'white',
      },
      false: {
        color: '$gray12',
      },
    },
  } as const,
  defaultVariants: {
    sent: false,
  },
} as const) as React.FC<MessageTextProps>;

const TimeText = styled(Text, {
  fontSize: '$2',
  color: '$gray10',
  marginTop: '$1',
});

const InputContainer = styled(XStack, {
  padding: '$4',
  borderTopWidth: 1,
  borderTopColor: '$borderColor',
  backgroundColor: '$background',
});

const MessageInput = styled(Input, {
  flex: 1,
  marginRight: '$2',
  paddingVertical: '$2',
});

function formatMessageTime(timestamp: string): string {
  const date = new Date(timestamp);
  return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

export default function ChatScreen({ route, navigation }: Props) {
  const { matchId, matchName, matchPhoto } = route.params;
  const { user } = useAuth();
  const { messages, loading, error, sendMessage, loadMoreMessages, hasMoreMessages } = useChat(
    matchId,
    user?.id || ''
  );
  const [newMessage, setNewMessage] = useState('');
  const scrollViewRef = useRef<ScrollView>(null);
  const inputRef = useRef<TextInput>(null);

  React.useLayoutEffect(() => {
    navigation.setOptions({
      title: matchName,
      headerRight: () => (
        <Avatar circular size="$4" marginRight="$2">
          <Avatar.Image src={matchPhoto} />
          <Avatar.Fallback backgroundColor="$gray5" />
        </Avatar>
      ),
    });
  }, [navigation, matchName, matchPhoto]);

  const handleSend = async () => {
    if (!newMessage.trim()) return;

    try {
      await sendMessage(newMessage.trim());
      setNewMessage('');
      inputRef.current?.clear();
      // Scroll to bottom after sending
      scrollViewRef.current?.scrollToEnd({ animated: true });
    } catch (err) {
      // Error is handled by the hook
      console.error('Failed to send message:', err);
    }
  };

  const handleScroll = ({ nativeEvent }: any) => {
    // Load more when scrolling near the top
    if (nativeEvent.contentOffset.y <= 0 && hasMoreMessages && !loading) {
      loadMoreMessages();
    }
  };

  return (
    <Container>
      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        style={{ flex: 1 }}
      >
        <MessageList
          ref={scrollViewRef as any}
          onScroll={handleScroll}
          scrollEventThrottle={400}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={{ flexDirection: 'column-reverse' }}
        >
          {messages.map((message) => (
            <MessageBubble
              key={message.id}
              sent={message.sender_id === user?.id}
            >
              <MessageText sent={message.sender_id === user?.id}>
                {message.content}
              </MessageText>
              <TimeText>
                {formatMessageTime(message.created_at)}
              </TimeText>
            </MessageBubble>
          ))}
          {loading && (
            <Text textAlign="center" color="$gray11">
              Loading messages...
            </Text>
          )}
          {error && (
            <Text textAlign="center" color="$red10">
              {error}
            </Text>
          )}
        </MessageList>

        <InputContainer>
          <MessageInput
            ref={inputRef}
            placeholder="Type a message..."
            value={newMessage}
            onChangeText={setNewMessage}
            multiline
            maxHeight={100}
            onSubmitEditing={handleSend}
          />
          <Button
            size="$4"
            theme="blue"
            disabled={!newMessage.trim()}
            onPress={handleSend}
          >
            Send
          </Button>
        </InputContainer>
      </KeyboardAvoidingView>
    </Container>
  );
}
