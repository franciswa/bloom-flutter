import React, { useState } from 'react';
import {
  YStack,
  XStack,
  Text,
  H1,
  H4,
  ScrollView,
  Circle,
  Button,
  Card,
  styled,
  Avatar,
  Input as TextInput,
} from 'tamagui';
import { Ionicons } from '@expo/vector-icons';
import { useProfile } from '../hooks/useProfile';
import NatalChart from '../components/NatalChart';
import { Alert } from 'react-native';

// Temporary user ID until we have auth
const TEMP_USER_ID = '1';

// Default natal chart data when none exists
const defaultNatalData = {
  signs: {
    sun: 'Leo',
    moon: 'Aries',
    ascendant: 'Scorpio',
    mercury: 'Cancer',
    venus: 'Virgo',
    mars: 'Gemini',
    jupiter: 'Scorpio',
    saturn: 'Pisces',
    uranus: 'Capricorn',
    neptune: 'Capricorn',
    pluto: 'Scorpio',
  },
  planets: {
    sun: { planet: 'SUN', house: 9 },
    moon: { planet: 'MOON', house: 6 },
    ascendant: { planet: 'ASCENDANT', house: 1 },
    mercury: { planet: 'MERCURY', house: 8 },
    venus: { planet: 'VENUS', house: 11 },
    mars: { planet: 'MARS', house: 8 },
    jupiter: { planet: 'JUPITER', house: 12 },
    saturn: { planet: 'SATURN', house: 4 },
    uranus: { planet: 'URANUS', house: 3 },
    neptune: { planet: 'NEPTUNE', house: 3 },
    pluto: { planet: 'PLUTO', house: 1 },
  },
};

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

const Content = styled(YStack, {
  flex: 1,
  padding: '$4',
  space: '$6',
});

const Section = styled(YStack, {
  space: '$4',
});

const SectionTitle = styled(H4, {
  color: '$text',
  fontFamily: '$heading',
});

const PhotosContainer = styled(XStack, {
  alignItems: 'center',
  space: '$4',
});

const AddPhotoButton = styled(Circle, {
  width: 100,
  height: 100,
  backgroundColor: '$backgroundHover',
  borderWidth: 1,
  borderColor: '$borderColor',
  borderStyle: 'dashed',
  justifyContent: 'center',
  alignItems: 'center',
});

const QuestionnaireCard = styled(Card, {
  backgroundColor: '$backgroundStrong',
  padding: '$4',
  space: '$4',
});

const AnswerGroup = styled(YStack, {
  space: '$2',
});

const QuestionText = styled(Text, {
  color: '$primary',
  fontSize: '$3',
  fontWeight: 'bold',
  fontFamily: '$body',
});

const AnswerText = styled(Text, {
  color: '$text',
  fontSize: '$4',
  lineHeight: 24,
  fontFamily: '$body',
});

const BirthInfoForm = styled(YStack, {
  space: '$4',
  padding: '$4',
  backgroundColor: '$backgroundStrong',
  borderRadius: '$4',
});

const Input = styled(TextInput, {
  backgroundColor: '$background',
  borderWidth: 1,
  borderColor: '$borderColor',
  borderRadius: '$2',
  padding: '$2',
  color: '$text',
});

export default function ProfileScreen() {
  const {
    profile,
    loading,
    error,
    uploadPhoto,
    updateNatalChart,
    updateQuestionnaireData
  } = useProfile(TEMP_USER_ID);

  const [showBirthForm, setShowBirthForm] = useState(false);
  const [birthDate, setBirthDate] = useState('');
  const [birthTime, setBirthTime] = useState('');
  const [latitude, setLatitude] = useState('');
  const [longitude, setLongitude] = useState('');

  const handlePhotoUpload = async () => {
    try {
      await uploadPhoto();
    } catch (err) {
      Alert.alert('Error', 'Failed to upload photo');
    }
  };

  const handleBirthInfoSubmit = async () => {
    try {
      await updateNatalChart({
        date: birthDate,
        time: birthTime,
        latitude: parseFloat(latitude),
        longitude: parseFloat(longitude)
      });
      setShowBirthForm(false);
    } catch (err) {
      Alert.alert('Error', 'Failed to update birth information');
    }
  };

  if (loading) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center">
        <Text>Loading...</Text>
      </YStack>
    );
  }

  if (error) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center">
        <Text color="$red10">{error}</Text>
      </YStack>
    );
  }

  return (
    <MainContainer>
      <Header>
        <HeaderTitle>Profile</HeaderTitle>
      </Header>

      <Content>
        {/* Photos Section */}
        <Section>
          <SectionTitle>Photos</SectionTitle>
          <PhotosContainer>
            {profile?.photos.map((photo) => (
              <Avatar
                key={photo.id}
                circular
                size="$10"
                backgroundColor="$backgroundHover"
              >
                <Avatar.Image source={{ uri: photo.url }} />
                <Avatar.Fallback backgroundColor="$backgroundHover">
                  <Ionicons name="person" size={40} color="$color" />
                </Avatar.Fallback>
              </Avatar>
            ))}
            {(!profile?.photos || profile.photos.length < 6) && (
              <AddPhotoButton onPress={handlePhotoUpload}>
                <Ionicons name="add" size={30} color="$primary" />
              </AddPhotoButton>
            )}
          </PhotosContainer>
        </Section>

        {/* Natal Chart Section */}
        <Section>
          <XStack justifyContent="space-between" alignItems="center">
            <SectionTitle>Natal Chart</SectionTitle>
            <Button
              size="$3"
              variant="outlined"
              onPress={() => setShowBirthForm(!showBirthForm)}
            >
              {showBirthForm ? 'Cancel' : 'Update'}
            </Button>
          </XStack>
          
          {showBirthForm ? (
            <BirthInfoForm>
              <Input
                placeholder="Birth Date (YYYY-MM-DD)"
                value={birthDate}
                onChangeText={setBirthDate}
              />
              <Input
                placeholder="Birth Time (HH:mm)"
                value={birthTime}
                onChangeText={setBirthTime}
              />
              <Input
                placeholder="Latitude"
                value={latitude}
                onChangeText={setLatitude}
                keyboardType="numeric"
              />
              <Input
                placeholder="Longitude"
                value={longitude}
                onChangeText={setLongitude}
                keyboardType="numeric"
              />
              <Button onPress={handleBirthInfoSubmit}>
                Save Birth Information
              </Button>
            </BirthInfoForm>
          ) : (
            <NatalChart data={profile?.natal_chart || defaultNatalData} />
          )}
        </Section>

        {/* Questionnaire Section */}
        <Section>
          <SectionTitle>Questionnaire Answers</SectionTitle>
          <QuestionnaireCard elevate>
            <AnswerGroup>
              <QuestionText>Personality Type</QuestionText>
              <AnswerText>
                {Object.entries(profile?.personality_ratings || {})
                  .map(([key, value]) => `${key.replace('_', ' ')}: ${value}`)
                  .join(', ')}
              </AnswerText>
            </AnswerGroup>
            <AnswerGroup>
              <QuestionText>Lifestyle</QuestionText>
              <AnswerText>
                {Object.entries(profile?.lifestyle_ratings || {})
                  .map(([key, value]) => `${key.replace('_', ' ')}: ${value}`)
                  .join(', ')}
              </AnswerText>
            </AnswerGroup>
            <AnswerGroup>
              <QuestionText>Values</QuestionText>
              <AnswerText>
                {Object.entries(profile?.values_ratings || {})
                  .map(([key, value]) => `${key.replace('_', ' ')}: ${value}`)
                  .join(', ')}
              </AnswerText>
            </AnswerGroup>
          </QuestionnaireCard>
        </Section>
      </Content>
    </MainContainer>
  );
}
