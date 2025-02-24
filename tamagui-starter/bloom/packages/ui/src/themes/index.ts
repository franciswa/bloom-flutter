import { createTheme } from '@tamagui/core'
import { tokens } from './token-colors'

const light = createTheme({
  background: tokens.color.background,
  color: tokens.color.text,
  'background-muted': '#F2F2F7',
  'color-muted': tokens.color.textMuted,
  'border-color': tokens.color.border,
  primary: tokens.color.primary,
  secondary: tokens.color.secondary,
  error: tokens.color.error,
  success: tokens.color.success,
  warning: tokens.color.warning,
})

const dark = createTheme({
  background: '#000000',
  color: '#FFFFFF',
  'background-muted': '#1C1C1E',
  'color-muted': '#8E8E93',
  'border-color': '#38383A',
  primary: '#0A84FF',
  secondary: '#5E5CE6',
  error: '#FF453A',
  success: '#32D74B',
  warning: '#FFD60A',
})

export const themes = {
  light,
  dark,
} as const
