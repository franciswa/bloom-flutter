import React, { useState, useRef } from 'react';
import { KeyboardAvoidingView, Platform, TextInput, ScrollView } from 'react-native';
import { useAuth } from '../hooks/useAuth';
import { useChat } from '../hooks/useChat';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { RootStackParamList } from '../navigation/MainNavigator';
import { Avatar as TamaguiAvatar } from 'tamagui';
import {
  Container,
  MessageBubble,
  MessageText,
  MessageTimeText,
  MessageContainer,
  MessageInputContainer,
  MessageInput,
  StyledButton,
  BodyText,
} from '../theme/components';

type Props = NativeStackScreenProps<RootStackParamList, 'Chat'>;

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
        <TamaguiAvatar circular size="$4" marginRight="$2">
          <TamaguiAvatar.Image src={matchPhoto} />
          <TamaguiAvatar.Fallback backgroundColor="$secondary" />
        </TamaguiAvatar>
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
        <MessageContainer>
          <ScrollView
            ref={scrollViewRef}
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
                <MessageTimeText>
                  {formatMessageTime(message.created_at)}
                </MessageTimeText>
              </MessageBubble>
            ))}
            {loading && (
              <BodyText textAlign="center" color="$textSecondary">
                Loading messages...
              </BodyText>
            )}
            {error && (
              <BodyText textAlign="center" color="$error">
                {error}
              </BodyText>
            )}
          </ScrollView>
        </MessageContainer>

        <MessageInputContainer>
          <MessageInput
            ref={inputRef}
            placeholder="Type a message..."
            value={newMessage}
            onChangeText={setNewMessage}
            multiline
            maxHeight={100}
            onSubmitEditing={handleSend}
          />
          <StyledButton
            size="small"
            variant="primary"
            disabled={!newMessage.trim()}
            onPress={handleSend}
          >
            Send
          </StyledButton>
        </MessageInputContainer>
      </KeyboardAvoidingView>
    </Container>
  );
}
