import React from 'react';
import { View, ScrollView } from 'react-native';
import { YStack, Text, Button, Card, XStack, Switch, Separator } from 'tamagui';
import { MainScreenProps } from '../types/navigation';
import { useAuth } from '../hooks/useAuth';
import { useProfile } from '../hooks/useProfile';

type Props = MainScreenProps<'Settings'>;

interface SettingsSection {
  title: string;
  items: SettingsItem[];
}

interface SettingsItem {
  id: string;
  label: string;
  type: 'switch' | 'button' | 'link';
  value?: boolean;
  onPress?: () => void;
  color?: string;
}

export default function SettingsScreen({ navigation }: Props) {
  const { user, signOut } = useAuth();
  const { profile } = useProfile(user?.id || '');

  const settingsSections: SettingsSection[] = [
    {
      title: 'Account',
      items: [
        {
          id: 'edit-profile',
          label: 'Edit Profile',
          type: 'link',
          onPress: () => {
            // TODO: Navigate to edit profile screen
          },
        },
        {
          id: 'birth-info',
          label: 'Birth Information',
          type: 'link',
          onPress: () => {
            // TODO: Navigate to birth info screen
          },
        },
        {
          id: 'privacy',
          label: 'Privacy Settings',
          type: 'link',
          onPress: () => {
            // TODO: Navigate to privacy settings
          },
        },
      ],
    },
    {
      title: 'Notifications',
      items: [
        {
          id: 'push-notifications',
          label: 'Push Notifications',
          type: 'switch',
          value: true,
        },
        {
          id: 'email-notifications',
          label: 'Email Notifications',
          type: 'switch',
          value: false,
        },
        {
          id: 'match-alerts',
          label: 'Match Alerts',
          type: 'switch',
          value: true,
        },
      ],
    },
    {
      title: 'Support',
      items: [
        {
          id: 'help',
          label: 'Help & Support',
          type: 'link',
          onPress: () => {
            // TODO: Navigate to help screen
          },
        },
        {
          id: 'privacy-policy',
          label: 'Privacy Policy',
          type: 'link',
          onPress: () => {
            // TODO: Open privacy policy
          },
        },
        {
          id: 'terms',
          label: 'Terms of Service',
          type: 'link',
          onPress: () => {
            // TODO: Open terms of service
          },
        },
      ],
    },
    {
      title: 'Account Actions',
      items: [
        {
          id: 'sign-out',
          label: 'Sign Out',
          type: 'button',
          onPress: signOut,
          color: '$red10',
        },
        {
          id: 'delete-account',
          label: 'Delete Account',
          type: 'button',
          onPress: () => {
            // TODO: Show delete account confirmation
          },
          color: '$red10',
        },
      ],
    },
  ];

  const renderSettingsItem = (item: SettingsItem) => {
    switch (item.type) {
      case 'switch':
        return (
          <XStack
            key={item.id}
            justifyContent="space-between"
            alignItems="center"
            paddingVertical="$3"
          >
            <Text fontSize="$4">{item.label}</Text>
            <Switch
              checked={item.value}
              onCheckedChange={(checked) => {
                // TODO: Handle switch change
                console.log(`${item.id} switched to ${checked}`);
              }}
            />
          </XStack>
        );
      case 'button':
      case 'link':
        return (
          <Button
            key={item.id}
            onPress={item.onPress}
            variant="outlined"
            backgroundColor="$background"
            marginVertical="$1"
          >
            <Text
              fontSize="$4"
              color={item.color || (item.type === 'link' ? '$blue10' : '$text')}
            >
              {item.label}
            </Text>
          </Button>
        );
    }
  };

  if (!profile) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <Text>Loading...</Text>
      </View>
    );
  }

  return (
    <ScrollView style={{ flex: 1 }}>
      <YStack padding="$4" space="$6">
        <YStack space="$2" alignItems="center">
          <Text fontFamily="$heading" fontSize="$6">
            Settings
          </Text>
          <Text color="$textSecondary" fontSize="$3">
            {user?.email}
          </Text>
        </YStack>

        {settingsSections.map((section) => (
          <YStack key={section.title} space="$2">
            <Text fontFamily="$heading" fontSize="$5" color="$textSecondary">
              {section.title}
            </Text>
            <Card bordered padding="$4">
              <YStack space="$2">
                {section.items.map((item, index) => (
                  <React.Fragment key={item.id}>
                    {renderSettingsItem(item)}
                    {index < section.items.length - 1 && (
                      <Separator marginVertical="$2" />
                    )}
                  </React.Fragment>
                ))}
              </YStack>
            </Card>
          </YStack>
        ))}
      </YStack>
    </ScrollView>
  );
}
