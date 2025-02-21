import React from 'react';
import { Path, Defs, LinearGradient, Stop } from 'react-native-svg';
import Animated, {
  useAnimatedProps,
  withTiming,
  useDerivedValue
} from 'react-native-reanimated';
import { AspectType, ASPECT_TYPES } from '../../types/chart';

interface AspectLineProps {
  startX: number;
  startY: number;
  endX: number;
  endY: number;
  type: AspectType;
  isHighlighted?: boolean;
  strokeWidth?: number;
}

const AnimatedPath = Animated.createAnimatedComponent(Path);

export function AspectLine({
  startX,
  startY,
  endX,
  endY,
  type,
  isHighlighted = false,
  strokeWidth = 1,
}: AspectLineProps) {
  const aspectStyle = ASPECT_TYPES[type];

  // Animation values
  const opacity = useDerivedValue(() => 
    withTiming(isHighlighted ? 1 : 0.6, {
      duration: 200,
    })
  );

  const pathLength = useDerivedValue(() => 
    withTiming(1, {
      duration: 1000,
    })
  );

  // Calculate path data
  const pathData = `M ${startX} ${startY} L ${endX} ${endY}`;

  // Animated props for Path component
  const animatedProps = useAnimatedProps(() => {
    const dashArray: number[] = (() => {
      switch (type) {
        case 'conjunction':
        case 'opposition':
          return [];
        case 'trine':
          return [8, 4];
        case 'square':
          return [4, 4];
        case 'sextile':
          return [2, 4];
        default:
          return [];
      }
    })();

    return {
      d: pathData,
      strokeDasharray: dashArray,
      strokeDashoffset: pathLength.value,
      opacity: opacity.value,
    };
  });

  return (
    <AnimatedPath
      animatedProps={animatedProps}
      stroke={aspectStyle.color}
      strokeWidth={strokeWidth * (isHighlighted ? 2 : 1)}
      fill="none"
    />
  );
}

// Helper component for aspect highlighting effect
export function AspectHighlight({
  startX,
  startY,
  endX,
  endY,
  type,
  startColor,
  endColor,
  strokeWidth = 2,
}: AspectLineProps & {
  startColor: string;
  endColor: string;
}) {
  const gradientId = `gradient-${startX}-${startY}-${endX}-${endY}`;
  const angle = Math.atan2(endY - startY, endX - startX) * 180 / Math.PI;
  
  return (
    <>
      <Defs>
        <LinearGradient
          id={gradientId}
          x1="0%"
          y1="0%"
          x2="100%"
          y2="0%"
          gradientUnits="userSpaceOnUse"
          gradientTransform={`rotate(${angle}, ${startX}, ${startY})`}
        >
          <Stop offset="0%" stopColor={startColor} />
          <Stop offset="100%" stopColor={endColor} />
        </LinearGradient>
      </Defs>
      <AspectLine
        startX={startX}
        startY={startY}
        endX={endX}
        endY={endY}
        type={type}
        isHighlighted={true}
        strokeWidth={strokeWidth}
      />
    </>
  );
}
