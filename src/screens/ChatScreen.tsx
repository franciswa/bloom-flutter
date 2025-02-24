import React, { useState } from 'react';
import { View, FlatList, KeyboardAvoidingView, Platform } from 'react-native';
import { YStack, Text, Input, Button, Card, XStack } from 'tamagui';
import { MessagesScreenProps } from '../types/navigation';
import { useAuth } from '../hooks/useAuth';
import { useProfile } from '../hooks/useProfile';

type Props = MessagesScreenProps<'Chat'>;

interface Message {
  id: string;
  senderId: string;
  text: string;
  timestamp: string;
}

// Temporary sample data
const sampleMessages: Message[] = [
  {
    id: "1",
    senderId: "other",
    text: "Hey there! I noticed we have a high compatibility score.",
    timestamp: "10:30 AM",
  },
  {
    id: "2",
    senderId: "user",
    text: "Hi! Yes, I saw that too. Our charts seem to align really well!",
    timestamp: "10:31 AM",
  },
  {
    id: "3",
    senderId: "other",
    text: "That's amazing! I'd love to hear more about your interests.",
    timestamp: "10:32 AM",
  },
  {
    id: "4",
    senderId: "user",
    text: "Well, I'm really into astrology (obviously!) and love exploring how it connects to our daily lives.",
    timestamp: "10:33 AM",
  },
];

export default function ChatScreen({ navigation, route }: Props) {
  const { user } = useAuth();
  const { profile } = useProfile(user?.id || '');
  const [message, setMessage] = useState('');

  const renderMessage = ({ item }: { item: Message }) => {
    const isUserMessage = item.senderId === 'user';

    return (
      <XStack
        justifyContent={isUserMessage ? 'flex-end' : 'flex-start'}
        paddingHorizontal="$4"
        marginVertical="$2"
      >
        <Card
          backgroundColor={isUserMessage ? '$primary' : '$backgroundHover'}
          padding="$3"
          borderRadius="$4"
          maxWidth="80%"
        >
          <YStack space="$1">
            <Text color={isUserMessage ? '$background' : '$text'}>
              {item.text}
            </Text>
            <Text
              color={isUserMessage ? '$backgroundHover' : '$textSecondary'}
              fontSize="$2"
              textAlign={isUserMessage ? 'right' : 'left'}
            >
              {item.timestamp}
            </Text>
          </YStack>
        </Card>
      </XStack>
    );
  };

  const handleSend = () => {
    if (!message.trim()) return;

    // TODO: Implement actual message sending
    console.log('Sending message:', message);
    setMessage('');
  };

  if (!profile) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <Text>Loading...</Text>
      </View>
    );
  }

  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      keyboardVerticalOffset={Platform.OS === 'ios' ? 90 : 0}
    >
      <View style={{ flex: 1 }}>
        <FlatList
          data={sampleMessages}
          renderItem={renderMessage}
          keyExtractor={(item) => item.id}
          contentContainerStyle={{ paddingVertical: 20 }}
          inverted={false}
        />

        <Card
          bordered
          padding="$4"
          backgroundColor="$background"
          borderRadius={0}
        >
          <XStack space="$2" alignItems="center">
            <Input
              flex={1}
              size="$4"
              placeholder="Type a message..."
              value={message}
              onChangeText={setMessage}
              backgroundColor="$backgroundHover"
              borderColor="$borderColor"
            />
            <Button
              size="$4"
              backgroundColor="$primary"
              color="$background"
              onPress={handleSend}
              disabled={!message.trim()}
            >
              Send
            </Button>
          </XStack>
        </Card>
      </View>
    </KeyboardAvoidingView>
  );
}
