import React, { useState } from 'react';
import { ScrollView } from 'react-native';
import { Progress, Text } from 'tamagui';
import { Ionicons } from '@expo/vector-icons';
import {
  Container,
  Title,
  MatchCard,
  MatchImage,
  MatchName,
  MatchBio,
  MatchStat,
  MatchStatLabel,
  MatchStatValue,
  CompatibilityScore,
  CompatibilityText,
  StyledButton,
  XStack,
  YStack,
} from '../theme/components';
import { useProfile } from '../hooks/useProfile';
import { useAuth } from '../hooks/useAuth';
import { CompatibilityScore as CompatibilityScoreType } from '../types/compatibility';

interface Match {
  id: string;
  name: string;
  age: number;
  imageUrl: string;
  location: string;
  bio: string;
  compatibility: CompatibilityScoreType;
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

  const handleViewProfile = (matchId: string) => {
    // TODO: Navigate to match profile
    console.log('View profile:', matchId);
  };

  const getScoreColor = (score: number) => {
    if (score >= 80) return '$success';
    if (score >= 60) return '$warning';
    return '$error';
  };

  return (
    <Container>
      <Title marginBottom="$4">Discover</Title>
      <ScrollView showsVerticalScrollIndicator={false}>
        {matches.map((match) => (
          <MatchCard key={match.id} onPress={() => handleViewProfile(match.id)}>
            <MatchImage>
              {/* TODO: Add proper image loading */}
              <Text>Image placeholder</Text>
            </MatchImage>

            <CompatibilityScore>
              <CompatibilityText>
                {match.compatibility.total}%
              </CompatibilityText>
            </CompatibilityScore>

            <YStack padding="$4" space="$2">
              <MatchName>
                {match.name}, {match.age}
              </MatchName>
              <Text color="$textSecondary">{match.location}</Text>
              <MatchBio>{match.bio}</MatchBio>

              <YStack space="$3" marginTop="$2">
                <MatchStat>
                  <MatchStatLabel>Astrological Match</MatchStatLabel>
                  <MatchStatValue>{match.compatibility.astrological.total}%</MatchStatValue>
                  <Progress
                    value={match.compatibility.astrological.total}
                    backgroundColor="$backgroundHover"
                    width={100}
                  >
                    <Progress.Indicator
                      animation="quick"
                      backgroundColor={getScoreColor(match.compatibility.astrological.total)}
                    />
                  </Progress>
                </MatchStat>

                <MatchStat>
                  <MatchStatLabel>Values Match</MatchStatLabel>
                  <MatchStatValue>{match.compatibility.questionnaire}%</MatchStatValue>
                  <Progress
                    value={match.compatibility.questionnaire}
                    backgroundColor="$backgroundHover"
                    width={100}
                  >
                    <Progress.Indicator
                      animation="quick"
                      backgroundColor={getScoreColor(match.compatibility.questionnaire)}
                    />
                  </Progress>
                </MatchStat>
              </YStack>

              <XStack marginTop="$4" justifyContent="space-between">
                <StyledButton
                  variant="outline"
                  onPress={() => handlePass(match.id)}
                  icon={<Ionicons name="close" size={24} color="$text" />}
                  size="small"
                />
                <StyledButton
                  variant="primary"
                  onPress={() => handleLike(match.id)}
                  icon={<Ionicons name="heart" size={24} color="$text" />}
                  size="small"
                />
              </XStack>
            </YStack>
          </MatchCard>
        ))}
      </ScrollView>
    </Container>
  );
}
