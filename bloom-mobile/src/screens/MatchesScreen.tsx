import React, { useState } from 'react';
import {
  YStack,
  XStack,
  Text,
  H2,
  Card,
  Image,
  Progress,
  styled,
} from 'tamagui';
import { StyledButton } from '../theme/components';
import { ScrollView } from 'react-native';
import { useProfile } from '../hooks/useProfile';
import { useAuth } from '../hooks/useAuth';
import { CompatibilityScore } from '../types/compatibility';

const Container = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
  padding: '$4',
});

const MatchCard = styled(Card, {
  marginBottom: '$4',
  overflow: 'hidden',
});

const MatchImage = styled(Image, {
  width: '100%',
  height: 300,
  backgroundColor: '$gray5',
});

const MatchInfo = styled(YStack, {
  padding: '$4',
  space: '$2',
});

const ScoreContainer = styled(XStack, {
  alignItems: 'center',
  space: '$2',
  marginTop: '$2',
});

const ActionButtons = styled(XStack, {
  justifyContent: 'space-between',
  padding: '$4',
  borderTopWidth: 1,
  borderTopColor: '$borderColor',
});

interface Match {
  id: string;
  name: string;
  age: number;
  imageUrl: string;
  location: string;
  bio: string;
  compatibility: CompatibilityScore;
}

// Temporary mock data
const mockMatches: Match[] = [
  {
    id: '1',
    name: 'Sarah',
    age: 28,
    imageUrl: 'https://example.com/profile1.jpg',
    location: 'San Francisco, CA',
    bio: 'Adventurous spirit seeking cosmic connection ✨',
    compatibility: {
      total: 85,
      questionnaire: 80,
      astrological: {
        total: 90,
        aspect: {
          total: 88,
          aspectScore: 85,
          elementScore: 90,
          aspectDetails: []
        },
        element: {
          elementScore: 92,
          signModifier: 5
        }
      }
    }
  },
  {
    id: '2',
    name: 'Emma',
    age: 26,
    imageUrl: 'https://example.com/profile2.jpg',
    location: 'Los Angeles, CA',
    bio: "Let's explore the stars together 🌟",
    compatibility: {
      total: 78,
      questionnaire: 75,
      astrological: {
        total: 82,
        aspect: {
          total: 80,
          aspectScore: 78,
          elementScore: 82,
          aspectDetails: []
        },
        element: {
          elementScore: 85,
          signModifier: 3
        }
      }
    }
  }
];

export default function MatchesScreen() {
  const { user } = useAuth();
  const { profile } = useProfile(user?.id || '');
  const [matches] = useState<Match[]>(mockMatches);

  const handleLike = (matchId: string) => {
    // TODO: Implement like functionality
    console.log('Liked:', matchId);
  };

  const handlePass = (matchId: string) => {
    // TODO: Implement pass functionality
    console.log('Passed:', matchId);
  };

  const getScoreColor = (score: number) => {
    if (score >= 80) return '$secondary';
    if (score >= 60) return '$secondary';
    return '$secondary';
  };

  return (
    <Container>
      <H2 marginBottom="$4">Matches</H2>
      <ScrollView showsVerticalScrollIndicator={false}>
        {matches.map((match) => (
          <MatchCard key={match.id} elevation={2}>
            <MatchImage source={{ uri: match.imageUrl }} />
            <MatchInfo>
              <Text fontSize="$6" fontWeight="bold">
                {match.name}, {match.age}
              </Text>
              <Text color="$gray11">{match.location}</Text>
              <Text marginTop="$2">{match.bio}</Text>
              
              <ScoreContainer>
                <Text fontWeight="bold" color={getScoreColor(match.compatibility.total)}>
                  {match.compatibility.total}% Match
                </Text>
                <Progress
                  value={match.compatibility.total}
                  backgroundColor="$gray5"
                  width={150}
                >
                  <Progress.Indicator
                    animation="bouncy"
                    backgroundColor={getScoreColor(match.compatibility.total)}
                  />
                </Progress>
              </ScoreContainer>

              <XStack marginTop="$2" space="$2">
                <Text fontSize="$3" color="$gray11">
                  Astrological: {match.compatibility.astrological.total}%
                </Text>
                <Text fontSize="$3" color="$gray11">
                  •
                </Text>
                <Text fontSize="$3" color="$gray11">
                  Questionnaire: {match.compatibility.questionnaire}%
                </Text>
              </XStack>
            </MatchInfo>

            <ActionButtons>
              <StyledButton
                variant="outline"
                onPress={() => handlePass(match.id)}
                icon={<Text fontSize={20} color="$text">✕</Text>}
                size="small"
              />
              <StyledButton
                variant="primary"
                onPress={() => handleLike(match.id)}
                icon={<Text fontSize={20} color="$text">♥</Text>}
                size="small"
              />
            </ActionButtons>
          </MatchCard>
        ))}
      </ScrollView>
    </Container>
  );
}
