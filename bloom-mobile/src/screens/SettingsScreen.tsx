import React from 'react';
import {
  YStack,
  XStack,
  Text,
  H1,
  H4,
  Switch,
  Separator,
  Button,
  ScrollView,
  Slider,
  styled,
} from 'tamagui';
import { useSettings } from '../hooks/useSettings';
import { ThemeMode } from '../types/database';

const MainContainer = styled(ScrollView, {
  flex: 1,
  backgroundColor: '$background',
});

const Header = styled(YStack, {
  paddingHorizontal: '$4',
  paddingVertical: '$5',
});

const HeaderTitle = styled(H1, {
  color: '$text',
  fontFamily: '$heading',
});

const Section = styled(YStack, {
  padding: '$4',
});

const SectionTitle = styled(H4, {
  color: '$text',
  marginBottom: '$4',
  fontFamily: '$heading',
});

const Setting = styled(YStack, {
  marginBottom: '$4',
});

const SettingLabel = styled(Text, {
  fontSize: '$4',
  marginBottom: '$2',
  color: '$text',
  fontFamily: '$body',
});

const ThemeButtons = styled(XStack, {
  gap: '$2',
  marginTop: '$2',
});

const ThemeButton = styled(Button, {
  flex: 1,
  backgroundColor: '$backgroundHover',
  
  variants: {
    selected: {
      true: {
        backgroundColor: '$primary',
      },
    },
  },
  pressStyle: {
    opacity: 0.8,
  },
});

const ThemeButtonText = styled(Text, {
  color: '$text',
  fontSize: '$3',
  fontFamily: '$body',
  
  variants: {
    selected: {
      true: {
        color: 'white',
      },
    },
  },
});

const SliderContainer = styled(YStack, {
  gap: '$4',
});

const LoadingContainer = styled(YStack, {
  flex: 1,
  justifyContent: 'center',
  alignItems: 'center',
  backgroundColor: '$background',
});

const LoadingText = styled(Text, {
  fontSize: '$4',
  color: '$text',
  fontFamily: '$body',
});

const ErrorText = styled(Text, {
  fontSize: '$4',
  color: '$red10',
  textAlign: 'center',
  fontFamily: '$body',
});

export default function SettingsScreen() {
  const { settings, loading, error, updateSettings, updateThemeMode } = useSettings();

  if (loading) {
    return (
      <LoadingContainer>
        <LoadingText>Loading...</LoadingText>
      </LoadingContainer>
    );
  }

  if (error || !settings) {
    return (
      <LoadingContainer>
        <ErrorText>{error || 'Failed to load settings'}</ErrorText>
      </LoadingContainer>
    );
  }

  const themeModes: ThemeMode[] = ['light', 'dark', 'system'];

  return (
    <MainContainer>
      <Header>
        <HeaderTitle>Settings</HeaderTitle>
      </Header>

      <Section>
        <SectionTitle>Notifications</SectionTitle>
        <Setting>
          <XStack justifyContent="space-between" alignItems="center">
            <SettingLabel>Enable Notifications</SettingLabel>
            <Switch
              checked={settings.notifications_enabled}
              onCheckedChange={(value) => updateSettings({ notifications_enabled: value })}
            />
          </XStack>
        </Setting>
        
        {settings.notifications_enabled && (
          <>
            <Setting>
              <XStack justifyContent="space-between" alignItems="center">
                <SettingLabel>Match Notifications</SettingLabel>
                <Switch
                  checked={settings.notification_preferences.matches}
                  onCheckedChange={(value) => updateSettings({
                    notification_preferences: {
                      ...settings.notification_preferences,
                      matches: value,
                    }
                  })}
                />
              </XStack>
            </Setting>
            <Setting>
              <XStack justifyContent="space-between" alignItems="center">
                <SettingLabel>Message Notifications</SettingLabel>
                <Switch
                  checked={settings.notification_preferences.messages}
                  onCheckedChange={(value) => updateSettings({
                    notification_preferences: {
                      ...settings.notification_preferences,
                      messages: value,
                    }
                  })}
                />
              </XStack>
            </Setting>
            <Setting>
              <XStack justifyContent="space-between" alignItems="center">
                <SettingLabel>Date Reminders</SettingLabel>
                <Switch
                  checked={settings.notification_preferences.date_reminders}
                  onCheckedChange={(value) => updateSettings({
                    notification_preferences: {
                      ...settings.notification_preferences,
                      date_reminders: value,
                    }
                  })}
                />
              </XStack>
            </Setting>
          </>
        )}
      </Section>

      <Separator />

      <Section>
        <SectionTitle>Appearance</SectionTitle>
        <Setting>
          <SettingLabel>Theme Mode</SettingLabel>
          <ThemeButtons>
            {themeModes.map((mode) => (
              <ThemeButton
                key={mode}
                selected={settings.theme_mode === mode}
                onPress={() => updateThemeMode(mode)}
              >
                <ThemeButtonText selected={settings.theme_mode === mode}>
                  {mode.charAt(0).toUpperCase() + mode.slice(1)}
                </ThemeButtonText>
              </ThemeButton>
            ))}
          </ThemeButtons>
        </Setting>
      </Section>

      <Separator />

      <Section>
        <SectionTitle>Discovery</SectionTitle>
        <SliderContainer>
          <Setting>
            <SettingLabel>Maximum Distance ({settings.distance_range} miles)</SettingLabel>
            <Slider
              defaultValue={[settings.distance_range]}
              min={5}
              max={100}
              step={5}
              onValueChange={([value]) => updateSettings({ distance_range: value })}
            >
              <Slider.Track>
                <Slider.TrackActive />
              </Slider.Track>
              <Slider.Thumb circular index={0} />
            </Slider>
          </Setting>

          <Setting>
            <SettingLabel>Age Range ({settings.age_range_min} - {settings.age_range_max})</SettingLabel>
            <YStack space="$4">
              <Slider
                defaultValue={[settings.age_range_min]}
                min={18}
                max={99}
                step={1}
                onValueChange={([value]) => {
                  if (value <= settings.age_range_max) {
                    updateSettings({ age_range_min: value });
                  }
                }}
              >
                <Slider.Track>
                  <Slider.TrackActive />
                </Slider.Track>
                <Slider.Thumb circular index={0} />
              </Slider>
              <Slider
                defaultValue={[settings.age_range_max]}
                min={18}
                max={99}
                step={1}
                onValueChange={([value]) => {
                  if (value >= settings.age_range_min) {
                    updateSettings({ age_range_max: value });
                  }
                }}
              >
                <Slider.Track>
                  <Slider.TrackActive />
                </Slider.Track>
                <Slider.Thumb circular index={0} />
              </Slider>
            </YStack>
          </Setting>
        </SliderContainer>
      </Section>

      <Separator />

      <Section>
        <SectionTitle>Privacy</SectionTitle>
        <Setting>
          <XStack justifyContent="space-between" alignItems="center">
            <SettingLabel>Show Zodiac Sign</SettingLabel>
            <Switch
              checked={settings.show_zodiac}
              onCheckedChange={(value) => updateSettings({ show_zodiac: value })}
            />
          </XStack>
        </Setting>
        <Setting>
          <XStack justifyContent="space-between" alignItems="center">
            <SettingLabel>Show Birth Time</SettingLabel>
            <Switch
              checked={settings.show_birth_time}
              onCheckedChange={(value) => updateSettings({ show_birth_time: value })}
            />
          </XStack>
        </Setting>
        <Setting>
          <XStack justifyContent="space-between" alignItems="center">
            <SettingLabel>Show Location</SettingLabel>
            <Switch
              checked={settings.privacy_settings.show_location}
              onCheckedChange={(value) => updateSettings({
                privacy_settings: {
                  ...settings.privacy_settings,
                  show_location: value,
                }
              })}
            />
          </XStack>
        </Setting>
        <Setting>
          <XStack justifyContent="space-between" alignItems="center">
            <SettingLabel>Show Age</SettingLabel>
            <Switch
              checked={settings.privacy_settings.show_age}
              onCheckedChange={(value) => updateSettings({
                privacy_settings: {
                  ...settings.privacy_settings,
                  show_age: value,
                }
              })}
            />
          </XStack>
        </Setting>
        <Setting>
          <XStack justifyContent="space-between" alignItems="center">
            <SettingLabel>Show Profile Photo</SettingLabel>
            <Switch
              checked={settings.privacy_settings.show_profile_photo}
              onCheckedChange={(value) => updateSettings({
                privacy_settings: {
                  ...settings.privacy_settings,
                  show_profile_photo: value,
                }
              })}
            />
          </XStack>
        </Setting>
      </Section>
    </MainContainer>
  );
}
