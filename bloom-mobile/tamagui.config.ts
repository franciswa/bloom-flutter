import { createTamagui, createFont, createTokens } from 'tamagui'
import { shorthands } from '@tamagui/shorthands'
import { createMedia } from '@tamagui/react-native-media-driver'
import { createAnimations } from '@tamagui/animations-react-native'

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
    1: 14,
    2: 16,
    3: 18,
    4: 20,
    5: 24,
    6: 28,
    7: 36,
    8: 48,
    9: 64,
    10: 96,
  },
  lineHeight: {
    1: 20,
    2: 24,
    3: 26,
    4: 28,
    5: 32,
    6: 36,
    7: 48,
    8: 64,
    9: 80,
    10: 112,
  },
  weight: {
    4: '500',
    6: '700',
  },
  letterSpacing: {
    4: -0.5,
    8: -1,
  },
})

const bodyFont = createFont({
  family: 'OpenSauceOne-Medium',
  size: {
    1: 11,
    2: 12,
    3: 13,
    4: 14,
    5: 16,
    6: 18,
    7: 20,
    8: 22,
    9: 30,
    10: 42,
  },
  lineHeight: {
    1: 15,
    2: 17,
    3: 19,
    4: 21,
    5: 24,
    6: 28,
    7: 32,
    8: 36,
    9: 44,
    10: 56,
  },
  weight: {
    4: '400',
    6: '600',
  },
  letterSpacing: {
    4: 0,
    8: -1,
  },
})

const tokens = createTokens({
  color: {
    primary: '#FF8FB1',    // Soft pink rose color
    secondary: '#98FB98',  // Pale green leaf color
    
    // Gray scale
    gray1: '#FCFCFC',
    gray2: '#F8F8F8',
    gray3: '#F3F3F3',
    gray4: '#EDEDED',
    gray5: '#E8E8E8',
    gray6: '#E2E2E2',
    gray7: '#DBDBDB',
    gray8: '#C7C7C7',
    gray9: '#8F8F8F',
    gray10: '#858585',
    gray11: '#6F6F6F',
    gray12: '#171717',
    
    background: '#FFFFFF',
    backgroundHover: '#F5F5F5',
    backgroundPress: '#EEEEEE',
    backgroundFocus: '#F8F8F8',
    backgroundStrong: '#FFFFFF',
    backgroundTransparent: 'rgba(255,255,255,0)',
    
    color: '#000000',
    colorHover: '#111111',
    colorPress: '#222222',
    colorFocus: '#111111',
    colorTransparent: 'rgba(0,0,0,0)',
    
    borderColor: '#DDDDDD',
    borderColorHover: '#CCCCCC',
    borderColorFocus: '#999999',
    borderColorPress: '#BBBBBB',
    
    shadowColor: 'rgba(0,0,0,0.1)',
    shadowColorHover: 'rgba(0,0,0,0.15)',
    
    text: '#000000',
    textSecondary: '#666666',
    
    success: '#52C41A',
    error: '#FF6B6B',
    warning: '#FFC107',
  },
  space: {
    0: 0,
    1: 4,
    2: 8,
    3: 12,
    4: 16,
    5: 24,
    6: 32,
    7: 48,
    8: 64,
    9: 96,
    10: 128,
    true: 8,
  },
  size: {
    0: 0,
    1: 4,
    2: 8,
    3: 12,
    4: 16,
    5: 24,
    6: 32,
    7: 48,
    8: 64,
    9: 96,
    10: 128,
    true: 8,
  },
  radius: {
    0: 0,
    1: 4,
    2: 8,
    3: 12,
    4: 16,
    5: 24,
    6: 32,
    true: 8,
  },
  zIndex: {
    0: 0,
    1: 100,
    2: 200,
    3: 300,
    4: 400,
    5: 500,
  }
})

const config = createTamagui({
  animations,
  defaultTheme: 'light',
  shouldAddPrefersColorThemes: true,
  themeClassNameOnRoot: true,
  shorthands,
  fonts: {
    heading: headingFont,
    body: bodyFont,
  },
  themes: {
    light: {
      background: tokens.color.background,
      backgroundHover: tokens.color.backgroundHover,
      backgroundPress: tokens.color.backgroundPress,
      backgroundFocus: tokens.color.backgroundFocus,
      backgroundStrong: tokens.color.backgroundStrong,
      backgroundTransparent: tokens.color.backgroundTransparent,
      
      color: tokens.color.color,
      colorHover: tokens.color.colorHover,
      colorPress: tokens.color.colorPress,
      colorFocus: tokens.color.colorFocus,
      colorTransparent: tokens.color.colorTransparent,
      
      borderColor: tokens.color.borderColor,
      borderColorHover: tokens.color.borderColorHover,
      borderColorFocus: tokens.color.borderColorFocus,
      borderColorPress: tokens.color.borderColorPress,
      
      shadowColor: tokens.color.shadowColor,
      shadowColorHover: tokens.color.shadowColorHover,
      
      primary: tokens.color.primary,
      secondary: tokens.color.secondary,
      
      text: tokens.color.text,
      textSecondary: tokens.color.textSecondary,
      
      success: tokens.color.success,
      error: tokens.color.error,
      warning: tokens.color.warning,

      // Gray scale
      gray1: tokens.color.gray1,
      gray2: tokens.color.gray2,
      gray3: tokens.color.gray3,
      gray4: tokens.color.gray4,
      gray5: tokens.color.gray5,
      gray6: tokens.color.gray6,
      gray7: tokens.color.gray7,
      gray8: tokens.color.gray8,
      gray9: tokens.color.gray9,
      gray10: tokens.color.gray10,
      gray11: tokens.color.gray11,
      gray12: tokens.color.gray12,
    },
    dark: {
      background: '#000000',
      backgroundHover: '#111111',
      backgroundPress: '#222222',
      backgroundFocus: '#111111',
      backgroundStrong: '#000000',
      backgroundTransparent: 'rgba(0,0,0,0)',
      
      color: '#FFFFFF',
      colorHover: '#EEEEEE',
      colorPress: '#DDDDDD',
      colorFocus: '#EEEEEE',
      colorTransparent: 'rgba(255,255,255,0)',
      
      borderColor: '#333333',
      borderColorHover: '#444444',
      borderColorFocus: '#666666',
      borderColorPress: '#555555',
      
      shadowColor: 'rgba(0,0,0,0.3)',
      shadowColorHover: 'rgba(0,0,0,0.4)',
      
      primary: tokens.color.primary,
      secondary: tokens.color.secondary,
      
      text: '#FFFFFF',
      textSecondary: '#999999',
      
      success: tokens.color.success,
      error: tokens.color.error,
      warning: tokens.color.warning,

      // Gray scale (inverted for dark theme)
      gray1: '#171717',
      gray2: '#1F1F1F',
      gray3: '#2A2A2A',
      gray4: '#363636',
      gray5: '#424242',
      gray6: '#535353',
      gray7: '#6F6F6F',
      gray8: '#858585',
      gray9: '#9E9E9E',
      gray10: '#B8B8B8',
      gray11: '#CFCFCF',
      gray12: '#FCFCFC',
    },
  },
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
