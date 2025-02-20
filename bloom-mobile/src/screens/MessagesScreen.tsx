import React, { useState } from 'react';
import {
  YStack,
  XStack,
  Text,
  H2,
  Card,
  Avatar,
  styled,
} from 'tamagui';
import { ScrollView, TouchableOpacity } from 'react-native';
import { useAuth } from '../hooks/useAuth';
import { useProfile } from '../hooks/useProfile';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { TabParamList, RootStackParamList } from '../navigation/MainNavigator';
import { CompositeScreenProps } from '@react-navigation/native';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';

type Props = CompositeScreenProps<
  BottomTabScreenProps<TabParamList, 'Messages'>,
  NativeStackScreenProps<RootStackParamList>
>;

const Container = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
  padding: '$4',
});

const ConversationCard = styled(Card, {
  marginBottom: '$3',
  padding: '$4',
});

const LastMessageText = styled(Text, {
  color: '$gray11',
  fontSize: '$3',
  marginTop: '$1',
  numberOfLines: 1,
});

const TimeText = styled(Text, {
  color: '$gray10',
  fontSize: '$2',
});

const UnreadBadge = styled(YStack, {
  backgroundColor: '$blue9',
  borderRadius: 10,
  minWidth: 20,
  height: 20,
  justifyContent: 'center',
  alignItems: 'center',
  marginLeft: 'auto',
});

interface Message {
  id: string;
  content: string;
  timestamp: string;
  senderId: string;
  read: boolean;
}

interface Conversation {
  id: string;
  matchId: string;
  matchName: string;
  matchPhoto: string;
  lastMessage: Message;
  unreadCount: number;
}

// Temporary mock data
const mockConversations: Conversation[] = [
  {
    id: '1',
    matchId: '1',
    matchName: 'Sarah',
    matchPhoto: 'https://example.com/profile1.jpg',
    lastMessage: {
      id: 'm1',
      content: 'I love how our moon signs are compatible! ✨',
      timestamp: '2024-02-19T06:30:00Z',
      senderId: '1',
      read: false,
    },
    unreadCount: 2,
  },
  {
    id: '2',
    matchId: '2',
    matchName: 'Emma',
    matchPhoto: 'https://example.com/profile2.jpg',
    lastMessage: {
      id: 'm2',
      content: 'Would you like to get coffee sometime?',
      timestamp: '2024-02-18T22:15:00Z',
      senderId: 'current-user',
      read: true,
    },
    unreadCount: 0,
  },
];

function formatMessageTime(timestamp: string): string {
  const date = new Date(timestamp);
  const now = new Date();
  const diffInHours = (now.getTime() - date.getTime()) / (1000 * 60 * 60);

  if (diffInHours < 24) {
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  } else if (diffInHours < 48) {
    return 'Yesterday';
  } else {
    return date.toLocaleDateString([], { month: 'short', day: 'numeric' });
  }
}

export default function MessagesScreen({ navigation }: Props) {
  const { user } = useAuth();
  const { profile } = useProfile(user?.id || '');
  const [conversations] = useState<Conversation[]>(mockConversations);

  const handleConversationPress = (conversation: Conversation) => {
    navigation.navigate('Chat', {
      matchId: conversation.matchId,
      matchName: conversation.matchName,
      matchPhoto: conversation.matchPhoto,
    });
  };

  return (
    <Container>
      <H2 marginBottom="$4">Messages</H2>
      <ScrollView showsVerticalScrollIndicator={false}>
        {conversations.map((conversation) => (
          <TouchableOpacity
            key={conversation.id}
            onPress={() => handleConversationPress(conversation)}
            activeOpacity={0.7}
          >
            <ConversationCard elevation={1}>
              <XStack space="$3" alignItems="center">
                <Avatar circular size="$6">
                  <Avatar.Image src={conversation.matchPhoto} />
                  <Avatar.Fallback backgroundColor="$gray5" />
                </Avatar>
                
                <YStack flex={1}>
                  <XStack justifyContent="space-between" alignItems="center">
                    <Text
                      fontSize="$5"
                      fontWeight={conversation.unreadCount > 0 ? 'bold' : 'normal'}
                    >
                      {conversation.matchName}
                    </Text>
                    <TimeText>
                      {formatMessageTime(conversation.lastMessage.timestamp)}
                    </TimeText>
                  </XStack>
                  
                  <XStack alignItems="center">
                    <LastMessageText
                      flex={1}
                      fontWeight={conversation.unreadCount > 0 ? 'bold' : 'normal'}
                    >
                      {conversation.lastMessage.senderId === user?.id ? 'You: ' : ''}
                      {conversation.lastMessage.content}
                    </LastMessageText>
                    
                    {conversation.unreadCount > 0 && (
                      <UnreadBadge>
                        <Text color="white" fontSize="$2" fontWeight="bold">
                          {conversation.unreadCount}
                        </Text>
                      </UnreadBadge>
                    )}
                  </XStack>
                </YStack>
              </XStack>
            </ConversationCard>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </Container>
  );
}
