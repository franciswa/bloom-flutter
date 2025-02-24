import React from 'react';
import { StyleSheet } from 'react-native';
import { GestureDetector } from 'react-native-gesture-handler';
import Animated, { useAnimatedStyle } from 'react-native-reanimated';
import { Stack, Button, Text } from 'tamagui';
import { Svg } from 'react-native-svg';
import { ZodiacRing } from '../natal-chart/ZodiacRing';
import { useZodiacSelector } from '../../hooks/useZodiacSelector';
import { ZodiacSign, ZODIAC_SIGNS } from '../../types/chart';

interface ZodiacSelectorProps {
  onSelectSign: (sign: ZodiacSign) => void;
}

export function ZodiacSelector({ onSelectSign }: ZodiacSelectorProps) {
  const { rotation, selectedSign, rotationGesture, handleSelect } = useZodiacSelector(onSelectSign);

  // Animated rotation style
  const wheelStyle = useAnimatedStyle(() => ({
    transform: [{ rotate: `${rotation.value}rad` }],
  }));

  return (
    <Stack space="$4" alignItems="center">
      <GestureDetector gesture={rotationGesture}>
        <Animated.View style={[styles.wheel, wheelStyle]}>
          <Svg width={300} height={300}>
            <ZodiacRing
              radius={140}
              centerX={150}
              centerY={150}
              strokeWidth={2}
              fontSize={16}
            />
          </Svg>
        </Animated.View>
      </GestureDetector>

      <Stack space="$2" alignItems="center">
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
          color="$text"
        >
          {ZODIAC_SIGNS[selectedSign].label}
        </Text>
        <Button
          size="$5"
          backgroundColor="$info"
          onPress={handleSelect}
          pressStyle={{ scale: 0.97 }}
        >
          Select {ZODIAC_SIGNS[selectedSign].label}
        </Button>
      </Stack>
    </Stack>
  );
}

const styles = StyleSheet.create({
  wheel: {
    width: 300,
    height: 300,
  },
});
