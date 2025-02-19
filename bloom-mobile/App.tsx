import React, { useEffect, useState } from 'react';
import { TamaguiProvider } from 'tamagui';
import { View, ActivityIndicator } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { useFonts } from 'expo-font';
import config from './tamagui.config';
import RootNavigator from './src/navigation/RootNavigator';

export default function App() {
  const [fontsLoaded] = useFonts({
    Inter: require('@tamagui/font-inter/otf/Inter-Medium.otf'),
    InterBold: require('@tamagui/font-inter/otf/Inter-Bold.otf'),
  });

  if (!fontsLoaded) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator size="large" color="#FF8FB1" />
      </View>
    );
  }

  return (
    <SafeAreaProvider>
      <TamaguiProvider config={config}>
        <RootNavigator />
      </TamaguiProvider>
    </SafeAreaProvider>
  );
}
