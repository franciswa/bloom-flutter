import React from 'react';
import {
  YStack,
  XStack,
  Text,
  H1,
  Switch,
  Slider,
  Form,
  styled,
  useTheme,
} from 'tamagui';
import { StyledButton, LoadingContainer } from '../theme/components';
import { Alert, ActivityIndicator } from 'react-native';
import { useAuth } from '../hooks/useAuth';
import { useSettings } from '../hooks/useSettings';

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
  const { user, signOut } = useAuth();
  const { settings, loading, error, saveSettings } = useSettings(user?.id || '');

  if (loading) {
    return (
      <LoadingContainer>
        <ActivityIndicator size="large" color="#BAF2BB" />
      </LoadingContainer>
    );
  }

  if (error || !settings) {
    return (
      <LoadingContainer>
        <Text color="$error" marginBottom="$4">{error || 'Failed to load settings'}</Text>
        <StyledButton variant="primary" onPress={() => window.location.reload()}>
          Retry
        </StyledButton>
      </LoadingContainer>
    );
  }

  return (
    <Container>
      <Header>
        <HeaderTitle>Settings</HeaderTitle>
      </Header>

      <Form space="$4">
        <Section>
          <SectionTitle>Appearance</SectionTitle>
          <SettingRow>
            <SettingLabel>Dark Mode</SettingLabel>
            <Switch
              checked={settings.dark_mode}
              onCheckedChange={(checked) =>
                saveSettings({ dark_mode: checked })
              }
            />
          </SettingRow>
        </Section>

        <Section>
          <SectionTitle>Notifications</SectionTitle>
          <SettingRow>
            <SettingLabel>Enable Notifications</SettingLabel>
            <Switch
              checked={settings.notifications_enabled}
              onCheckedChange={(checked) =>
                saveSettings({ notifications_enabled: checked })
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
                    saveSettings({
                      notification_preferences: {
                        ...settings.notification_preferences,
                        matches: checked,
                      },
                    })
                  }
                />
              </SettingRow>
              <SettingRow>
                <SettingLabel>Message Notifications</SettingLabel>
                <Switch
                  checked={settings.notification_preferences.messages}
                  onCheckedChange={(checked) =>
                    saveSettings({
                      notification_preferences: {
                        ...settings.notification_preferences,
                        messages: checked,
                      },
                    })
                  }
                />
              </SettingRow>
              <SettingRow>
                <SettingLabel>Date Reminders</SettingLabel>
                <Switch
                  checked={settings.notification_preferences.date_reminders}
                  onCheckedChange={(checked) =>
                    saveSettings({
                      notification_preferences: {
                        ...settings.notification_preferences,
                        date_reminders: checked,
                      },
                    })
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
                saveSettings({ distance_range: value })
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
                  saveSettings({ age_range_min: value })
                }
                width="45%"
                min={18}
                max={100}
                step={1}
              />
              <Slider
                value={[settings.age_range_max]}
                onValueChange={([value]) =>
                  saveSettings({ age_range_max: value })
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
                saveSettings({
                  privacy_settings: {
                    ...settings.privacy_settings,
                    show_location: checked,
                  },
                })
              }
            />
          </SettingRow>
          <SettingRow>
            <SettingLabel>Show Age</SettingLabel>
            <Switch
              checked={settings.privacy_settings.show_age}
              onCheckedChange={(checked) =>
                saveSettings({
                  privacy_settings: {
                    ...settings.privacy_settings,
                    show_age: checked,
                  },
                })
              }
            />
          </SettingRow>
          <SettingRow>
            <SettingLabel>Show Profile Photo</SettingLabel>
            <Switch
              checked={settings.privacy_settings.show_profile_photo}
              onCheckedChange={(checked) =>
                saveSettings({
                  privacy_settings: {
                    ...settings.privacy_settings,
                    show_profile_photo: checked,
                  },
                })
              }
            />
          </SettingRow>
        </Section>

        <Section>
          <SectionTitle>Astrological</SectionTitle>
          <SettingRow>
            <SettingLabel>Show Zodiac Sign</SettingLabel>
            <Switch
              checked={settings.show_zodiac}
              onCheckedChange={(checked) =>
                saveSettings({ show_zodiac: checked })
              }
            />
          </SettingRow>
          <SettingRow>
            <SettingLabel>Show Birth Time</SettingLabel>
            <Switch
              checked={settings.show_birth_time}
              onCheckedChange={(checked) =>
                saveSettings({ show_birth_time: checked })
              }
            />
          </SettingRow>
        </Section>

        <StyledButton
          marginTop="$6"
          variant="outline"
          onPress={signOut}
        >
          Sign Out
        </StyledButton>
      </Form>
    </Container>
  );
}
