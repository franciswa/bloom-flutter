import React from 'react';
import { View, ScrollView } from 'react-native';
import { ChartData, Planet, PLANETS, ZODIAC_SIGNS, ASPECT_TYPES } from '../../types/chart';
import {
  YStack,
  XStack,
  Text,
  Card,
  Separator
} from 'tamagui';

interface TableViewProps {
  data: ChartData;
  onPlanetSelect?: (planet: Planet | null) => void;
  selectedPlanet?: Planet | null;
}

// Unicode symbols for aspects
const ASPECT_SYMBOLS = {
  conjunction: '☌',
  opposition: '☍',
  trine: '△',
  square: '□',
  sextile: '⚹',
} as const;

export function TableView({
  data,
  onPlanetSelect,
  selectedPlanet,
}: TableViewProps) {
  return (
    <ScrollView>
      <YStack padding="$4" space="$4">
        {/* Planet Positions */}
        <Card bordered>
          <YStack padding="$4" space="$2">
            <Text fontFamily="$heading" fontSize="$5" marginBottom="$2">
              Planetary Positions
            </Text>
            
            {data.planets.map((planet) => (
              <XStack
                key={planet.planet}
                justifyContent="space-between"
                alignItems="center"
                paddingVertical="$2"
                pressStyle={{ opacity: 0.7 }}
                onPress={() => onPlanetSelect?.(planet.planet)}
                backgroundColor={selectedPlanet === planet.planet ? '$backgroundHover' : undefined}
              >
                <XStack space="$2" alignItems="center" flex={1}>
                  <Text
                    fontSize="$4"
                    color={PLANETS[planet.planet].color}
                  >
                    {PLANETS[planet.planet].symbol}
                  </Text>
                  <Text flex={1}>{PLANETS[planet.planet].label}</Text>
                </XStack>
                
                <XStack space="$2" alignItems="center">
                  <Text
                    fontSize="$4"
                    color={PLANETS[planet.planet].color}
                  >
                    {ZODIAC_SIGNS[planet.sign].symbol}
                  </Text>
                  <Text>
                    {`${Math.floor(planet.degree)}°${Math.floor((planet.degree % 1) * 60)}'`}
                  </Text>
                  {planet.speed < 0 && (
                    <Text color="$textSubtle">℞</Text>
                  )}
                </XStack>

                <Text marginLeft="$2" color="$textSubtle">
                  {`House ${planet.house}`}
                </Text>
              </XStack>
            ))}
          </YStack>
        </Card>

        {/* Aspects Grid */}
        <Card bordered>
          <YStack padding="$4" space="$2">
            <Text fontFamily="$heading" fontSize="$5" marginBottom="$2">
              Aspects
            </Text>

            <ScrollView horizontal>
              <YStack>
                {/* Header row */}
                <XStack alignItems="center" height={40}>
                  <View style={{ width: 40 }} />
                  {data.planets.map((planet) => (
                    <XStack
                      key={planet.planet}
                      width={40}
                      height={40}
                      alignItems="center"
                      justifyContent="center"
                    >
                      <Text
                        fontSize="$3"
                        color={PLANETS[planet.planet].color}
                      >
                        {PLANETS[planet.planet].symbol}
                      </Text>
                    </XStack>
                  ))}
                </XStack>

                {/* Aspect grid */}
                {data.planets.map((planet1, i) => (
                  <XStack key={planet1.planet} alignItems="center" height={40}>
                    <XStack
                      width={40}
                      height={40}
                      alignItems="center"
                      justifyContent="center"
                    >
                      <Text
                        fontSize="$3"
                        color={PLANETS[planet1.planet].color}
                      >
                        {PLANETS[planet1.planet].symbol}
                      </Text>
                    </XStack>

                    {data.planets.map((planet2, j) => {
                      if (j >= i) return <View key={planet2.planet} style={{ width: 40, height: 40 }} />;

                      const aspect = data.aspects.find(
                        a => (a.planet1 === planet1.planet && a.planet2 === planet2.planet) ||
                            (a.planet1 === planet2.planet && a.planet2 === planet1.planet)
                      );

                      return (
                        <XStack
                          key={planet2.planet}
                          width={40}
                          height={40}
                          alignItems="center"
                          justifyContent="center"
                        >
                          {aspect && (
                            <Text
                              fontSize="$3"
                              color={ASPECT_TYPES[aspect.type].color}
                            >
                              {ASPECT_SYMBOLS[aspect.type]}
                            </Text>
                          )}
                        </XStack>
                      );
                    })}
                  </XStack>
                ))}
              </YStack>
            </ScrollView>
          </YStack>
        </Card>
      </YStack>
    </ScrollView>
  );
}
