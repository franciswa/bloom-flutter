import React from 'react';
import { View, FlatList, Image } from 'react-native';
import { YStack, Text, Button, Card, XStack } from 'tamagui';
import { MainScreenProps } from '../types/navigation';
import { useAuth } from '../hooks/useAuth';
import { useProfile } from '../hooks/useProfile';

type Props = MainScreenProps<'Matches'>;

interface Match {
  id: string;
  name: string;
  age: number;
  location: string;
  compatibility: number;
  photoUrl: string;
}

// Temporary sample data
const sampleMatches: Match[] = [
  {
    id: '1',
    name: 'Sarah',
    age: 28,
    location: 'San Francisco, CA',
    compatibility: 95,
    photoUrl: 'https://picsum.photos/200',
  },
  {
    id: '2',
    name: 'Emma',
    age: 26,
    location: 'Los Angeles, CA',
    compatibility: 92,
    photoUrl: 'https://picsum.photos/201',
  },
  {
    id: '3',
    name: 'Olivia',
    age: 29,
    location: 'New York, NY',
    compatibility: 88,
    photoUrl: 'https://picsum.photos/202',
  },
];

export default function MatchesScreen({ navigation }: Props) {
  const { user } = useAuth();
  const { profile } = useProfile(user?.id || '');

  const renderMatch = ({ item }: { item: Match }) => (
    <Card
      bordered
      marginHorizontal="$4"
      marginVertical="$2"
      padding="$4"
      animation="bouncy"
      pressStyle={{ scale: 0.97 }}
    >
      <XStack space="$4">
        <Image
          source={{ uri: item.photoUrl }}
          style={{
            width: 80,
            height: 80,
            borderRadius: 40,
          }}
        />
        <YStack flex={1} justifyContent="center" space="$1">
          <Text fontFamily="$heading" fontSize="$5">
            {item.name}, {item.age}
          </Text>
          <Text color="$textSecondary" fontSize="$3">
            {item.location}
          </Text>
          <Text color="$primary" fontSize="$4" fontWeight="bold">
            {item.compatibility}% Match
          </Text>
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
          Your Matches
        </Text>
        <Text color="$textSecondary" fontSize="$4">
          Based on your astrological compatibility
        </Text>
      </YStack>

      <FlatList
        data={sampleMatches}
        renderItem={renderMatch}
        keyExtractor={(item) => item.id}
        contentContainerStyle={{ paddingBottom: 20 }}
      />
    </View>
  );
}
