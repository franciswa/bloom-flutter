import React from 'react';
import { YStack, Text, Stack, XStack, Button } from 'tamagui';
import { ZodiacSelector } from '../components/zodiac/ZodiacSelector';
import { ZodiacSign } from '../types/chart';
import { DateNightScreenProps } from '../types/navigation';

type Props = DateNightScreenProps<'DateNightZodiac'>;

export function DateNightScreen({ navigation }: Props) {
  const handleSelectSign = (sign: ZodiacSign) => {
    navigation.navigate('DateTypeSelection', { selectedSign: sign });
  };

  return (
    <YStack flex={1} padding="$4" space="$4" backgroundColor="$background">
      <XStack justifyContent="flex-end" padding="$2">
        <Button
          variant="outlined"
          backgroundColor="$info"
          size="$3"
          onPress={() => navigation.navigate('DatePreferences')}
        >
          View Preferences
        </Button>
      </XStack>
      <Stack alignItems="center" space="$4">
        <Text
          fontSize="$8"
          fontWeight="bold"
          textAlign="center"
          color="$text"
        >
          Choose Your Date's Sign
        </Text>
        <Text
          fontSize="$4"
          textAlign="center"
          color="$textSecondary"
        >
          Rotate the wheel to select the zodiac sign you'd like to match with
        </Text>
      </Stack>

      <Stack flex={1} justifyContent="center" alignItems="center">
        <ZodiacSelector onSelectSign={handleSelectSign} />
      </Stack>
    </YStack>
  );
}
