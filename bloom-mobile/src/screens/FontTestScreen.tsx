import React from 'react';
import { H1, H2, Text, YStack } from 'tamagui';

export default function FontTestScreen() {
  return (
    <YStack
      flex={1}
      backgroundColor="$background"
      padding="$4"
      space="$4"
      alignItems="center"
      justifyContent="center"
    >
      <H1 fontFamily="$heading">Geist Font Header</H1>
      <H2 fontFamily="$heading">Another Geist Header</H2>
      <Text fontFamily="$body" fontSize="$5">
        This is Open Sauce One Medium body text
      </Text>
      <Text fontFamily="$body" fontSize="$4">
        Another Open Sauce One Medium text with different size
      </Text>
      <Text fontFamily="$body" fontSize="$3">
        Description text using Open Sauce One Medium
      </Text>
    </YStack>
  );
}
