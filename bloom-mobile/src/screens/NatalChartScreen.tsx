import React, { useState } from 'react';
import { View } from 'react-native';
import { YStack, Text } from 'tamagui';
import Animated from 'react-native-reanimated';
import { ChartData, Planet } from '../types/chart';
import { NatalChart } from '../components/natal-chart/NatalChart';
import { TableView } from '../components/natal-chart/TableView';
import { useChartView } from '../hooks/useChartViewTransition';
import { StyledButton } from '../theme/components';

interface NatalChartScreenProps {
  data: ChartData;
}

const AnimatedView = Animated.createAnimatedComponent(View);

export function NatalChartScreen({ data }: NatalChartScreenProps) {
  const [selectedPlanet, setSelectedPlanet] = useState<Planet | null>(null);
  const {
    currentView,
    wheelStyle,
    tableStyle,
    toggleView,
  } = useChartView('wheel');

  const handlePlanetSelect = (planet: Planet | null) => {
    setSelectedPlanet(planet);
  };

  return (
    <YStack flex={1} backgroundColor="$background">
      {/* Header */}
      <YStack
        padding="$4"
        space="$2"
        borderBottomWidth={1}
        borderBottomColor="$borderColor"
      >
        <Text fontFamily="$heading" fontSize="$6" textAlign="center">
          Birth Chart
        </Text>
        <StyledButton
          onPress={toggleView}
          variant="secondary"
          marginTop="$2"
        >
          {currentView === 'wheel' ? 'Switch to Table View' : 'Switch to Chart View'}
        </StyledButton>
      </YStack>

      {/* Chart Container */}
      <View style={{ flex: 1 }}>
        {/* Wheel View */}
        <AnimatedView
          style={[
            {
              position: 'absolute',
              width: '100%',
              height: '100%',
            },
            wheelStyle,
          ]}
        >
          <NatalChart
            data={data}
            width={400}
            height={400}
            onPlanetSelect={handlePlanetSelect}
          />
        </AnimatedView>

        {/* Table View */}
        <AnimatedView
          style={[
            {
              position: 'absolute',
              width: '100%',
              height: '100%',
            },
            tableStyle,
          ]}
        >
          <TableView
            data={data}
            selectedPlanet={selectedPlanet}
            onPlanetSelect={handlePlanetSelect}
          />
        </AnimatedView>
      </View>
    </YStack>
  );
}
