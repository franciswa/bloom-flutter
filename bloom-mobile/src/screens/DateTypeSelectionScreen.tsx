import React from 'react';
import { YStack, Text, Stack, Button, Spinner } from 'tamagui';
import { DateNightScreenProps } from '../types/navigation';
import { ZodiacSign, ZODIAC_SIGNS } from '../types/chart';
import { useDatePreferences } from '../hooks/useDatePreferences';
import { DateType } from '../services/datePreferences';
import DateTimePicker from '@react-native-community/datetimepicker';
import { Platform, View } from 'react-native';

type Props = DateNightScreenProps<'DateTypeSelection'>;

const DATE_TYPES = [
  'Dinner',
  'Coffee',
  'Drinks',
  'Games/Arcade',
  'Picnic',
  'Activity/Adventure',
  'Other/Anything',
] as const;

export function DateTypeSelectionScreen({ route, navigation }: Props) {
  const { selectedSign } = route.params;
  const [selectedType, setSelectedType] = React.useState<DateType | null>(null);
  const [selectedDate, setSelectedDate] = React.useState(new Date());
  const [showDatePicker, setShowDatePicker] = React.useState(false);
  const { createPreference, loading, error } = useDatePreferences();

  const handleSelect = async (type: DateType) => {
    setSelectedType(type);
    if (Platform.OS === 'ios') {
      setShowDatePicker(true);
    } else {
      // On Android, show date picker immediately
      setShowDatePicker(true);
    }
  };

  const handleDateChange = async (_: any, date?: Date) => {
    setShowDatePicker(false);
    if (date && selectedType) {
      try {
        await createPreference(selectedSign, selectedType, date);
        navigation.navigate('DateNightZodiac');
      } catch (err) {
        // Error is handled by the hook and shown in the UI
      }
    }
  };

  if (loading) {
    return (
      <YStack flex={1} padding="$4" justifyContent="center" alignItems="center" backgroundColor="$background">
        <Spinner size="large" color="$color" />
        <Text color="$textSecondary" marginTop="$4">Creating your date preference...</Text>
      </YStack>
    );
  }

  return (
    <YStack flex={1} padding="$4" space="$4" backgroundColor="$background">
      {error && (
        <Text color="$danger" textAlign="center">
          {error}
        </Text>
      )}
      <Stack alignItems="center" space="$4">
        <Text
          fontFamily="$astrological"
          fontSize="$8"
          color="$text"
        >
          {ZODIAC_SIGNS[selectedSign].symbol}
        </Text>
        <Text
          fontSize="$6"
          fontWeight="bold"
          textAlign="center"
          color="$text"
        >
          Choose Your Date Type
        </Text>
        <Text
          fontSize="$4"
          textAlign="center"
          color="$textSecondary"
        >
          What kind of date would you like to go on with your {ZODIAC_SIGNS[selectedSign].label}?
        </Text>
      </Stack>

      <YStack space="$3" paddingVertical="$4" flex={1}>
        {DATE_TYPES.map((type) => (
          <Button
            key={type}
            size="$5"
            backgroundColor={selectedType === type ? '$info' : '$background'}
            borderColor="$borderColor"
            borderWidth={1}
            pressStyle={{ scale: 0.97 }}
            onPress={() => handleSelect(type)}
          >
            {type}
          </Button>
        ))}
      </YStack>

      {showDatePicker && (
        <DateTimePicker
          value={selectedDate}
          mode="date"
          display={Platform.OS === 'ios' ? 'spinner' : 'default'}
          minimumDate={new Date()}
          onChange={handleDateChange}
        />
      )}
    </YStack>
  );
}
