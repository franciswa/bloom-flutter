import React, { useState } from 'react';
import { ScrollView, TouchableOpacity } from 'react-native';
import { useAuth } from '../hooks/useAuth';
import { useProfile } from '../hooks/useProfile';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { TabParamList, RootStackParamList } from '../navigation/MainNavigator';
import { CompositeScreenProps } from '@react-navigation/native';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import { Avatar as TamaguiAvatar } from 'tamagui';
import {
  Container,
  Title,
  BodyText,
  StyledCard,
  Badge,
  BadgeText,
  Row,
  XStack,
  YStack,
} from '../theme/components';

type Props = CompositeScreenProps<
  BottomTabScreenProps<TabParamList, 'Messages'>,
  NativeStackScreenProps<RootStackParamList>
>;

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
      <Title marginBottom="$4">Messages</Title>
      <ScrollView showsVerticalScrollIndicator={false}>
        {conversations.map((conversation) => (
          <TouchableOpacity
            key={conversation.id}
            onPress={() => handleConversationPress(conversation)}
            activeOpacity={0.7}
          >
            <StyledCard marginBottom="$3" interactive>
              <Row>
                <TamaguiAvatar circular size="$6">
                  <TamaguiAvatar.Image src={conversation.matchPhoto} />
                  <TamaguiAvatar.Fallback backgroundColor="$secondary" />
                </TamaguiAvatar>
                
                <YStack flex={1} marginLeft="$3">
                  <XStack justifyContent="space-between" alignItems="center">
                    <BodyText
                      fontSize="$4"
                      fontWeight={conversation.unreadCount > 0 ? '600' : '400'}
                    >
                      {conversation.matchName}
                    </BodyText>
                    <BodyText
                      fontSize="$2"
                      color="$textSubtle"
                    >
                      {formatMessageTime(conversation.lastMessage.timestamp)}
                    </BodyText>
                  </XStack>
                  
                  <XStack alignItems="center" marginTop="$1">
                    <BodyText
                      flex={1}
                      numberOfLines={1}
                      fontWeight={conversation.unreadCount > 0 ? '600' : '400'}
                      color={conversation.unreadCount > 0 ? '$text' : '$textSecondary'}
                    >
                      {conversation.lastMessage.senderId === user?.id ? 'You: ' : ''}
                      {conversation.lastMessage.content}
                    </BodyText>
                    
                    {conversation.unreadCount > 0 && (
                      <Badge>
                        <BadgeText>
                          {conversation.unreadCount}
                        </BadgeText>
                      </Badge>
                    )}
                  </XStack>
                </YStack>
              </Row>
            </StyledCard>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </Container>
  );
}
