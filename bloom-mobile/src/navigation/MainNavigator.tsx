import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';
import { View } from 'react-native';
import { Text, styled } from 'tamagui';
import ProfileScreen from '../screens/ProfileScreen';
import SettingsScreen from '../screens/SettingsScreen';
import NotificationsScreen from '../screens/NotificationsScreen';
import { useNotifications } from '../hooks/useNotifications';

// Placeholder screens until they're implemented
const MatchesScreen = () => null;
const MessagesScreen = () => null;

export type MainTabParamList = {
  Matches: undefined;
  Messages: undefined;
  Notifications: undefined;
  Profile: undefined;
  Settings: undefined;
};

const Tab = createBottomTabNavigator<MainTabParamList>();

const Badge = styled(View, {
  position: 'absolute',
  top: -2,
  right: -6,
  backgroundColor: '$primary',
  borderRadius: 10,
  minWidth: 20,
  height: 20,
  justifyContent: 'center',
  alignItems: 'center',
});

const BadgeText = styled(Text, {
  color: 'white',
  fontSize: 12,
  fontWeight: 'bold',
});

export default function MainNavigator() {
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
        tabBarActiveTintColor: '#FF8FB1',
        tabBarInactiveTintColor: 'gray',
      })}
    >
      <Tab.Screen name="Matches" component={MatchesScreen} />
      <Tab.Screen name="Messages" component={MessagesScreen} />
      <Tab.Screen name="Notifications" component={NotificationsScreen} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
      <Tab.Screen name="Settings" component={SettingsScreen} />
    </Tab.Navigator>
  );
}
