import React, { useEffect, useState } from 'react'
import { TamaguiProvider, useTheme } from 'tamagui'
import * as Font from 'expo-font'
import { View, ActivityIndicator } from 'react-native'
import config from './tamagui.config'
import { ThemeProvider } from './src/theme/ThemeProvider'
import { NavigationContainer } from '@react-navigation/native'
import { createNativeStackNavigator } from '@react-navigation/native-stack'
import { RootStackParamList } from './src/types/navigation'
import AuthScreen from './src/screens/AuthScreen'
import QuestionnaireScreen from './src/screens/QuestionnaireScreen'
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs'
import MatchScreen from './src/screens/MatchScreen'
import ChatScreen from './src/screens/ChatScreen'
import ProfileScreen from './src/screens/ProfileScreen'
import SettingsScreen from './src/screens/SettingsScreen'
import NotificationsScreen from './src/screens/NotificationsScreen'
import DateScreen from './src/screens/DateScreen'
import TabBarIcon from './src/components/TabBarIcon'
import { TabParamList } from './src/types/navigation'

const Stack = createNativeStackNavigator<RootStackParamList>()
const Tab = createBottomTabNavigator<TabParamList>()

function MainTabs() {
  const theme = useTheme()
  
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => (
          <TabBarIcon name={route.name} focused={focused} color={color} size={size} />
        ),
        tabBarActiveTintColor: theme?.primary?.val || '#FF8FB1',
        tabBarInactiveTintColor: theme?.gray10?.val || 'gray',
        tabBarStyle: {
          backgroundColor: theme?.background?.val || '#FFFFFF',
          borderTopColor: theme?.borderColor?.val || '#E5E5E5',
        },
      })}
    >
      <Tab.Screen name="Matches" component={MatchScreen} />
      <Tab.Screen name="Chat" component={ChatScreen} />
      <Tab.Screen name="Date" component={DateScreen} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
      <Tab.Screen name="Settings" component={SettingsScreen} />
    </Tab.Navigator>
  )
}

export default function App() {
  const [fontsLoaded, setFontsLoaded] = useState(false)

  useEffect(() => {
    async function loadFonts() {
      await Font.loadAsync({
        'Geist': require('./assets/fonts/Geist-VariableFont_wght.ttf'),
        'OpenSauceOne-Medium': require('./assets/fonts/OpenSauceOne-Medium.ttf'),
      })
      setFontsLoaded(true)
    }
    loadFonts()
  }, [])

  if (!fontsLoaded) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator size="large" color="#FF8FB1" />
      </View>
    )
  }

  return (
    <TamaguiProvider config={config} defaultTheme="light">
      <ThemeProvider>
        <NavigationContainer>
          <Stack.Navigator
            screenOptions={{
              headerShown: false,
              contentStyle: {
                backgroundColor: '$background',
              },
            }}
          >
            <Stack.Screen name="Auth" component={AuthScreen} />
            <Stack.Screen name="Questionnaire" component={QuestionnaireScreen} />
            <Stack.Screen name="MainTabs" component={MainTabs} />
            <Stack.Screen name="Notifications" component={NotificationsScreen} />
          </Stack.Navigator>
        </NavigationContainer>
      </ThemeProvider>
    </TamaguiProvider>
  )
}
