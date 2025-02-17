import React from 'react';
import { Alert } from 'react-native';
import {
  YStack,
  XStack,
  Text,
  H1,
  H4,
  Card,
  Button,
  ScrollView,
  styled,
} from 'tamagui';
import { Ionicons } from '@expo/vector-icons';
import DateWizard from '../components/DateWizard';
import { useDatePreferences } from '../hooks/useDatePreferences';

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

const SectionTitle = styled(H4, {
  color: '$text',
  marginBottom: '$4',
  fontFamily: '$heading',
});

const DateCard = styled(Card, {
  backgroundColor: '$backgroundStrong',
  marginBottom: '$3',
  padding: '$4',
});

const DateHeader = styled(XStack, {
  justifyContent: 'space-between',
  alignItems: 'center',
  marginBottom: '$3',
});

const ZodiacText = styled(Text, {
  fontSize: '$5',
  fontWeight: 'bold',
  color: '$text',
  fontFamily: '$body',
});

const StatusBadge = styled(Text, {
  fontSize: '$2',
  fontWeight: 'bold',
  paddingHorizontal: '$2',
  paddingVertical: '$1',
  borderRadius: '$2',
  overflow: 'hidden',
  
  variants: {
    status: {
      matched: {
        backgroundColor: '$primary',
        color: 'black',
      },
      pending: {
        backgroundColor: '$borderColor',
        color: '$primary',
      },
    },
  },
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

const MaxDatesMessage = styled(XStack, {
  margin: '$4',
  padding: '$4',
  backgroundColor: '$backgroundStrong',
  borderRadius: '$4',
  alignItems: 'center',
  space: '$3',
});

const MaxDatesText = styled(Text, {
  flex: 1,
  fontSize: '$3',
  lineHeight: 20,
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

export default function DateScreen() {
  const { activeDates, loading, error, canCreateNewDate, cancelDatePreference, refresh } = useDatePreferences();

  const handleCancelDate = async (dateId: string) => {
    Alert.alert(
      'Cancel Date Preference',
      'Are you sure you want to cancel this date preference?',
      [
        { text: 'No', style: 'cancel' },
        { 
          text: 'Yes',
          style: 'destructive',
          onPress: async () => {
            try {
              await cancelDatePreference(dateId);
              await refresh();
            } catch (err) {
              Alert.alert('Error', 'Failed to cancel date preference');
            }
          }
        }
      ]
    );
  };

  const renderActiveDates = () => (
    <YStack padding="$4">
      <SectionTitle>Active Dates ({activeDates.length}/3)</SectionTitle>
      {activeDates.map((date) => (
        <DateCard key={date.id} elevate>
          <DateHeader>
            <ZodiacText>{date.desired_zodiac}</ZodiacText>
            <StatusBadge status={date.status as 'matched' | 'pending'}>
              {date.status.toUpperCase()}
            </StatusBadge>
          </DateHeader>
          <YStack space="$2" marginBottom="$4">
            <DetailRow>
              <Ionicons name="calendar" size={16} color="$primary" />
              <DetailText>
                {new Date(date.preferred_date).toLocaleDateString()}
              </DetailText>
            </DetailRow>
            <DetailRow>
              <Ionicons name="pricetag" size={16} color="$primary" />
              <DetailText>{date.date_type}</DetailText>
            </DetailRow>
          </YStack>
          {date.status === 'pending' && (
            <Button
              onPress={() => handleCancelDate(date.id)}
              variant="outlined"
              borderColor="$red10"
              backgroundColor="transparent"
              color="$red10"
              size="$3"
              fontFamily="$body"
            >
              Cancel
            </Button>
          )}
        </DateCard>
      ))}
    </YStack>
  );

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
        <HeaderTitle>Date</HeaderTitle>
      </Header>

      {error ? (
        <ErrorContainer>
          <ErrorText>{error}</ErrorText>
          <Button
            onPress={refresh}
            backgroundColor="$primary"
            size="$4"
            fontFamily="$body"
          >
            Retry
          </Button>
        </ErrorContainer>
      ) : (
        <>
          {renderActiveDates()}

          {canCreateNewDate ? (
            <YStack padding="$4">
              <SectionTitle>Create New Date</SectionTitle>
              <DateWizard onComplete={refresh} />
            </YStack>
          ) : (
            <MaxDatesMessage>
              <Ionicons name="information-circle" size={24} color="$primary" />
              <MaxDatesText>
                You've reached the maximum number of active dates.
                Wait for matches or cancel existing dates to create new ones.
              </MaxDatesText>
            </MaxDatesMessage>
          )}
        </>
      )}
    </MainContainer>
  );
}
