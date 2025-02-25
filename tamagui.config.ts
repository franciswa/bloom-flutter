import { createTamagui } from '@tamagui/core';
import { createInterFont } from '@tamagui/font-inter';
import { shorthands } from '@tamagui/shorthands';
import { tokens } from '@tamagui/themes';
import { createMedia } from '@tamagui/react-native-media-driver';
import { createAnimations } from '@tamagui/animations-react-native';
import { themes } from './src/theme';

const animations = createAnimations({
  bouncy: {
    type: 'spring',
    damping: 10,
    mass: 0.9,
    stiffness: 100,
  },
  quick: {
    type: 'spring',
    damping: 20,
    mass: 1.2,
    stiffness: 250,
  },
});

const headingFont = createInterFont({
  size: {
    1: 12,
    2: 14,
    3: 16,
    4: 20,
    5: 24,
    6: 32,
    7: 40,
    8: 48,
    9: 64,
  },
  transform: {
    6: 'uppercase',
    7: 'none',
  },
  weight: {
    3: '500',
    4: '700',
  },
  color: {
    6: '$colorFocus',
  },
  letterSpacing: {
    5: 2,
    6: 1,
    7: -1,
    8: -2,
    9: -3,
  },
  face: {
    700: { normal: 'Futura, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif' },
  },
});

const bodyFont = createInterFont(
  {
  face: {
    normal: { normal: 'Futura, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif' },
  },
  },
  {
    sizeSize: (size) => Math.round(size * 1.1),
    sizeLineHeight: (size) => Math.round(size * 1.1 + (size > 20 ? 10 : 10)),
  }
);

const geistFont = createInterFont({
  size: {
    1: 12,
    2: 14,
    3: 16,
    4: 20,
    5: 24,
    6: 32,
    7: 40,
  },
  face: {
    normal: { normal: 'Futura, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif' },
  },
});

const openSauceFont = createInterFont({
  size: {
    1: 12,
    2: 14,
    3: 16,
    4: 20,
    5: 24,
    6: 32,
    7: 40,
  },
  face: {
    normal: { normal: 'Futura, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif' },
  },
});

// Add astrological font using Futura
const astrologicalFont = createInterFont({
  size: {
    1: 12,
    2: 14,
    3: 16,
    4: 20,
    5: 24,
    6: 32,
    7: 40,
    8: 48,
  },
  face: {
    normal: { normal: 'Futura, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif' },
  },
});

const config = createTamagui({
  defaultTheme: 'light',
  shouldAddPrefersColorThemes: false,
  themeClassNameOnRoot: false,
  shorthands,
  fonts: {
    heading: headingFont,
    body: bodyFont,
    geist: geistFont,
    openSauce: openSauceFont,
    astrological: astrologicalFont,
  },
  themes,
  tokens,
  animations,
  media: createMedia({
    xs: { maxWidth: 660 },
    sm: { maxWidth: 800 },
    md: { maxWidth: 1020 },
    lg: { maxWidth: 1280 },
    xl: { maxWidth: 1420 },
    xxl: { maxWidth: 1600 },
    gtXs: { minWidth: 660 + 1 },
    gtSm: { minWidth: 800 + 1 },
    gtMd: { minWidth: 1020 + 1 },
    gtLg: { minWidth: 1280 + 1 },
    short: { maxHeight: 820 },
    tall: { minHeight: 820 },
    hoverNone: { hover: 'none' },
    pointerCoarse: { pointer: 'coarse' },
  }),
});

export type AppConfig = typeof config;

declare module 'tamagui' {
  interface TamaguiCustomConfig extends AppConfig {}
}

export default config;
