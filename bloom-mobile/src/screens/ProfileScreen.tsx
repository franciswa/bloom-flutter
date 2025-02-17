import React from 'react';
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
} from 'tamagui';
import { Ionicons } from '@expo/vector-icons';
import NatalChart from '../components/NatalChart';

// Sample natal chart data (we'll replace this with real data later)
const sampleNatalData = {
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

export default function ProfileScreen() {
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
            <Avatar
              circular
              size="$10"
              backgroundColor="$backgroundHover"
            >
              <Avatar.Image source={{ uri: undefined }} />
              <Avatar.Fallback backgroundColor="$backgroundHover">
                <Ionicons name="person" size={40} color="$color" />
              </Avatar.Fallback>
            </Avatar>
            <AddPhotoButton>
              <Ionicons name="add" size={30} color="$primary" />
            </AddPhotoButton>
          </PhotosContainer>
        </Section>

        {/* Natal Chart Section */}
        <Section>
          <SectionTitle>Natal Chart</SectionTitle>
          <NatalChart data={sampleNatalData} />
        </Section>

        {/* Questionnaire Section */}
        <Section>
          <SectionTitle>Questionnaire Answers</SectionTitle>
          <QuestionnaireCard elevate>
            <AnswerGroup>
              <QuestionText>Personality Type</QuestionText>
              <AnswerText>Adventurous, Creative, Analytical</AnswerText>
            </AnswerGroup>
            <AnswerGroup>
              <QuestionText>Lifestyle</QuestionText>
              <AnswerText>City Person, Fitness Enthusiast</AnswerText>
            </AnswerGroup>
            <AnswerGroup>
              <QuestionText>Values</QuestionText>
              <AnswerText>Growth, Authenticity, Balance</AnswerText>
            </AnswerGroup>
          </QuestionnaireCard>
        </Section>
      </Content>
    </MainContainer>
  );
}
