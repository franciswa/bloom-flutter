import React, { useMemo } from 'react';
import { View } from 'react-native';
import { Svg } from 'react-native-svg';
import { GestureDetector } from 'react-native-gesture-handler';
import Animated, { useAnimatedStyle } from 'react-native-reanimated';
import { ChartData, Planet, PLANETS } from '../../types/chart';
import { ZodiacRing } from './ZodiacRing';
import { PlanetMarker } from './PlanetMarker';
import { AspectLine, AspectHighlight } from './AspectLine';
import { useChartInteractions } from '../../hooks/useChartInteractions';

interface NatalChartProps {
  data: ChartData;
  width: number;
  height: number;
  onPlanetSelect?: (planet: Planet | null) => void;
}

const AnimatedSvg = Animated.createAnimatedComponent(Svg);

export function NatalChart({
  data,
  width,
  height,
  onPlanetSelect,
}: NatalChartProps) {
  const centerX = width / 2;
  const centerY = height / 2;
  const radius = Math.min(width, height) * 0.45; // Leave space for labels

  const {
    selectedPlanet,
    scale,
    rotation,
    pan,
    planetHighlight,
    resetPlanetHighlight,
    resetTransforms,
    chartGestures,
  } = useChartInteractions(onPlanetSelect);

  // Calculate planet positions
  const planetPositions = useMemo(() => {
    return data.planets.map(planet => {
      const angle = (planet.longitude - 90) * (Math.PI / 180);
      const distance = radius * 0.8; // Place planets inside the zodiac ring
      return {
        x: centerX + distance * Math.cos(angle),
        y: centerY + distance * Math.sin(angle),
        ...planet,
      };
    });
  }, [data.planets, radius, centerX, centerY]);

  // Animation style for the chart container
  const chartStyle = useAnimatedStyle(() => ({
    transform: [
      { translateX: pan.value.x },
      { translateY: pan.value.y },
      { scale: scale.value },
      { rotate: `${rotation.value}rad` },
    ],
  }));

  // Handle planet selection
  const handlePlanetPress = (planet: Planet) => {
    if (selectedPlanet.value === planet) {
      resetPlanetHighlight();
    } else {
      planetHighlight(planet);
    }
  };

  return (
    <View style={{ width, height }}>
      <GestureDetector gesture={chartGestures}>
        <AnimatedSvg
          width={width}
          height={height}
          style={chartStyle}
        >
          {/* Zodiac ring */}
          <ZodiacRing
            radius={radius}
            centerX={centerX}
            centerY={centerY}
          />

          {/* Aspect lines */}
          {data.aspects.map((aspect, index) => {
            const start = planetPositions.find(p => p.planet === aspect.planet1);
            const end = planetPositions.find(p => p.planet === aspect.planet2);
            
            if (!start || !end) return null;

            const isHighlighted = selectedPlanet.value === aspect.planet1 ||
                                selectedPlanet.value === aspect.planet2;

            return isHighlighted ? (
              <AspectHighlight
                key={`aspect-${index}`}
                startX={start.x}
                startY={start.y}
                endX={end.x}
                endY={end.y}
                type={aspect.type}
                startColor={PLANETS[aspect.planet1].color}
                endColor={PLANETS[aspect.planet2].color}
              />
            ) : (
              <AspectLine
                key={`aspect-${index}`}
                startX={start.x}
                startY={start.y}
                endX={end.x}
                endY={end.y}
                type={aspect.type}
              />
            );
          })}

          {/* Planet markers */}
          {planetPositions.map((planet) => (
            <PlanetMarker
              key={planet.planet}
              planet={planet.planet}
              x={planet.x}
              y={planet.y}
              degree={planet.degree}
              isRetrograde={planet.speed < 0}
              isSelected={selectedPlanet.value === planet.planet}
              onPress={() => handlePlanetPress(planet.planet)}
            />
          ))}
        </AnimatedSvg>
      </GestureDetector>
    </View>
  );
}
