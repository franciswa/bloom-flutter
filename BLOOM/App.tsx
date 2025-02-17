import React, { useCallback } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { TamaguiProvider } from 'tamagui';
import config from './tamagui.config';
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import { HomeScreen } from './src/screens/HomeScreen';

const Stack = createNativeStackNavigator();

SplashScreen.preventAutoHideAsync();

export default function App() {
  const [loaded] = useFonts({
    Inter: require('@tamagui/font-inter/otf/Inter-Medium.otf'),
  });

  const onLayoutRootView = useCallback(async () => {
    if (loaded) {
      await SplashScreen.hideAsync();
    }
  }, [loaded]);

  if (!loaded) {
    return null;
  }

  return (
    <TamaguiProvider config={config}>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen 
            name="Home" 
            component={HomeScreen}
            options={{ title: 'BLOOM' }}
          />
        </Stack.Navigator>
      </NavigationContainer>
    </TamaguiProvider>
  );
}
