import React from 'react';
import { G, Circle, Text as SvgText } from 'react-native-svg';
import Animated, {
  useAnimatedProps,
  withSpring,
  interpolate,
  useDerivedValue
} from 'react-native-reanimated';
import { Planet, PLANETS } from '../../types/chart';

interface PlanetMarkerProps {
  planet: Planet;
  x: number;
  y: number;
  degree: number;
  isRetrograde?: boolean;
  isSelected?: boolean;
  onPress?: () => void;
  fontSize?: number;
}

const AnimatedG = Animated.createAnimatedComponent(G);
const AnimatedCircle = Animated.createAnimatedComponent(Circle);
const AnimatedText = Animated.createAnimatedComponent(SvgText);

export function PlanetMarker({
  planet,
  x,
  y,
  degree,
  isRetrograde = false,
  isSelected = false,
  onPress,
  fontSize = 14,
}: PlanetMarkerProps) {
  const planetData = PLANETS[planet];
  const circleRadius = fontSize * 0.8;

  // Animation values
  const scale = useDerivedValue(() => 
    withSpring(isSelected ? 1.2 : 1, {
      damping: 15,
      stiffness: 90
    })
  );

  const opacity = useDerivedValue(() => 
    withSpring(isSelected ? 0.2 : 0.1, {
      damping: 15,
      stiffness: 90
    })
  );

  // Animated props for G component
  const gAnimatedProps = useAnimatedProps(() => ({
    transform: [{ scale: scale.value }],
    origin: `${x}, ${y}`,
  }));

  // Animated props for Circle component
  const circleAnimatedProps = useAnimatedProps(() => ({
    opacity: opacity.value,
    cx: x,
    cy: y,
    r: circleRadius,
    fill: planetData.color,
  }));

  return (
    <AnimatedG
      animatedProps={gAnimatedProps}
      onPress={onPress}
    >
      {/* Background circle */}
      <AnimatedCircle
        animatedProps={circleAnimatedProps}
      />
      
      {/* Planet symbol */}
      <SvgText
        x={x}
        y={y}
        fontSize={fontSize}
        fontFamily="$astrological"
        textAnchor="middle"
        alignmentBaseline="middle"
        fill={planetData.color}
      >
        {planetData.symbol}
      </SvgText>

      {/* Degree text */}
      <SvgText
        x={x}
        y={y + fontSize * 1.2}
        fontSize={fontSize * 0.7}
        fontFamily="$body"
        textAnchor="middle"
        alignmentBaseline="middle"
        fill="$textSecondary"
      >
        {`${Math.floor(degree)}°${isRetrograde ? '℞' : ''}`}
      </SvgText>

      {/* Planet label (shown when selected) */}
      {isSelected && (
        <SvgText
          x={x}
          y={y - fontSize * 1.5}
          fontSize={fontSize * 0.8}
          fontFamily="$body"
          textAnchor="middle"
          alignmentBaseline="middle"
          fill={planetData.color}
        >
          {planetData.label}
        </SvgText>
      )}
    </AnimatedG>
  );
}
