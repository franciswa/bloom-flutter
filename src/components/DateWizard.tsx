import React, { useState } from 'react';
import { Platform, Alert } from 'react-native';
import {
  YStack,
  XStack,
  Text,
  H4,
  Button,
  Card,
  styled,
  ScrollView,
  Stack,
} from 'tamagui';
import DateTimePicker from '@react-native-community/datetimepicker';
import { useDatePreferences } from '../hooks/useDatePreferences';
import { DateType } from '../types/database';

type Step = 'zodiac' | 'type' | 'calendar';

const zodiacSigns = [
  'Aries', 'Taurus', 'Gemini', 'Cancer',
  'Leo', 'Virgo', 'Libra', 'Scorpio',
  'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
];

const dateTypes: DateType[] = [
  'Dinner', 'Coffee', 'Drinks', 'Games/Arcade',
  'Picnic', 'Activity/Adventure', 'Other/Anything'
];

interface DateWizardProps {
  onComplete?: () => void;
}

const WizardContainer = styled(Card, {
  flex: 1,
  backgroundColor: '$backgroundStrong',
  borderRadius: '$4',
  padding: '$4',
});

const ProgressBar = styled(XStack, {
  alignItems: 'center',
  justifyContent: 'center',
  marginBottom: '$6',
});

const ProgressDot = styled(Stack, {
  width: 12,
  height: 12,
  borderRadius: 6,
  backgroundColor: '$borderColor',
  
  variants: {
    active: {
      true: {
        backgroundColor: '$primary',
      },
    },
  },
});

const ProgressLine = styled(Stack, {
  width: 40,
  height: 2,
  marginHorizontal: '$1',
  backgroundColor: '$borderColor',
  
  variants: {
    active: {
      true: {
        backgroundColor: '$primary',
      },
    },
  },
});

const StepTitle = styled(H4, {
  marginBottom: '$6',
  textAlign: 'center',
  color: '$text',
  fontFamily: '$heading',
});

const ZodiacGrid = styled(XStack, {
  flexWrap: 'wrap',
  justifyContent: 'space-between',
  paddingHorizontal: '$2',
});

const ZodiacButton = styled(Button, {
  width: '30%',
  aspectRatio: 1,
  borderRadius: '$4',
  justifyContent: 'center',
  alignItems: 'center',
  marginBottom: '$4',
  backgroundColor: '$backgroundHover',
  
  variants: {
    selected: {
      true: {
        backgroundColor: '$primary',
      },
    },
  },
  pressStyle: {
    opacity: 0.8,
  },
});

const ZodiacText = styled(Text, {
  fontSize: '$3',
  color: '$text',
  fontFamily: '$body',
  
  variants: {
    selected: {
      true: {
        color: 'white',
      },
    },
  },
});

const DateTypeButton = styled(Button, {
  borderRadius: '$4',
  padding: '$4',
  marginBottom: '$3',
  backgroundColor: '$backgroundHover',
  
  variants: {
    selected: {
      true: {
        backgroundColor: '$primary',
      },
    },
  },
  pressStyle: {
    opacity: 0.8,
  },
});

const DateTypeText = styled(Text, {
  fontSize: '$4',
  textAlign: 'center',
  color: '$text',
  fontFamily: '$body',
  
  variants: {
    selected: {
      true: {
        color: 'white',
      },
    },
  },
});

const DatePickerContainer = styled(YStack, {
  backgroundColor: '$backgroundHover',
  borderRadius: '$4',
  padding: '$4',
  marginBottom: '$6',
});

const NavigationButtons = styled(XStack, {
  justifyContent: 'space-between',
  marginTop: '$6',
});

export default function DateWizard({ onComplete }: DateWizardProps) {
  const { createDatePreference, canCreateNewDate } = useDatePreferences();
  const [currentStep, setCurrentStep] = useState<Step>('zodiac');
  const [selectedZodiac, setSelectedZodiac] = useState<string | null>(null);
  const [selectedDateType, setSelectedDateType] = useState<DateType | null>(null);
  const [selectedDate, setSelectedDate] = useState<Date>(new Date());
  const [showDatePicker, setShowDatePicker] = useState(Platform.OS === 'ios');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async () => {
    if (!selectedZodiac || !selectedDateType) {
      Alert.alert('Error', 'Please complete all steps before submitting');
      return;
    }

    if (!canCreateNewDate) {
      Alert.alert('Error', 'You have reached the maximum number of active dates');
      return;
    }

    setIsSubmitting(true);

    try {
      await createDatePreference({
        desired_zodiac: selectedZodiac,
        date_type: selectedDateType,
        preferred_date: selectedDate.toISOString().split('T')[0],
      });

      // Reset form
      setSelectedZodiac(null);
      setSelectedDateType(null);
      setSelectedDate(new Date());
      setCurrentStep('zodiac');

      // Notify parent component
      if (onComplete) {
        onComplete();
      }

      Alert.alert(
        'Success',
        'Your date preference has been created! We\'ll notify you when we find a match.',
        [{ text: 'OK' }]
      );
    } catch (error) {
      Alert.alert(
        'Error',
        'Failed to create date preference. Please try again.'
      );
    } finally {
      setIsSubmitting(false);
    }
  };

  const renderZodiacStep = () => (
    <YStack flex={1}>
      <StepTitle>Choose a Zodiac Sign</StepTitle>
      <ZodiacGrid>
        {zodiacSigns.map((sign) => (
          <ZodiacButton
            key={sign}
            selected={selectedZodiac === sign}
            onPress={() => setSelectedZodiac(sign)}
          >
            <ZodiacText selected={selectedZodiac === sign}>
              {sign}
            </ZodiacText>
          </ZodiacButton>
        ))}
      </ZodiacGrid>
      <Button
        onPress={() => setCurrentStep('type')}
        disabled={!selectedZodiac}
        backgroundColor="$primary"
        color="white"
        size="$4"
        fontFamily="$body"
        marginTop="$6"
        opacity={!selectedZodiac ? 0.5 : 1}
        pressStyle={{ opacity: 0.8 }}
      >
        Next
      </Button>
    </YStack>
  );

  const renderDateTypeStep = () => (
    <YStack flex={1}>
      <StepTitle>Choose Date Type</StepTitle>
      <ScrollView>
        {dateTypes.map((type) => (
          <DateTypeButton
            key={type}
            selected={selectedDateType === type}
            onPress={() => setSelectedDateType(type)}
          >
            <DateTypeText selected={selectedDateType === type}>
              {type}
            </DateTypeText>
          </DateTypeButton>
        ))}
      </ScrollView>
      <NavigationButtons>
        <Button
          onPress={() => setCurrentStep('zodiac')}
          backgroundColor="$backgroundHover"
          color="$text"
          size="$4"
          fontFamily="$body"
          pressStyle={{ opacity: 0.8 }}
          width={120}
        >
          Back
        </Button>
        <Button
          onPress={() => setCurrentStep('calendar')}
          disabled={!selectedDateType}
          backgroundColor="$primary"
          color="white"
          size="$4"
          fontFamily="$body"
          opacity={!selectedDateType ? 0.5 : 1}
          pressStyle={{ opacity: 0.8 }}
          width={120}
        >
          Next
        </Button>
      </NavigationButtons>
    </YStack>
  );

  const renderCalendarStep = () => (
    <YStack flex={1}>
      <StepTitle>Choose Date</StepTitle>
      <DatePickerContainer>
        {Platform.OS === 'android' && (
          <Button
            onPress={() => setShowDatePicker(true)}
            backgroundColor="$backgroundStrong"
            color="$text"
            size="$4"
            fontFamily="$body"
            marginBottom="$4"
          >
            {selectedDate.toLocaleDateString()}
          </Button>
        )}
        
        {(showDatePicker || Platform.OS === 'ios') && (
          <DateTimePicker
            value={selectedDate}
            mode="date"
            display={Platform.OS === 'ios' ? 'spinner' : 'default'}
            minimumDate={new Date()}
            maximumDate={new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)}
            onChange={(event, date) => {
              if (Platform.OS === 'android') {
                setShowDatePicker(false);
              }
              if (date) {
                setSelectedDate(date);
              }
            }}
            style={{ width: '100%', height: Platform.OS === 'ios' ? 200 : undefined }}
          />
        )}
      </DatePickerContainer>

      <NavigationButtons>
        <Button
          onPress={() => setCurrentStep('type')}
          backgroundColor="$backgroundHover"
          color="$text"
          size="$4"
          fontFamily="$body"
          pressStyle={{ opacity: 0.8 }}
          width={120}
        >
          Back
        </Button>
        <Button
          onPress={handleSubmit}
          disabled={isSubmitting}
          backgroundColor="$primary"
          color="white"
          size="$4"
          fontFamily="$body"
          pressStyle={{ opacity: 0.8 }}
          width={120}
        >
          {isSubmitting ? 'Submitting...' : 'Submit'}
        </Button>
      </NavigationButtons>
    </YStack>
  );

  return (
    <WizardContainer elevate>
      <ProgressBar>
        <ProgressDot active />
        <ProgressLine active={currentStep !== 'zodiac'} />
        <ProgressDot active={currentStep !== 'zodiac'} />
        <ProgressLine active={currentStep === 'calendar'} />
        <ProgressDot active={currentStep === 'calendar'} />
      </ProgressBar>

      {currentStep === 'zodiac' && renderZodiacStep()}
      {currentStep === 'type' && renderDateTypeStep()}
      {currentStep === 'calendar' && renderCalendarStep()}
    </WizardContainer>
  );
}
