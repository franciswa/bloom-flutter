import React, { createContext, useContext, useEffect } from 'react';
import { useColorScheme } from 'react-native';
import { Theme, useTheme as useTamaguiTheme } from 'tamagui';
import { useSettings } from '../hooks/useSettings';
import { ThemeMode } from '../types/database';

interface ThemeContextValue {
  isDark: boolean;
  setThemeMode: (mode: ThemeMode) => Promise<void>;
}

const ThemeContext = createContext<ThemeContextValue>({
  isDark: false,
  setThemeMode: async () => {},
});

export const useTheme = () => {
  const context = useContext(ThemeContext);
  const theme = useTamaguiTheme();
  return {
    ...context,
    theme,
  };
};

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const systemColorScheme = useColorScheme();
  const { settings, updateThemeMode } = useSettings();

  const isDark = settings?.theme_mode === 'dark' || 
    (settings?.theme_mode === 'system' && systemColorScheme === 'dark');

  const setThemeMode = async (mode: ThemeMode) => {
    await updateThemeMode(mode);
  };

  const value: ThemeContextValue = {
    isDark,
    setThemeMode,
  };

  // Determine the current theme name based on settings
  const themeName = settings?.theme_mode === 'dark' || 
    (settings?.theme_mode === 'system' && systemColorScheme === 'dark') 
    ? 'dark' 
    : 'light';

  return (
    <ThemeContext.Provider value={value}>
      <Theme name={themeName}>
        {children}
      </Theme>
    </ThemeContext.Provider>
  );
}
