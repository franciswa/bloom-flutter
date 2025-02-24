import { useTheme } from '../theme/ThemeProvider';

/**
 * Hook to access theme mode functionality.
 * This is a wrapper around useTheme for backward compatibility.
 * @returns Theme context value including colors, isDark flag, and setThemeMode function
 */
export const useThemeMode = () => {
  const theme = useTheme();
  return {
    isDark: theme.isDark,
    colors: theme.colors,
    setThemeMode: theme.setThemeMode,
  };
};
