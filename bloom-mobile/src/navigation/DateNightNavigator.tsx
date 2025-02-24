import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { DateNightStackParamList } from '../types/navigation';
import { DateNightScreen } from '../screens/DateNightScreen';
import { DateTypeSelectionScreen } from '../screens/DateTypeSelectionScreen';
import { DatePreferencesScreen } from '../screens/DatePreferencesScreen';

const Stack = createNativeStackNavigator<DateNightStackParamList>();

export function DateNightNavigator() {
  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: true,
        headerLargeTitle: true,
        headerTransparent: true,
        headerBlurEffect: 'regular',
      }}
    >
      <Stack.Screen
        name="DateNightZodiac"
        component={DateNightScreen}
        options={{
          title: 'Date Night',
        }}
      />
      <Stack.Screen
        name="DateTypeSelection"
        component={DateTypeSelectionScreen}
        options={{
          title: 'Choose Date Type',
        }}
      />
      <Stack.Screen
        name="DatePreferences"
        component={DatePreferencesScreen}
        options={{
          title: 'Date Preferences',
        }}
      />
    </Stack.Navigator>
  );
}
