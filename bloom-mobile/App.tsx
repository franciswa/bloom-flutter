import React from 'react';
import { TamaguiProvider } from 'tamagui';
import { View, ActivityIndicator } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { useFonts } from 'expo-font';
import { SessionContextProvider } from '@supabase/auth-helpers-react';
import { supabase } from './src/lib/supabase';
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
    <SessionContextProvider supabaseClient={supabase}>
      <SafeAreaProvider>
        <TamaguiProvider config={config}>
          <RootNavigator />
        </TamaguiProvider>
      </SafeAreaProvider>
    </SessionContextProvider>
  );
}
