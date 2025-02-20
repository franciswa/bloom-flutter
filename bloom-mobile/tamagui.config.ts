import { createTamagui } from '@tamagui/core'
import { createInterFont } from '@tamagui/font-inter'
import { shorthands } from '@tamagui/shorthands'
import { themes, tokens } from '@tamagui/themes'
import { createMedia } from '@tamagui/react-native-media-driver'
import { createAnimations } from '@tamagui/animations-react-native'

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
})

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
    700: { normal: 'InterBold' },
  },
})

const bodyFont = createInterFont(
  {
    face: {
      normal: { normal: 'Inter' },
    },
  },
  {
    sizeSize: (size) => Math.round(size * 1.1),
    sizeLineHeight: (size) => Math.round(size * 1.1 + (size > 20 ? 10 : 10)),
  }
)

const config = createTamagui({
  defaultTheme: 'light',
  shouldAddPrefersColorThemes: false,
  themeClassNameOnRoot: false,
  shorthands,
  fonts: {
    heading: headingFont,
    body: bodyFont,
  },
  themes: {
    light: {
      background: '#FFFFFF',
      backgroundHover: '#BAF2BB',
      backgroundPress: '#BAF2BB',
      backgroundFocus: '#BAF2BB',
      color: '#000000',
      colorHover: '#757575',
      borderColor: 'rgba(0,0,0,0.1)',
      borderColorHover: '#BAF2BB',
      borderColorFocus: '#BAF2BB',
      borderColorPress: '#BAF2BB',
      placeholderColor: '#ADADAD',
    },
    dark: {
      background: '#000000',
      backgroundHover: '#BAF2BB',
      backgroundPress: '#BAF2BB',
      backgroundFocus: '#BAF2BB',
      color: '#FFFFFF',
      colorHover: '#ADADAD',
      borderColor: 'rgba(255,255,255,0.1)',
      borderColorHover: '#BAF2BB',
      borderColorFocus: '#BAF2BB',
      borderColorPress: '#BAF2BB',
      placeholderColor: '#757575',
    },
  },
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
})

export type AppConfig = typeof config

declare module 'tamagui' {
  interface TamaguiCustomConfig extends AppConfig {}
}

export default config
