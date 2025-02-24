import { createAnimations } from '@tamagui/animations-react-native'

export const animations = createAnimations({
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
  tooltip: {
    type: 'spring',
    damping: 10,
    mass: 0.9,
    stiffness: 100,
  },
  'fade-in': {
    type: 'timing',
    duration: 150,
  },
  'fade-out': {
    type: 'timing',
    duration: 100,
  },
  'slide-in': {
    type: 'spring',
    damping: 20,
    mass: 1.2,
    stiffness: 250,
  },
  'slide-out': {
    type: 'spring',
    damping: 20,
    mass: 1.2,
    stiffness: 250,
  },
})
