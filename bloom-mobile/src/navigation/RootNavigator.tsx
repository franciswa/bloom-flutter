import React from 'react';
import { NavigationContainer, LinkingOptions } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { useAuth } from '../hooks/useAuth';
import AuthNavigator from './AuthNavigator';
import MainNavigator from './MainNavigator';
import { RootStackParamList } from '../types/navigation';

const Stack = createNativeStackNavigator<RootStackParamList>();

// Configure deep linking
const linking: LinkingOptions<RootStackParamList> = {
  prefixes: ['bloom://', 'https://bloom.app'],
  config: {
    screens: {
      Auth: {
        screens: {
          Welcome: 'welcome',
          SignIn: 'signin',
          SignUp: 'signup',
          ForgotPassword: 'forgot-password',
          ResetPassword: {
            path: 'reset-password/:token',
            parse: {
              token: (token: string) => token,
            },
          },
        },
      },
      MainTabs: {
        screens: {
          Matches: 'matches',
          Messages: 'messages',
          Dates: 'dates',
          Profile: 'profile',
          Settings: 'settings',
          Notifications: 'notifications',
        },
      },
      Chat: {
        path: 'chat/:matchId',
        parse: {
          matchId: (id: string) => id,
        },
      },
      Match: {
        path: 'match/:matchId',
        parse: {
          matchId: (id: string) => id,
        },
      },
      Date: {
        path: 'date/:matchId/:dateId?',
        parse: {
          matchId: (id: string) => id,
          dateId: (id: string) => id,
        },
      },
      Questionnaire: {
        path: 'questionnaire/:type',
        parse: {
          type: (type: string) => type as 'personality' | 'lifestyle' | 'values',
        },
      },
    },
  },
};

export default function RootNavigator() {
  const { user } = useAuth();

  return (
    <NavigationContainer linking={linking}>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {user ? (
          <>
            <Stack.Screen name="MainTabs" component={MainNavigator} />
            <Stack.Screen 
              name="Chat" 
              component={MainNavigator} 
              options={{ headerShown: true }}
            />
            <Stack.Screen 
              name="Match" 
              component={MainNavigator}
              options={{ headerShown: true }}
            />
            <Stack.Screen 
              name="Date" 
              component={MainNavigator}
              options={{ headerShown: true }}
            />
            <Stack.Screen 
              name="Questionnaire" 
              component={MainNavigator}
              options={{ headerShown: true }}
            />
          </>
        ) : (
          <Stack.Screen name="Auth" component={AuthNavigator} />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
