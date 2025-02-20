import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { View } from 'react-native';
import { Text, styled } from 'tamagui';
import ProfileScreen from '../screens/ProfileScreen';
import SettingsScreen from '../screens/SettingsScreen';
import NotificationsScreen from '../screens/NotificationsScreen';
import { useNotifications } from '../hooks/useNotifications';
import MatchesScreen from '../screens/MatchesScreen';
import MessagesScreen from '../screens/MessagesScreen';
import ChatScreen from '../screens/ChatScreen';
import DateScreen from '../screens/DateScreen';
import MatchScreen from '../screens/MatchScreen';
import QuestionnaireScreen from '../screens/QuestionnaireScreen';

// Separate types for Tab and Stack navigators
export type TabParamList = {
  Matches: undefined;
  Messages: undefined;
  Dates: undefined;
  Notifications: undefined;
  Profile: undefined;
  Settings: undefined;
};

export type RootStackParamList = {
  Tabs: undefined;
  Chat: {
    matchId: string;
    matchName: string;
    matchPhoto: string;
  };
  Match: {
    matchId: string;
  };
  Questionnaire: {
    type: 'personality' | 'lifestyle' | 'values';
  };
};

const Stack = createNativeStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator<TabParamList>();

const Badge = styled(View, {
  position: 'absolute',
  top: -2,
  right: -6,
  backgroundColor: '$secondary',
  borderRadius: 10,
  minWidth: 20,
  height: 20,
  justifyContent: 'center',
  alignItems: 'center',
});

const BadgeText = styled(Text, {
  color: '$text',
  fontSize: 12,
  fontWeight: 'bold',
});

function TabNavigator() {
  const { unreadCount } = useNotifications();
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName: keyof typeof Ionicons.glyphMap;

          switch (route.name) {
            case 'Matches':
              iconName = focused ? 'heart' : 'heart-outline';
              break;
            case 'Messages':
              iconName = focused ? 'chatbubbles' : 'chatbubbles-outline';
              break;
            case 'Dates':
              iconName = focused ? 'calendar' : 'calendar-outline';
              break;
            case 'Notifications':
              iconName = focused ? 'notifications' : 'notifications-outline';
              break;
            case 'Profile':
              iconName = focused ? 'person' : 'person-outline';
              break;
            case 'Settings':
              iconName = focused ? 'settings' : 'settings-outline';
              break;
            default:
              iconName = 'alert-circle';
          }

          const icon = <Ionicons name={iconName} size={size} color={color} />;

          // Add badge for notifications
          if (route.name === 'Notifications' && unreadCount > 0) {
            return (
              <View>
                {icon}
                <Badge>
                  <BadgeText>{unreadCount > 99 ? '99+' : unreadCount}</BadgeText>
                </Badge>
              </View>
            );
          }

          return icon;
        },
        tabBarActiveTintColor: '#BAF2BB',
        tabBarInactiveTintColor: 'gray',
      })}
    >
      <Tab.Screen name="Matches" component={MatchesScreen} />
      <Tab.Screen name="Messages" component={MessagesScreen} />
      <Tab.Screen name="Dates" component={DateScreen} />
      <Tab.Screen name="Notifications" component={NotificationsScreen} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
      <Tab.Screen name="Settings" component={SettingsScreen} />
    </Tab.Navigator>
  );
}

export default function MainNavigator() {
  return (
    <Stack.Navigator>
      <Stack.Screen
        name="Tabs"
        component={TabNavigator}
        options={{ headerShown: false }}
      />
      <Stack.Screen
        name="Chat"
        component={ChatScreen}
        options={{ headerShown: true }}
      />
      <Stack.Screen
        name="Match"
        component={MatchScreen}
        options={{ headerShown: true }}
      />
      <Stack.Screen
        name="Questionnaire"
        component={QuestionnaireScreen}
        options={{ headerShown: true }}
      />
    </Stack.Navigator>
  );
}
