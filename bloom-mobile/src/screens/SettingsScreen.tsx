import React, { useState } from 'react';
import {
  YStack,
  XStack,
  Text,
  H1,
  Switch,
  Slider,
  Button,
  Form,
  styled,
} from 'tamagui';
import { Alert } from 'react-native';
import { useAuth } from '../hooks/useAuth';
import { UserSettings } from '../types/database';

const Container = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
  padding: '$4',
});

const Header = styled(YStack, {
  paddingVertical: '$5',
});

const HeaderTitle = styled(H1, {
  color: '$text',
  fontFamily: '$heading',
});

const Section = styled(YStack, {
  marginTop: '$4',
  space: '$4',
});

const SectionTitle = styled(Text, {
  fontSize: '$5',
  fontWeight: 'bold',
  color: '$text',
  marginBottom: '$2',
});

const SettingRow = styled(XStack, {
  justifyContent: 'space-between',
  alignItems: 'center',
  paddingVertical: '$2',
});

const SettingLabel = styled(Text, {
  fontSize: '$4',
  color: '$text',
});

const SliderContainer = styled(YStack, {
  width: '100%',
  marginTop: '$2',
});

const SliderValue = styled(Text, {
  fontSize: '$3',
  color: '$gray11',
  textAlign: 'right',
  marginTop: '$1',
});

export default function SettingsScreen() {
  const { profile, signOut } = useAuth();
  const [settings, setSettings] = useState<UserSettings>({
    id: '1',
    user_id: profile?.id || '',
    theme_mode: 'light',
    dark_mode: false,
    notifications_enabled: true,
    notification_preferences: {
      matches: true,
      messages: true,
      date_reminders: true,
    },
    distance_range: 50,
    age_range_min: 18,
    age_range_max: 45,
    show_zodiac: true,
    show_birth_time: true,
    privacy_settings: {
      show_location: true,
      show_age: true,
      show_profile_photo: true,
    },
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  });

  const handleSave = async () => {
    try {
      // TODO: Save settings to database
      // await supabase
      //   .from('user_settings')
      //   .upsert(settings)
      //   .eq('user_id', profile?.id);
      
      Alert.alert('Success', 'Settings saved successfully');
    } catch (err) {
      Alert.alert('Error', 'Failed to save settings');
    }
  };

  return (
    <Container>
      <Header>
        <HeaderTitle>Settings</HeaderTitle>
      </Header>

      <Form space="$4">
        <Section>
          <SectionTitle>Notifications</SectionTitle>
          <SettingRow>
            <SettingLabel>Enable Notifications</SettingLabel>
            <Switch
              checked={settings.notifications_enabled}
              onCheckedChange={(checked) =>
                setSettings((prev) => ({
                  ...prev,
                  notifications_enabled: checked,
                }))
              }
            />
          </SettingRow>
          {settings.notifications_enabled && (
            <>
              <SettingRow>
                <SettingLabel>Match Notifications</SettingLabel>
                <Switch
                  checked={settings.notification_preferences.matches}
                  onCheckedChange={(checked) =>
                    setSettings((prev) => ({
                      ...prev,
                      notification_preferences: {
                        ...prev.notification_preferences,
                        matches: checked,
                      },
                    }))
                  }
                />
              </SettingRow>
              <SettingRow>
                <SettingLabel>Message Notifications</SettingLabel>
                <Switch
                  checked={settings.notification_preferences.messages}
                  onCheckedChange={(checked) =>
                    setSettings((prev) => ({
                      ...prev,
                      notification_preferences: {
                        ...prev.notification_preferences,
                        messages: checked,
                      },
                    }))
                  }
                />
              </SettingRow>
              <SettingRow>
                <SettingLabel>Date Reminders</SettingLabel>
                <Switch
                  checked={settings.notification_preferences.date_reminders}
                  onCheckedChange={(checked) =>
                    setSettings((prev) => ({
                      ...prev,
                      notification_preferences: {
                        ...prev.notification_preferences,
                        date_reminders: checked,
                      },
                    }))
                  }
                />
              </SettingRow>
            </>
          )}
        </Section>

        <Section>
          <SectionTitle>Discovery</SectionTitle>
          <SliderContainer>
            <SettingLabel>Maximum Distance (km)</SettingLabel>
            <Slider
              value={[settings.distance_range]}
              onValueChange={([value]) =>
                setSettings((prev) => ({
                  ...prev,
                  distance_range: value,
                }))
              }
              width="100%"
              min={1}
              max={100}
              step={1}
            />
            <SliderValue>{settings.distance_range} km</SliderValue>
          </SliderContainer>

          <SliderContainer>
            <SettingLabel>Age Range</SettingLabel>
            <XStack space="$4">
              <Slider
                value={[settings.age_range_min]}
                onValueChange={([value]) =>
                  setSettings((prev) => ({
                    ...prev,
                    age_range_min: value,
                  }))
                }
                width="45%"
                min={18}
                max={100}
                step={1}
              />
              <Slider
                value={[settings.age_range_max]}
                onValueChange={([value]) =>
                  setSettings((prev) => ({
                    ...prev,
                    age_range_max: value,
                  }))
                }
                width="45%"
                min={18}
                max={100}
                step={1}
              />
            </XStack>
            <SliderValue>
              {settings.age_range_min} - {settings.age_range_max} years
            </SliderValue>
          </SliderContainer>
        </Section>

        <Section>
          <SectionTitle>Privacy</SectionTitle>
          <SettingRow>
            <SettingLabel>Show Location</SettingLabel>
            <Switch
              checked={settings.privacy_settings.show_location}
              onCheckedChange={(checked) =>
                setSettings((prev) => ({
                  ...prev,
                  privacy_settings: {
                    ...prev.privacy_settings,
                    show_location: checked,
                  },
                }))
              }
            />
          </SettingRow>
          <SettingRow>
            <SettingLabel>Show Age</SettingLabel>
            <Switch
              checked={settings.privacy_settings.show_age}
              onCheckedChange={(checked) =>
                setSettings((prev) => ({
                  ...prev,
                  privacy_settings: {
                    ...prev.privacy_settings,
                    show_age: checked,
                  },
                }))
              }
            />
          </SettingRow>
          <SettingRow>
            <SettingLabel>Show Profile Photo</SettingLabel>
            <Switch
              checked={settings.privacy_settings.show_profile_photo}
              onCheckedChange={(checked) =>
                setSettings((prev) => ({
                  ...prev,
                  privacy_settings: {
                    ...prev.privacy_settings,
                    show_profile_photo: checked,
                  },
                }))
              }
            />
          </SettingRow>
        </Section>

        <Button
          marginTop="$6"
          onPress={handleSave}
          backgroundColor="$primary"
        >
          Save Settings
        </Button>

        <Button
          marginTop="$4"
          variant="outlined"
          onPress={signOut}
        >
          Sign Out
        </Button>
      </Form>
    </Container>
  );
}
