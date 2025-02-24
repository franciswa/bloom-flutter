import React from 'react';
import { View, FlatList, Image } from 'react-native';
import { YStack, Text, Card, XStack } from 'tamagui';
import { MessagesScreenProps } from '../types/navigation';
import { useAuth } from '../hooks/useAuth';
import { useProfile } from '../hooks/useProfile';

type Props = MessagesScreenProps<'MessagesList'>;

interface Message {
  id: string;
  userId: string;
  name: string;
  photoUrl: string;
  lastMessage: string;
  timestamp: string;
  unread: boolean;
}

// Temporary sample data
const sampleMessages: Message[] = [
  {
    id: "1",
    userId: "user1",
    name: "Sarah",
    photoUrl: "https://picsum.photos/200",
    lastMessage: "Hey, how are you?",
    timestamp: "2 min ago",
    unread: true,
  },
  {
    id: "2",
    userId: "user2",
    name: "Emma",
    photoUrl: "https://picsum.photos/201",
    lastMessage: "Would you like to meet for coffee?",
    timestamp: "1 hour ago",
    unread: false,
  },
  {
    id: "3",
    userId: "user3",
    name: "Olivia",
    photoUrl: "https://picsum.photos/202",
    lastMessage: "That sounds great!",
    timestamp: "2 hours ago",
    unread: false,
  },
];

export default function MessagesScreen({ navigation }: Props) {
  const { user } = useAuth();
  const { profile } = useProfile(user?.id || '');

  const renderMessage = ({ item }: { item: Message }) => (
    <Card
      bordered
      marginHorizontal="$4"
      marginVertical="$2"
      padding="$4"
      animation="bouncy"
      pressStyle={{ scale: 0.97 }}
      onPress={() => {
        navigation.navigate('Chat', {
          userId: item.userId,
          name: item.name,
        });
      }}
    >
      <XStack space="$4">
        <Image
          source={{ uri: item.photoUrl }}
          style={{
            width: 60,
            height: 60,
            borderRadius: 30,
          }}
        />
        <YStack flex={1} justifyContent="center" space="$1">
          <XStack justifyContent="space-between" alignItems="center">
            <Text fontFamily="$heading" fontSize="$5">
              {item.name}
            </Text>
            <Text color="$textSecondary" fontSize="$2">
              {item.timestamp}
            </Text>
          </XStack>
          <XStack space="$2" alignItems="center">
            <Text
              color={item.unread ? '$text' : '$textSecondary'}
              fontSize="$3"
              fontWeight={item.unread ? 'bold' : 'normal'}
              numberOfLines={1}
              flex={1}
            >
              {item.lastMessage}
            </Text>
            {item.unread && (
              <View
                style={{
                  width: 8,
                  height: 8,
                  borderRadius: 4,
                  backgroundColor: '$primary',
                }}
              />
            )}
          </XStack>
        </YStack>
      </XStack>
    </Card>
  );

  if (!profile) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <Text>Loading...</Text>
      </View>
    );
  }

  return (
    <View style={{ flex: 1 }}>
      <YStack padding="$4" space="$4">
        <Text fontFamily="$heading" fontSize="$6">
          Messages
        </Text>
      </YStack>

      <FlatList
        data={sampleMessages}
        renderItem={renderMessage}
        keyExtractor={(item) => item.id}
        contentContainerStyle={{ paddingBottom: 20 }}
      />
    </View>
  );
}
