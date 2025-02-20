import { createTamagui, createFont, createTokens } from 'tamagui'
import { shorthands } from '@tamagui/shorthands'
import { createMedia } from '@tamagui/react-native-media-driver'
import { createAnimations } from '@tamagui/animations-react-native'

// Custom color tokens
const tokens = createTokens({
  color: {
    primary: '#FFFFFF',
    secondary: '#BAF2BB',
    background: '#FFFFFF',
    text: '#000000',
    textSecondary: '#757575',
    textSubtle: '#ADADAD',
    success: '#4CAF50',
    error: '#FF5252',
    info: '#2196F3',
    borderColor: 'rgba(0,0,0,0.1)',
  },
  space: {
    $0: 0,
    $1: 4,
    $2: 8,
    $3: 12,
    $4: 16,
    $5: 24,
    $6: 32,
    $7: 48,
    $8: 64,
    $9: 96,
    $10: 128,
  },
  size: {
    $0: 0,
    $1: 4,
    $2: 8,
    $3: 12,
    $4: 16,
    $5: 24,
    $6: 32,
    $7: 48,
    $8: 64,
    $9: 96,
    $10: 128,
  },
  radius: {
    $0: 0,
    $1: 4,
    $2: 8,
    $3: 12,
    $4: 16,
    $5: 24,
    $6: 32,
  },
  zIndex: {
    $0: 0,
    $1: 100,
    $2: 200,
    $3: 300,
    $4: 400,
    $5: 500,
  },
})

const animations = createAnimations({
  bouncy: {
    type: 'spring',
    damping: 10,
    mass: 0.9,
    stiffness: 100,
  },
  lazy: {
    type: 'spring',
    damping: 20,
    stiffness: 60,
  },
  quick: {
    type: 'spring',
    damping: 20,
    mass: 1.2,
    stiffness: 250,
  },
})

const headingFont = createFont({
  family: 'Geist',
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
  lineHeight: {
    1: 16,
    2: 20,
    3: 24,
    4: 28,
    5: 32,
    6: 40,
    7: 48,
    8: 56,
    9: 72,
  },
  weight: {
    4: '400',
    6: '600',
    8: '700',
  },
  letterSpacing: {
    4: 0,
    8: -1,
  },
})

const bodyFont = createFont({
  family: 'OpenSauce',
  size: {
    1: 12,
    2: 14,
    3: 16,
    4: 18,
    5: 20,
    6: 24,
    7: 28,
    8: 32,
    9: 36,
  },
  lineHeight: {
    1: 16,
    2: 20,
    3: 24,
    4: 28,
    5: 32,
    6: 36,
    7: 40,
    8: 44,
    9: 48,
  },
  weight: {
    4: '400',
    6: '600',
  },
})

// Custom theme
const light = {
  background: tokens.color.background,
  backgroundHover: tokens.color.secondary,
  backgroundPress: tokens.color.secondary,
  backgroundFocus: tokens.color.secondary,
  color: tokens.color.text,
  colorHover: tokens.color.textSecondary,
  borderColor: tokens.color.borderColor,
  borderColorHover: tokens.color.secondary,
  borderColorFocus: tokens.color.secondary,
  borderColorPress: tokens.color.secondary,
  placeholderColor: tokens.color.textSubtle,
}

const themes = {
  light,
  light_primary: {
    ...light,
    background: tokens.color.primary,
    color: tokens.color.text,
  },
  light_secondary: {
    ...light,
    background: tokens.color.secondary,
    color: tokens.color.text,
  },
}

const config = createTamagui({
  animations,
  shouldAddPrefersColorThemes: false,
  themeClassNameOnRoot: false,
  shorthands,
  fonts: {
    heading: headingFont,
    body: bodyFont,
  },
  themes,
  tokens,
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
})

export type AppConfig = typeof config

declare module 'tamagui' {
  interface TamaguiCustomConfig extends AppConfig {}
}

export default config
