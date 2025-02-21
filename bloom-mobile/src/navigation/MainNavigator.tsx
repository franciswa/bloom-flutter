import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import MatchesScreen from '../screens/MatchesScreen';
import MessagesScreen from '../screens/MessagesScreen';
import ChatScreen from '../screens/ChatScreen';
import { NatalChartScreen } from '../screens/NatalChartScreen';
import NotificationsScreen from '../screens/NotificationsScreen';
import SettingsScreen from '../screens/SettingsScreen';
import { useProfile } from '../hooks/useProfile';
import { useAuth } from '../hooks/useAuth';
import { ChartData, Planet, ZodiacSign, AspectType } from '../types/chart';
import { MainTabParamList, MessagesStackParamList } from '../types/navigation';

const Tab = createBottomTabNavigator<MainTabParamList>();
const MessagesStackNavigator = createNativeStackNavigator<MessagesStackParamList>();

const MessagesStack = () => {
  return (
    <MessagesStackNavigator.Navigator>
      <MessagesStackNavigator.Screen
        name="MessagesList"
        component={MessagesScreen}
        options={{ headerShown: false }}
      />
      <MessagesStackNavigator.Screen
        name="Chat"
        component={ChatScreen}
        options={({ route }) => ({
          title: route.params.name,
        })}
      />
    </MessagesStackNavigator.Navigator>
  );
};

export function MainNavigator() {
  const { user } = useAuth();
  const { profile } = useProfile(user?.id || '');

  // Sample chart data - in production this would come from the profile
  const sampleChartData: ChartData = {
    planets: [
      {
        planet: 'sun' as Planet,
        sign: 'aries' as ZodiacSign,
        degree: 15,
        minute: 30,
        house: 1,
        speed: 0.98,
        longitude: 15.5,
        latitude: 0,
      },
      {
        planet: 'moon' as Planet,
        sign: 'leo' as ZodiacSign,
        degree: 25,
        minute: 45,
        house: 5,
        speed: 12.5,
        longitude: 145.75,
        latitude: 1.2,
      },
      {
        planet: 'venus' as Planet,
        sign: 'pisces' as ZodiacSign,
        degree: 10,
        minute: 20,
        house: 12,
        speed: 1.1,
        longitude: 340.33,
        latitude: -0.5,
      },
    ],
    houses: [
      {
        house: 1,
        sign: 'aries' as ZodiacSign,
        degree: 0,
        minute: 0,
        cusp: 0,
      },
      {
        house: 2,
        sign: 'taurus' as ZodiacSign,
        degree: 30,
        minute: 0,
        cusp: 30,
      },
      {
        house: 3,
        sign: 'gemini' as ZodiacSign,
        degree: 60,
        minute: 0,
        cusp: 60,
      },
    ],
    aspects: [
      {
        planet1: 'sun' as Planet,
        planet2: 'moon' as Planet,
        type: 'trine' as AspectType,
        orb: 2,
        exact: false,
        applying: true,
      },
      {
        planet1: 'sun' as Planet,
        planet2: 'venus' as Planet,
        type: 'square' as AspectType,
        orb: 3,
        exact: false,
        applying: false,
      },
    ],
    angles: {
      ascendant: 0,
      midheaven: 90,
      descendant: 180,
      imumCoeli: 270,
    },
  };

  return (
    <Tab.Navigator
      screenOptions={{
        tabBarActiveTintColor: '$secondary',
        tabBarInactiveTintColor: '$textSubtle',
        tabBarStyle: {
          backgroundColor: '$background',
          borderTopColor: '$borderColor',
        },
        headerStyle: {
          backgroundColor: '$background',
        },
        headerTintColor: '$text',
      }}
    >
      <Tab.Screen
        name="Matches"
        component={MatchesScreen}
        options={{
          title: 'Matches',
        }}
      />
      <Tab.Screen
        name="Messages"
        component={MessagesStack}
        options={{
          title: 'Messages',
          headerShown: false,
        }}
      />
      <Tab.Screen
        name="Chart"
        options={{
          title: 'Birth Chart',
        }}
      >
        {() => <NatalChartScreen data={sampleChartData} />}
      </Tab.Screen>
      <Tab.Screen
        name="Notifications"
        component={NotificationsScreen}
        options={{
          title: 'Notifications',
        }}
      />
      <Tab.Screen
        name="Settings"
        component={SettingsScreen}
        options={{
          title: 'Settings',
        }}
      />
    </Tab.Navigator>
  );
}
