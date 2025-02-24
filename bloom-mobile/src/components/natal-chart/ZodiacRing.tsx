import React from 'react';
import { G, Circle, Path, Text as SvgText } from 'react-native-svg';
import { ZODIAC_SIGNS } from '../../types/chart';

interface ZodiacRingProps {
  radius: number;
  centerX: number;
  centerY: number;
  strokeWidth?: number;
  fontSize?: number;
}

export function ZodiacRing({
  radius,
  centerX,
  centerY,
  strokeWidth = 2,
  fontSize = 14,
}: ZodiacRingProps) {
  // Calculate positions for zodiac signs and degree markers
  const calculatePosition = (degree: number, offset: number = 0) => {
    const rad = (degree - 90) * (Math.PI / 180);
    return {
      x: centerX + (radius - offset) * Math.cos(rad),
      y: centerY + (radius - offset) * Math.sin(rad),
    };
  };

  // Create degree markers (every 5 degrees)
  const degreeMarkers = Array.from({ length: 72 }, (_, i) => {
    const degree = i * 5;
    const isMainDegree = degree % 30 === 0;
    const markerLength = isMainDegree ? 10 : 5;
    const start = calculatePosition(degree);
    const end = calculatePosition(degree, markerLength);

    return (
      <Path
        key={`degree-${degree}`}
        d={`M ${start.x} ${start.y} L ${end.x} ${end.y}`}
        stroke="$borderColor"
        strokeWidth={isMainDegree ? strokeWidth : strokeWidth / 2}
      />
    );
  });

  // Create zodiac sign labels and symbols
  const zodiacLabels = Object.entries(ZODIAC_SIGNS).map(([sign, data]) => {
    const symbolPos = calculatePosition(data.degree + 15, -20); // Center in 30° segment
    const labelPos = calculatePosition(data.degree + 15, -40); // Outside the ring
    const rotation = data.degree + 15; // Align text with segment

    return (
      <G key={sign}>
        {/* Symbol */}
        <SvgText
          x={symbolPos.x}
          y={symbolPos.y}
          fontSize={fontSize * 1.2}
          fontFamily="$astrological"
          textAnchor="middle"
          alignmentBaseline="middle"
          fill="$text"
        >
          {data.symbol}
        </SvgText>

        {/* Label */}
        <SvgText
          x={labelPos.x}
          y={labelPos.y}
          fontSize={fontSize}
          fontFamily="$body"
          textAnchor="middle"
          alignmentBaseline="middle"
          fill="$textSecondary"
          transform={`rotate(${rotation}, ${labelPos.x}, ${labelPos.y})`}
        >
          {data.label}
        </SvgText>
      </G>
    );
  });

  // Create house cusps
  const houseCusps = Array.from({ length: 12 }, (_, i) => {
    const degree = i * 30;
    const start = calculatePosition(degree);
    const end = { x: centerX, y: centerY };

    return (
      <Path
        key={`house-${i + 1}`}
        d={`M ${start.x} ${start.y} L ${end.x} ${end.y}`}
        stroke="$borderColor"
        strokeWidth={strokeWidth / 2}
        strokeDasharray={[4, 4]}
      />
    );
  });

  return (
    <G>
      {/* Main circle */}
      <Circle
        cx={centerX}
        cy={centerY}
        r={radius}
        stroke="$borderColor"
        strokeWidth={strokeWidth}
        fill="none"
      />

      {/* Degree markers */}
      {degreeMarkers}

      {/* House cusps */}
      {houseCusps}

      {/* Zodiac signs */}
      {zodiacLabels}
    </G>
  );
}
