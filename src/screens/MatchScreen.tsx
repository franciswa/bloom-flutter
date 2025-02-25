import React, { useState } from 'react';
import { Alert } from 'react-native';
import {
  YStack,
  XStack,
  Text,
  H1,
  H4,
  Button,
  Card,
  Separator,
  styled,
  ScrollView,
  Progress,
} from 'tamagui';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation, NavigationProp } from '@react-navigation/native';
import { useMatches } from '../hooks/useMatches';
import { MatchWithProfile } from '../hooks/useMatches';
import { RootStackParamList } from '../types/navigation';

type MatchScreenNavigationProp = NavigationProp<RootStackParamList>;

const MainContainer = styled(ScrollView, {
  flex: 1,
  backgroundColor: '$background',
});

const Header = styled(YStack, {
  paddingHorizontal: '$4',
  paddingVertical: '$5',
});

const HeaderTitle = styled(H1, {
  color: '$text',
  fontFamily: '$heading',
});

const Section = styled(YStack, {
  padding: '$4',
});

const SectionTitle = styled(H4, {
  color: '$text',
  marginBottom: '$4',
  fontFamily: '$heading',
});

const MatchCard = styled(Card, {
  backgroundColor: '$backgroundStrong',
  marginBottom: '$3',
  padding: '$4',
});

const MatchHeader = styled(XStack, {
  justifyContent: 'space-between',
  alignItems: 'center',
  marginBottom: '$3',
});

const PartnerInfo = styled(YStack, {
  gap: '$1',
});

const PartnerName = styled(Text, {
  fontSize: '$5',
  fontWeight: 'bold',
  color: '$text',
  fontFamily: '$body',
});

const MatchDate = styled(Text, {
  fontSize: '$3',
  color: '$gray10',
  fontFamily: '$body',
});

const ScoreContainer = styled(YStack, {
  alignItems: 'center',
});

const ScoreText = styled(Text, {
  fontSize: '$6',
  fontWeight: 'bold',
  color: '$primary',
  fontFamily: '$body',
});

const ScoreLabel = styled(Text, {
  fontSize: '$2',
  color: '$gray10',
  marginTop: '$1',
  fontFamily: '$body',
});

const DetailRow = styled(XStack, {
  alignItems: 'center',
  space: '$2',
  marginBottom: '$2',
});

const DetailText = styled(Text, {
  fontSize: '$3',
  color: '$text',
  fontFamily: '$body',
});

const ActionButtons = styled(XStack, {
  justifyContent: 'space-between',
  marginTop: '$4',
  space: '$3',
});

const EmptyState = styled(YStack, {
  backgroundColor: '$backgroundStrong',
  padding: '$8',
  borderRadius: '$4',
  alignItems: 'center',
});

const EmptyStateText = styled(Text, {
  fontSize: '$4',
  textAlign: 'center',
  marginTop: '$4',
  lineHeight: 24,
  color: '$text',
  fontFamily: '$body',
});

const LoadingContainer = styled(YStack, {
  flex: 1,
  justifyContent: 'center',
  alignItems: 'center',
  backgroundColor: '$background',
});

const LoadingText = styled(Text, {
  fontSize: '$4',
  color: '$text',
  fontFamily: '$body',
});

const ErrorContainer = styled(YStack, {
  padding: '$4',
  alignItems: 'center',
});

const ErrorText = styled(Text, {
  fontSize: '$3',
  color: '$red10',
  textAlign: 'center',
  marginBottom: '$4',
  fontFamily: '$body',
});

const CompatibilitySection = styled(YStack, {
  marginTop: '$4',
  marginBottom: '$2',
});

const CompatibilityTitle = styled(Text, {
  fontSize: '$3',
  fontWeight: 'bold',
  color: '$text',
  marginBottom: '$2',
  fontFamily: '$body',
});

const CompatibilityRow = styled(YStack, {
  marginBottom: '$2',
});

const CompatibilityLabel = styled(Text, {
  fontSize: '$2',
  color: '$gray10',
  marginBottom: '$1',
  fontFamily: '$body',
});

const CompatibilityBar = styled(Progress, {
  height: 8,
  overflow: 'hidden',
  borderRadius: 4,
  backgroundColor: '$backgroundHover',
});

const CompatibilityValue = styled(Text, {
  fontSize: '$2',
  color: '$gray10',
  marginTop: '$1',
  alignSelf: 'flex-end',
  fontFamily: '$body',
});

const ToggleButton = styled(Button, {
  backgroundColor: 'transparent',
  color: '$primary',
  fontFamily: '$body',
  fontSize: '$2',
  marginTop: '$2',
  alignSelf: 'center',
});

export default function MatchScreen() {
  const navigation = useNavigation<MatchScreenNavigationProp>();
  const { 
    pendingMatches, 
    activeMatches, 
    loading, 
    error, 
    acceptMatch, 
    rejectMatch, 
    refresh,
    loadMore,
    hasMore
  } = useMatches(20); // Load 20 matches per page
  const [expandedMatches, setExpandedMatches] = useState<Record<string, boolean>>({});

  const toggleMatchDetails = (matchId: string) => {
    setExpandedMatches(prev => ({
      ...prev,
      [matchId]: !prev[matchId]
    }));
  };

  const handleAcceptMatch = async (matchId: string) => {
    Alert.alert(
      'Accept Match',
      'Would you like to accept this match?',
      [
        { text: 'No', style: 'cancel' },
        {
          text: 'Yes',
          onPress: async () => {
            try {
              await acceptMatch(matchId);
              const match = pendingMatches.find(m => m.id === matchId);
              if (match) {
                navigation.navigate('Main', { 
                  screen: 'Messages',
                  params: {
                    screen: 'Chat',
                    params: {
                      userId: match.partner_profile.id || '',
                      name: match.partner_profile.email?.split('@')[0] || 'Match'
                    }
                  }
                });
              }
            } catch (err) {
              Alert.alert('Error', 'Failed to accept match');
            }
          }
        }
      ]
    );
  };

  const handleRejectMatch = async (matchId: string) => {
    Alert.alert(
      'Reject Match',
      'Are you sure you want to reject this match?',
      [
        { text: 'No', style: 'cancel' },
        {
          text: 'Yes',
          style: 'destructive',
          onPress: async () => {
            try {
              await rejectMatch(matchId);
            } catch (err) {
              Alert.alert('Error', 'Failed to reject match');
            }
          }
        }
      ]
    );
  };

  const renderCompatibilityDetails = (match: MatchWithProfile) => {
    if (!match.compatibility_details) return null;
    
    const { 
      zodiac_compatibility, 
      personality_match, 
      lifestyle_match, 
      values_match,
      overall_compatibility
    } = match.compatibility_details;
    
    return (
      <CompatibilitySection>
        <CompatibilityTitle>Compatibility Breakdown</CompatibilityTitle>
        
        <CompatibilityRow>
          <CompatibilityLabel>Overall</CompatibilityLabel>
          <CompatibilityBar value={overall_compatibility / 100}>
            <Progress.Indicator backgroundColor="$primary" />
          </CompatibilityBar>
          <CompatibilityValue>{overall_compatibility}%</CompatibilityValue>
        </CompatibilityRow>
        
        <CompatibilityRow>
          <CompatibilityLabel>Astrological</CompatibilityLabel>
          <CompatibilityBar value={zodiac_compatibility / 100}>
            <Progress.Indicator backgroundColor="$purple10" />
          </CompatibilityBar>
          <CompatibilityValue>{zodiac_compatibility}%</CompatibilityValue>
        </CompatibilityRow>
        
        <CompatibilityRow>
          <CompatibilityLabel>Personality</CompatibilityLabel>
          <CompatibilityBar value={personality_match / 100}>
            <Progress.Indicator backgroundColor="$blue10" />
          </CompatibilityBar>
          <CompatibilityValue>{personality_match}%</CompatibilityValue>
        </CompatibilityRow>
        
        <CompatibilityRow>
          <CompatibilityLabel>Lifestyle</CompatibilityLabel>
          <CompatibilityBar value={lifestyle_match / 100}>
            <Progress.Indicator backgroundColor="$green10" />
          </CompatibilityBar>
          <CompatibilityValue>{lifestyle_match}%</CompatibilityValue>
        </CompatibilityRow>
        
        <CompatibilityRow>
          <CompatibilityLabel>Values</CompatibilityLabel>
          <CompatibilityBar value={values_match / 100}>
            <Progress.Indicator backgroundColor="$orange10" />
          </CompatibilityBar>
          <CompatibilityValue>{values_match}%</CompatibilityValue>
        </CompatibilityRow>
      </CompatibilitySection>
    );
  };

  const renderMatchCard = (match: MatchWithProfile, isPending: boolean = false) => {
    const isExpanded = expandedMatches[match.id] || false;
    
    return (
      <MatchCard key={match.id} elevate>
        <MatchHeader>
          <PartnerInfo>
            <PartnerName>
              {match.partner_profile.email?.split('@')[0]}
            </PartnerName>
            <MatchDate>
              {new Date(match.created_at).toLocaleDateString()}
            </MatchDate>
          </PartnerInfo>
          <ScoreContainer>
            <ScoreText>
              {match.compatibility_details?.overall_compatibility || Math.round(match.compatibility_score * 100)}%
            </ScoreText>
            <ScoreLabel>Match</ScoreLabel>
          </ScoreContainer>
        </MatchHeader>

        <Separator />

        <YStack space="$2" marginTop="$4">
          <DetailRow>
            <Ionicons name="calendar" size={16} color="#FF4B6E" />
            <DetailText>Match</DetailText>
          </DetailRow>
          <DetailRow>
            <Ionicons name="location" size={16} color="#FF4B6E" />
            <DetailText>
              {match.partner_profile.location?.name || 'Location not specified'}
            </DetailText>
          </DetailRow>
        </YStack>

        {isExpanded && renderCompatibilityDetails(match)}

        <ToggleButton onPress={() => toggleMatchDetails(match.id)}>
          {isExpanded ? 'Hide Details' : 'Show Compatibility Details'}
        </ToggleButton>

        {isPending ? (
          <ActionButtons>
            <Button
              onPress={() => handleRejectMatch(match.id)}
              variant="outlined"
              borderColor="$red10"
              backgroundColor="transparent"
              color="$red10"
              flex={1}
              fontFamily="$body"
            >
              Reject
            </Button>
            <Button
              onPress={() => handleAcceptMatch(match.id)}
              backgroundColor="$primary"
              color="white"
              flex={1}
              fontFamily="$body"
            >
              Accept
            </Button>
          </ActionButtons>
        ) : (
          <Button
            onPress={() => {
              navigation.navigate('Main', { 
                screen: 'Messages',
                params: {
                  screen: 'Chat',
                  params: {
                    userId: match.partner_profile.id || '',
                    name: match.partner_profile.email?.split('@')[0] || 'Match'
                  }
                }
              });
            }}
            backgroundColor="$primary"
            color="white"
            marginTop="$4"
            fontFamily="$body"
            space="$2"
          >
            Chat
            <Ionicons name="chatbubble" size={20} color="white" />
          </Button>
        )}
      </MatchCard>
    );
  };

  if (loading) {
    return (
      <LoadingContainer>
        <LoadingText>Loading...</LoadingText>
      </LoadingContainer>
    );
  }

  return (
    <MainContainer>
      <Header>
        <HeaderTitle>Matches</HeaderTitle>
      </Header>

      <YStack flex={1}>
        {error ? (
          <ErrorContainer>
            <ErrorText>{error}</ErrorText>
            <Button
              onPress={refresh}
              backgroundColor="$primary"
              color="white"
              size="$4"
              fontFamily="$body"
            >
              Retry
            </Button>
          </ErrorContainer>
        ) : (
          <>
            {pendingMatches.length > 0 && (
              <Section>
                <SectionTitle>
                  Pending Matches ({pendingMatches.length})
                </SectionTitle>
                {pendingMatches.map(match => renderMatchCard(match, true))}
              </Section>
            )}

            <Section flex={1}>
              <SectionTitle>
                Active Matches ({activeMatches.length})
              </SectionTitle>
              {activeMatches.length > 0 ? (
                <>
                  {activeMatches.map(match => renderMatchCard(match))}
                  
                  {hasMore && (
                    <Button
                      onPress={loadMore}
                      backgroundColor="transparent"
                      color="$primary"
                      marginTop="$4"
                      disabled={loading}
                      fontFamily="$body"
                    >
                      {loading ? 'Loading...' : 'Load More Matches'}
                    </Button>
                  )}
                </>
              ) : (
                <EmptyState>
                  <Ionicons name="people" size={48} color="#FF4B6E" />
                  <EmptyStateText>
                    No active matches yet.{'\n'}
                    Create a date preference to start matching!
                  </EmptyStateText>
                </EmptyState>
              )}
            </Section>
          </>
        )}
      </YStack>
    </MainContainer>
  );
}
