import React from 'react';
import { TamaguiProvider } from 'tamagui';
import config from './tamagui.config';
import { RootNavigator } from './src/navigation/RootNavigator';
import { AuthProvider } from './src/hooks/useAuth';
import { ProfileProvider } from './src/hooks/useProfile';
import { NotificationsProvider } from './src/hooks/notifications-context';

export default function App() {
  // Using system font Futura, no need to load custom fonts

  return (
    <TamaguiProvider config={config}>
      <AuthProvider>
        <ProfileProvider>
          <NotificationsProvider>
            <RootNavigator />
          </NotificationsProvider>
        </ProfileProvider>
      </AuthProvider>
    </TamaguiProvider>
  );
}
