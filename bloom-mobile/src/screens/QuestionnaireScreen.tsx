import React, { useState } from 'react';
import { Alert, Platform } from 'react-native';
import {
  YStack,
  XStack,
  Text,
  Button,
  Input,
  Card,
  H4,
  Progress,
  styled,
  Stack,
  Theme,
  ScrollView,
} from 'tamagui';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { RootStackParamList } from '../types/navigation';
import { supabase } from '../lib/supabase';
import DateTimePicker from '@react-native-community/datetimepicker';
import Slider from '@react-native-community/slider';

// Styled components for the questionnaire
const MainContainer = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
  padding: '$2',
});

const ProgressIndicator = styled(Progress, {
  height: 6,
  backgroundColor: '$backgroundHover',
  marginVertical: '$2',
});

const ContentCard = styled(Card, {
  flex: 1,
  backgroundColor: '$backgroundStrong',
  padding: '$4',
});

const QuestionContainer = styled(YStack, {
  flex: 1,
  padding: '$2',
  space: '$4',
});

const QuestionTitle = styled(H4, {
  textAlign: 'center',
  color: '$text',
  marginBottom: '$4',
  fontFamily: '$heading',
});

const OptionsContainer = styled(YStack, {
  space: '$2',
  paddingVertical: '$2',
});

const QuestionButton = styled(Button, {
  backgroundColor: 'transparent',
  borderWidth: 1,
  borderColor: '$primary',
  borderRadius: '$4',
  paddingVertical: '$3',
  marginVertical: '$1',
  
  variants: {
    selected: {
      true: {
        backgroundColor: '$primary',
        color: 'white',
      },
    },
  },
  pressStyle: {
    opacity: 0.8,
  },
});

const QuestionInput = styled(Input, {
  borderWidth: 1,
  borderColor: '$borderColor',
  borderRadius: '$4',
  padding: '$3',
  backgroundColor: '$backgroundStrong',
  color: '$text',
});

const RatingContainer = styled(YStack, {
  paddingVertical: '$2',
});

const RatingLabel = styled(Text, {
  marginBottom: '$2',
  color: '$text',
  fontFamily: '$body',
});

const ButtonContainer = styled(XStack, {
  justifyContent: 'space-between',
  paddingTop: '$4',
  paddingHorizontal: '$2',
});

const ActionButton = styled(Button, {
  minWidth: 120,
  backgroundColor: '$primary',
  borderRadius: '$4',
  color: 'white',
  
  variants: {
    secondary: {
      true: {
        backgroundColor: 'transparent',
        borderWidth: 1,
        borderColor: '$primary',
        color: '$primary',
      },
    },
  },
  pressStyle: {
    opacity: 0.8,
  },
});

// Web-compatible slider component
const WebSlider = ({ value, onValueChange, minimumValue = 0, maximumValue = 1, ...props }: any) => {
  if (Platform.OS === 'web') {
    return (
      <input
        type="range"
        min={minimumValue * 100}
        max={maximumValue * 100}
        value={value * 100}
        onChange={(e) => onValueChange(Number(e.target.value) / 100)}
        style={{ width: '100%', height: 40 }}
        {...props}
      />
    );
  }
  return <Slider value={value} onValueChange={onValueChange} {...props} />;
};

interface QuestionnaireData {
  location_city: string;
  dinner_location: string;
  birth_date: string;
  country: string;
  industry: string;
  has_children: string;
  relationship_status: string;
  gender_identity: string;
  personality_ratings: {
    stressed: number;
    creative: number;
    self_motivated: number;
    introvert: number;
    politically_incorrect: number;
    amazing_job: number;
    politics_news: number;
  };
  lifestyle_ratings: {
    nature_vs_city: number;
    academic_success: number;
    workout: number;
    social_life: number;
    loneliness: number;
  };
  values_ratings: {
    humor: number;
    spirituality: number;
    family: number;
  };
  decision_making: string;
  social_behavior: string;
  conflict_handling: string;
  life_goals: string;
  relationship_role: string;
  free_time: string;
  self_investment: string;
  commitment_approach: string;
  relationship_value: string;
  care_expression: string;
  ideal_lifestyle: string;
  difficult_situations: string;
  personal_growth: string;
  dating_approach: string;
  commitment_preference: string;
  communication_style: string;
  relationship_values: string;
  relationship_roles: string;
  relationship_offering: string;
  partner_expectations: string;
  partner_evaluation: string;
  problem_solving: string;
  future_planning: string;
  boundary_approach: string;
  relationship_success: string;
}

const CITIES = [
  'Albuquerque', 'Atlanta', 'Austin', 'Baltimore', 'Boston', 'Buffalo'
];

const DINNER_LOCATIONS = [
  'South Korea 🇰🇷', 'Spain 🇪🇸', 'Sweden 🇸🇪', 'Switzerland 🇨🇭',
  'Taiwan 🇹🇼', 'Thailand 🇹🇭', 'Turkey 🇹🇷', 'United Arab Emirates 🇦🇪',
  'United States 🇺🇸', 'Uruguay 🇺🇾'
];

const INDUSTRIES = [
  'Not working', 'Healthcare', 'Technology', 'Manual labor', 'Retail'
];

const RELATIONSHIP_STATUSES = [
  'Single', 'Married', 'It\'s complicated', 'In a relationship', 'I\'d prefer not to say'
];

const GENDER_IDENTITIES = [
  'Woman', 'Man', 'Non-binary'
];

type QuestionnaireScreenProps = {
  navigation: NativeStackNavigationProp<RootStackParamList, 'Auth'>;
};

export default function QuestionnaireScreen({ navigation }: QuestionnaireScreenProps) {
  const [currentStep, setCurrentStep] = useState(0);
  const [showDatePicker, setShowDatePicker] = useState(false);
  const [formData, setFormData] = useState<QuestionnaireData>({
    location_city: '',
    dinner_location: '',
    birth_date: new Date().toISOString(),
    country: '',
    industry: '',
    has_children: '',
    relationship_status: '',
    gender_identity: '',
    personality_ratings: {
      stressed: 5,
      creative: 5,
      self_motivated: 5,
      introvert: 5,
      politically_incorrect: 5,
      amazing_job: 5,
      politics_news: 5,
    },
    lifestyle_ratings: {
      nature_vs_city: 5,
      academic_success: 5,
      workout: 5,
      social_life: 5,
      loneliness: 5,
    },
    values_ratings: {
      humor: 5,
      spirituality: 5,
      family: 5,
    },
    decision_making: '',
    social_behavior: '',
    conflict_handling: '',
    life_goals: '',
    relationship_role: '',
    free_time: '',
    self_investment: '',
    commitment_approach: '',
    relationship_value: '',
    care_expression: '',
    ideal_lifestyle: '',
    difficult_situations: '',
    personal_growth: '',
    dating_approach: '',
    commitment_preference: '',
    communication_style: '',
    relationship_values: '',
    relationship_roles: '',
    relationship_offering: '',
    partner_expectations: '',
    partner_evaluation: '',
    problem_solving: '',
    future_planning: '',
    boundary_approach: '',
    relationship_success: '',
  });

  const handleNext = () => {
    if (currentStep < totalSteps - 1) {
      setCurrentStep(currentStep + 1);
    } else {
      handleSubmit();
    }
  };

  const handleBack = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1);
    }
  };

  const handleSubmit = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error('No user found');

      const { error } = await supabase
        .from('profiles')
        .upsert({
          id: user.id,
          ...formData,
          questionnaire_completed: true,
        });

      if (error) throw error;
      navigation.replace('MainTabs', { screen: 'Matches' });
    } catch (error) {
      Alert.alert('Error', (error as Error).message);
    }
  };

  const updateFormData = (key: keyof QuestionnaireData, value: any) => {
    setFormData(prev => ({
      ...prev,
      [key]: value,
    }));
  };

  const renderLocationStep = () => (
    <QuestionContainer>
      <QuestionTitle>Select your preferred city:</QuestionTitle>
      <ScrollView>
        <OptionsContainer>
          {CITIES.map((city) => (
            <QuestionButton
              key={city}
              selected={formData.location_city === city}
              onPress={() => updateFormData('location_city', city)}
            >
              {city}
            </QuestionButton>
          ))}
        </OptionsContainer>
      </ScrollView>
    </QuestionContainer>
  );

  const renderDinnerLocationStep = () => (
    <QuestionContainer>
      <QuestionTitle>Select your preferred dinner location:</QuestionTitle>
      <ScrollView>
        <OptionsContainer>
          {DINNER_LOCATIONS.map((location) => (
            <QuestionButton
              key={location}
              selected={formData.dinner_location === location}
              onPress={() => updateFormData('dinner_location', location)}
            >
              {location}
            </QuestionButton>
          ))}
        </OptionsContainer>
      </ScrollView>
    </QuestionContainer>
  );

  const renderBirthDateStep = () => (
    <QuestionContainer>
      <QuestionTitle>When is your birthday?</QuestionTitle>
      <QuestionButton
        onPress={() => setShowDatePicker(true)}
      >
        {new Date(formData.birth_date).toLocaleDateString()}
      </QuestionButton>
      {showDatePicker && (
        <DateTimePicker
          value={new Date(formData.birth_date)}
          mode="date"
          display="default"
          onChange={(event, selectedDate) => {
            setShowDatePicker(false);
            if (selectedDate) {
              updateFormData('birth_date', selectedDate.toISOString());
            }
          }}
        />
      )}
    </QuestionContainer>
  );

  const renderCountryStep = () => (
    <QuestionContainer>
      <QuestionTitle>What country are you from?</QuestionTitle>
      <QuestionInput
        value={formData.country}
        onChangeText={(text) => updateFormData('country', text)}
        placeholder="Enter your country"
      />
    </QuestionContainer>
  );

  const renderIndustryStep = () => (
    <QuestionContainer>
      <QuestionTitle>What industry do you work in?</QuestionTitle>
      <OptionsContainer>
        {INDUSTRIES.map((industry) => (
          <QuestionButton
            key={industry}
            selected={formData.industry === industry}
            onPress={() => updateFormData('industry', industry)}
          >
            {industry}
          </QuestionButton>
        ))}
      </OptionsContainer>
    </QuestionContainer>
  );

  const renderChildrenStep = () => (
    <QuestionContainer>
      <QuestionTitle>Do you have children?</QuestionTitle>
      <OptionsContainer>
        {['Yes', 'No', 'I\'d prefer not to say'].map((option) => (
          <QuestionButton
            key={option}
            selected={formData.has_children === option}
            onPress={() => updateFormData('has_children', option)}
          >
            {option}
          </QuestionButton>
        ))}
      </OptionsContainer>
    </QuestionContainer>
  );

  const renderRelationshipStatusStep = () => (
    <QuestionContainer>
      <QuestionTitle>What is your relationship status?</QuestionTitle>
      <OptionsContainer>
        {RELATIONSHIP_STATUSES.map((status) => (
          <QuestionButton
            key={status}
            selected={formData.relationship_status === status}
            onPress={() => updateFormData('relationship_status', status)}
          >
            {status}
          </QuestionButton>
        ))}
      </OptionsContainer>
    </QuestionContainer>
  );

  const renderGenderIdentityStep = () => (
    <QuestionContainer>
      <QuestionTitle>How do you define yourself?</QuestionTitle>
      <OptionsContainer>
        {GENDER_IDENTITIES.map((identity) => (
          <QuestionButton
            key={identity}
            selected={formData.gender_identity === identity}
            onPress={() => updateFormData('gender_identity', identity)}
          >
            {identity}
          </QuestionButton>
        ))}
      </OptionsContainer>
    </QuestionContainer>
  );

  const renderPersonalityRatingsStep = () => (
    <QuestionContainer>
      <QuestionTitle>Rate each statement (1-10):</QuestionTitle>
      <ScrollView>
        <RatingContainer>
          {Object.entries(formData.personality_ratings).map(([key, value]) => (
            <YStack key={key} space="$2">
              <RatingLabel>
                I am a {key.toUpperCase()} person: {value}
              </RatingLabel>
              <WebSlider
                minimumValue={1}
                maximumValue={10}
                step={1}
                value={value}
                onValueChange={(newValue: number) =>
                  setFormData(prev => ({
                    ...prev,
                    personality_ratings: {
                      ...prev.personality_ratings,
                      [key]: newValue,
                    },
                  }))
                }
                minimumTrackTintColor="#FF4B6E"
                maximumTrackTintColor="#000000"
              />
            </YStack>
          ))}
        </RatingContainer>
      </ScrollView>
    </QuestionContainer>
  );

  const renderLifestyleRatingsStep = () => (
    <QuestionContainer>
      <QuestionTitle>Rate your preferences (1-10):</QuestionTitle>
      <ScrollView>
        <RatingContainer>
          {Object.entries(formData.lifestyle_ratings).map(([key, value]) => (
            <YStack key={key} space="$2">
              <RatingLabel>
                {key.replace(/_/g, ' ').toUpperCase()}: {value}
              </RatingLabel>
              <WebSlider
                minimumValue={1}
                maximumValue={10}
                step={1}
                value={value}
                onValueChange={(newValue: number) =>
                  setFormData(prev => ({
                    ...prev,
                    lifestyle_ratings: {
                      ...prev.lifestyle_ratings,
                      [key]: newValue,
                    },
                  }))
                }
                minimumTrackTintColor="#FF4B6E"
                maximumTrackTintColor="#000000"
              />
            </YStack>
          ))}
        </RatingContainer>
      </ScrollView>
    </QuestionContainer>
  );

  const renderValuesRatingsStep = () => (
    <QuestionContainer>
      <QuestionTitle>Rate the importance (1-10):</QuestionTitle>
      <ScrollView>
        <RatingContainer>
          {Object.entries(formData.values_ratings).map(([key, value]) => (
            <YStack key={key} space="$2">
              <RatingLabel>
                {key.toUpperCase()}: {value}
              </RatingLabel>
              <WebSlider
                minimumValue={1}
                maximumValue={10}
                step={1}
                value={value}
                onValueChange={(newValue: number) =>
                  setFormData(prev => ({
                    ...prev,
                    values_ratings: {
                      ...prev.values_ratings,
                      [key]: newValue,
                    },
                  }))
                }
                minimumTrackTintColor="#FF4B6E"
                maximumTrackTintColor="#000000"
              />
            </YStack>
          ))}
        </RatingContainer>
      </ScrollView>
    </QuestionContainer>
  );

  const renderQuestionStep = (key: keyof QuestionnaireData, question: string, options: string[]) => (
    <QuestionContainer>
      <QuestionTitle>{question}</QuestionTitle>
      <ScrollView>
        <OptionsContainer>
          {options.map((option) => (
            <QuestionButton
              key={option}
              selected={formData[key] === option}
              onPress={() => updateFormData(key, option)}
            >
              {option}
            </QuestionButton>
          ))}
        </OptionsContainer>
      </ScrollView>
    </QuestionContainer>
  );

  const totalSteps = 36;
  const progress = (currentStep + 1) / totalSteps;

  const steps = [
    renderLocationStep,
    renderDinnerLocationStep,
    renderBirthDateStep,
    renderCountryStep,
    renderIndustryStep,
    renderChildrenStep,
    renderRelationshipStatusStep,
    renderGenderIdentityStep,
    renderPersonalityRatingsStep,
    renderLifestyleRatingsStep,
    renderValuesRatingsStep,
    () => renderQuestionStep('decision_making', 'When making important life decisions, do you tend to:', [
      'Carefully analyze all options before deciding',
      'Go with your gut feeling',
      'Seek advice from others first',
      'Wait until you\'re forced to decide'
    ]),
    () => renderQuestionStep('social_behavior', 'In social situations, do you typically:', [
      'Take charge and organize activities',
      'Go along with what others want to do',
      'Observe and participate selectively',
      'Feel uncomfortable and withdraw'
    ]),
    () => renderQuestionStep('conflict_handling', 'How do you prefer to handle conflict?', [
      'Address issues directly and immediately',
      'Try to maintain harmony and compromise',
      'Take time to process before responding',
      'Avoid confrontation whenever possible'
    ]),
    () => renderQuestionStep('life_goals', 'When it comes to life goals, which best describes you?', [
      'I have a clear mission and detailed plans',
      'I have general goals but remain flexible',
      'I prefer to take life as it comes',
      'I\'m still figuring out what I want'
    ]),
    () => renderQuestionStep('relationship_role', 'In relationships, which best describes your natural role?', [
      'I prefer to lead and set the course',
      'I prefer to follow someone with a clear direction',
      'I work to maintain an equal partnership',
      'I haven\'t found my preferred role yet'
    ]),
    () => renderQuestionStep('free_time', 'How do you typically spend your free time?', [
      'Working on personal development/career',
      'Socializing with friends/family',
      'Pursuing hobbies/interests alone',
      'Relaxing/unwinding from obligations'
    ]),
    () => renderQuestionStep('self_investment', 'When investing in yourself, you prioritize:', [
      'Building wealth and status',
      'Improving physical attractiveness',
      'Developing relationship skills',
      'Expanding social networks and influence'
    ]),
    () => renderQuestionStep('commitment_approach', 'Your approach to commitment is:', [
      'Very selective and carefully considered',
      'Open to possibilities but cautious',
      'Eager to find lasting connection',
      'Prefer keeping options open'
    ]),
    () => renderQuestionStep('relationship_value', 'What do you most value receiving in relationships?', [
      'Resources and lifestyle opportunities',
      'Sexual and romantic attention',
      'Emotional support and connection',
      'Practical help and assistance'
    ]),
    () => renderQuestionStep('care_expression', 'How do you prefer to show care in relationships?', [
      'Through practical support and resources',
      'Through physical affection and intimacy',
      'Through emotional support and listening',
      'Through gifts and acts of service'
    ]),
    () => renderQuestionStep('ideal_lifestyle', 'Your ideal lifestyle involves:', [
      'Regular excitement and new experiences',
      'Stable routine with occasional variety',
      'Quiet predictability and security',
      'Complete freedom and independence'
    ]),
    () => renderQuestionStep('difficult_situations', 'In difficult situations, you typically:', [
      'Take charge and solve problems',
      'Seek support from others',
      'Adapt and go with the flow',
      'Remove yourself from the situation'
    ]),
    () => renderQuestionStep('personal_growth', 'How do you view personal growth?', [
      'Essential and actively pursued',
      'Important but naturally occurring',
      'Nice but not a priority',
      'Uncomfortable or unnecessary'
    ]),
    () => renderQuestionStep('dating_approach', 'Your approach to dating is:', [
      'I actively look to build my options',
      'I carefully select specific targets',
      'I wait for others to show interest',
      'I take opportunities as they arise'
    ]),
    () => renderQuestionStep('commitment_preference', 'Regarding relationship commitment, you:', [
      'Prefer to maintain optionality',
      'Commit when worth investing in',
      'Seek commitment early for security',
      'Let commitment develop organically'
    ]),
    () => renderQuestionStep('communication_style', 'Your communication style is typically:', [
      'Direct and straightforward',
      'Diplomatic and considerate',
      'Reserved and observant',
      'Expressive and emotional'
    ]),
    () => renderQuestionStep('relationship_values', 'In relationships, you value:', [
      'Independence and personal space',
      'Close connection and sharing',
      'Balance of togetherness and autonomy',
      'Clear boundaries and expectations'
    ]),
    () => renderQuestionStep('relationship_roles', 'Your view on relationship roles is:', [
      'Traditional and defined',
      'Modern and flexible',
      'Completely fluid',
      'Depends on the situation'
    ]),
    () => renderQuestionStep('relationship_offering', 'In relationships, you primarily offer:', [
      'Resources, status and lifestyle',
      'Beauty, affection and sexual interest',
      'Loyalty, support and caregiving',
      'Fun, excitement and novelty'
    ]),
    () => renderQuestionStep('partner_expectations', 'Your ideal partner would provide:', [
      'Financial security and lifestyle elevation',
      'Strong attraction and sexual chemistry',
      'Stability and emotional support',
      'Growth opportunities and excitement'
    ]),
    () => renderQuestionStep('partner_evaluation', 'When evaluating potential partners, you prioritize:', [
      'Their ability to provide what you want',
      'What you can offer them in return',
      'Natural chemistry and connection',
      'Shared values and compatibility'
    ]),
    () => renderQuestionStep('problem_solving', 'Your view on relationship problems is:', [
      'They should be solved efficiently',
      'They\'re opportunities for growth',
      'They\'re natural and inevitable',
      'They\'re signs of incompatibility'
    ]),
    () => renderQuestionStep('future_planning', 'When it comes to future planning, you:', [
      'Have clear goals and timelines',
      'Have general ideas but stay flexible',
      'Prefer to live in the present',
      'Avoid making long-term plans'
    ]),
    () => renderQuestionStep('boundary_approach', 'Regarding relationship boundaries, you:', [
      'Maintain strong boundaries',
      'Adjust based on exchange',
      'Keep flexible for connection',
      'Let boundaries develop naturally'
    ]),
    () => renderQuestionStep('relationship_success', 'A successful relationship to you means:', [
      'Both parties get good value',
      'Deep emotional connection and growth',
      'Security and stability long-term',
      'Freedom while maintaining connection'
    ])
  ];

  return (
    <MainContainer>
      <ProgressIndicator value={progress} />
      <ContentCard elevate>
        {steps[currentStep]()}
        <ButtonContainer>
          {currentStep > 0 && (
            <ActionButton
              secondary
              onPress={handleBack}
            >
              Back
            </ActionButton>
          )}
          <ActionButton
            onPress={handleNext}
          >
            {currentStep === totalSteps - 1 ? "Submit" : "Next"}
          </ActionButton>
        </ButtonContainer>
      </ContentCard>
    </MainContainer>
  );
}
