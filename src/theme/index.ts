import { createTheme } from '@tamagui/core';

const light = {
  background: '#FFFFFF',
  backgroundHover: '#BAF2BB',
  backgroundPress: '#BAF2BB',
  backgroundFocus: '#BAF2BB',
  color: '#000000',
  colorHover: '#757575',
  borderColor: 'rgba(0, 0, 0, 0.1)',
  borderColorHover: '#BAF2BB',
  borderColorFocus: '#BAF2BB',
  borderColorPress: '#BAF2BB',
  placeholderColor: '#ADADAD',
  // Custom colors
  danger: '#FF3B30',
  dangerBackground: '#FFE5E5',
  success: '#34C759',
  successBackground: '#E8F8E8',
  warning: '#FFCC00',
  warningBackground: '#FFF9E5',
  info: '#007AFF',
  infoBackground: '#E5F2FF',
};

const dark = {
  background: '#000000',
  backgroundHover: '#BAF2BB',
  backgroundPress: '#BAF2BB',
  backgroundFocus: '#BAF2BB',
  color: '#FFFFFF',
  colorHover: '#ADADAD',
  borderColor: 'rgba(255, 255, 255, 0.1)',
  borderColorHover: '#BAF2BB',
  borderColorFocus: '#BAF2BB',
  borderColorPress: '#BAF2BB',
  placeholderColor: '#757575',
  // Custom colors
  danger: '#FF453A',
  dangerBackground: '#3A0A0A',
  success: '#30D158',
  successBackground: '#0A2912',
  warning: '#FFD60A',
  warningBackground: '#3A2F0A',
  info: '#0A84FF',
  infoBackground: '#0A1F3A',
};

export const lightTheme = createTheme(light);
export const darkTheme = createTheme(dark);

export const themes = {
  light: lightTheme,
  dark: darkTheme,
};
