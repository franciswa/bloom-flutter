import { styled, GetProps } from 'tamagui'
import { View, YStack, XStack, Text, Button, Input, Card, Avatar as TamaguiAvatar, Circle } from 'tamagui'
import { ScrollView } from 'react-native'

// Re-export Tamagui stacks
export { XStack, YStack }

// Layout components
export const Container = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
  padding: '$4',
})

export const Row = styled(XStack, {
  alignItems: 'center',
  space: '$3',
})

export const Center = styled(View, {
  alignItems: 'center',
  justifyContent: 'center',
})

// Typography
export const Title = styled(Text, {
  fontFamily: '$heading',
  fontSize: '$7',
  color: '$text',
  variants: {
    centered: {
      true: {
        textAlign: 'center',
      },
    },
  } as const,
})

export type TitleProps = GetProps<typeof Title>

export const Subtitle = styled(Text, {
  fontFamily: '$heading',
  fontSize: '$4',
  color: '$textSecondary',
  variants: {
    centered: {
      true: {
        textAlign: 'center',
      },
    },
  } as const,
})

export type SubtitleProps = GetProps<typeof Subtitle>

export const BodyText = styled(Text, {
  fontFamily: '$body',
  fontSize: '$3',
  color: '$text',
  variants: {
    secondary: {
      true: {
        color: '$textSecondary',
      },
    },
    subtle: {
      true: {
        color: '$textSubtle',
      },
    },
  } as const,
})

export type BodyTextProps = GetProps<typeof BodyText>

// Form components
export const StyledInput = styled(Input, {
  borderWidth: 1,
  borderColor: '$borderColor',
  borderRadius: '$2',
  padding: '$3',
  backgroundColor: '$background',
  fontSize: '$3',
  fontFamily: '$body',
  color: '$text',
  
  variants: {
    error: {
      true: {
        borderColor: '$error',
      },
    },
  } as const,
})

export type StyledInputProps = GetProps<typeof StyledInput>

export const StyledButton = styled(Button, {
  borderRadius: '$2',
  height: 48,
  animation: 'quick',
  backgroundColor: '$secondary',
  color: '$text',

  variants: {
    size: {
      small: {
        scale: 0.9,
        height: 38,
      },
      large: {
        scale: 1.1,
        height: 56,
      },
    },
    variant: {
      primary: {
        backgroundColor: '$secondary',
        color: '$text',
      },
      secondary: {
        backgroundColor: '$background',
        borderWidth: 1,
        borderColor: '$secondary',
        color: '$text',
      },
      outline: {
        backgroundColor: 'transparent',
        borderWidth: 1,
        borderColor: '$secondary',
        color: '$text',
      },
    },
  } as const,

  defaultVariants: {
    variant: 'primary',
  },
})

export type StyledButtonProps = GetProps<typeof StyledButton>

// Card components
export const StyledCard = styled(Card, {
  backgroundColor: '$background',
  borderRadius: '$3',
  padding: '$4',
  elevation: 2,
  
  variants: {
    interactive: {
      true: {
        pressStyle: {
          scale: 0.98,
        },
        hoverStyle: {
          scale: 1.02,
        },
      },
    },
    bordered: {
      true: {
        borderWidth: 1,
        borderColor: '$borderColor',
      },
    },
  } as const,
})

export type StyledCardProps = GetProps<typeof StyledCard>

// Avatar component
export const Avatar = styled(TamaguiAvatar, {
  backgroundColor: '$secondary',
  
  variants: {
    size: {
      small: {
        width: 32,
        height: 32,
      },
      large: {
        width: 56,
        height: 56,
      },
    },
  } as const,

  defaultVariants: {
    size: 'large',
  },
})

export type AvatarProps = GetProps<typeof Avatar>

// Badge component
export const Badge = styled(View, {
  backgroundColor: '$secondary',
  borderRadius: 12,
  paddingHorizontal: '$2',
  paddingVertical: '$1',
  minWidth: 24,
  height: 24,
  alignItems: 'center',
  justifyContent: 'center',
  
  variants: {
    variant: {
      primary: {
        backgroundColor: '$secondary',
      },
      error: {
        backgroundColor: '$error',
      },
      success: {
        backgroundColor: '$success',
      },
      info: {
        backgroundColor: '$info',
      },
    },
  } as const,

  defaultVariants: {
    variant: 'primary',
  },
})

export type BadgeProps = GetProps<typeof Badge>

export const BadgeText = styled(Text, {
  color: '$text',
  fontSize: '$1',
  fontWeight: '600',
})

// List components
export const ListItem = styled(XStack, {
  padding: '$3',
  borderBottomWidth: 1,
  borderBottomColor: '$borderColor',
  alignItems: 'center',
  space: '$3',
  
  variants: {
    interactive: {
      true: {
        pressStyle: {
          backgroundColor: '$secondary',
        },
      },
    },
  } as const,
})

export type ListItemProps = GetProps<typeof ListItem>

// Loading spinner wrapper
export const LoadingContainer = styled(View, {
  flex: 1,
  alignItems: 'center',
  justifyContent: 'center',
  backgroundColor: '$background',
})

// Message components
export const MessageBubble = styled(YStack, {
  maxWidth: '80%',
  padding: '$3',
  borderRadius: '$4',
  marginBottom: '$2',
  
  variants: {
    sent: {
      true: {
        backgroundColor: '$secondary',
        alignSelf: 'flex-end',
      },
      false: {
        backgroundColor: '$background',
        borderWidth: 1,
        borderColor: '$borderColor',
        alignSelf: 'flex-start',
      },
    },
  } as const,

  defaultVariants: {
    sent: false,
  },
})

export type MessageBubbleProps = GetProps<typeof MessageBubble>

export const MessageText = styled(Text, {
  fontFamily: '$body',
  fontSize: '$3',
  color: '$text',
  
  variants: {
    sent: {
      true: {
        color: '$text',
      },
      false: {
        color: '$text',
      },
    },
  } as const,

  defaultVariants: {
    sent: false,
  },
})

export type MessageTextProps = GetProps<typeof MessageText>

export const MessageTimeText = styled(Text, {
  fontSize: '$2',
  color: '$textSubtle',
  marginTop: '$1',
})

export const MessageContainer = styled(YStack, {
  flex: 1,
  padding: '$4',
})

export const MessageInputContainer = styled(XStack, {
  padding: '$4',
  borderTopWidth: 1,
  borderTopColor: '$borderColor',
  backgroundColor: '$background',
  alignItems: 'flex-end',
})

export const MessageInput = styled(Input, {
  flex: 1,
  marginRight: '$2',
  paddingVertical: '$2',
  maxHeight: 100,
  backgroundColor: '$background',
  color: '$text',
})

// Match components
export const MatchCard = styled(Card, {
  width: '100%',
  backgroundColor: '$background',
  borderRadius: '$4',
  padding: '$4',
  marginBottom: '$4',
  
  variants: {
    highlighted: {
      true: {
        borderWidth: 2,
        borderColor: '$secondary',
      },
    },
  } as const,
})

export const MatchImage = styled(View, {
  width: '100%',
  height: 300,
  borderRadius: '$3',
  backgroundColor: '$secondary',
  marginBottom: '$3',
})

export const MatchName = styled(Text, {
  fontFamily: '$heading',
  fontSize: '$6',
  color: '$text',
  marginBottom: '$1',
})

export const MatchBio = styled(Text, {
  fontFamily: '$body',
  fontSize: '$3',
  color: '$textSecondary',
  marginBottom: '$3',
})

export const MatchStat = styled(XStack, {
  alignItems: 'center',
  space: '$2',
  marginBottom: '$2',
})

export const MatchStatLabel = styled(Text, {
  fontFamily: '$body',
  fontSize: '$2',
  color: '$textSubtle',
})

export const MatchStatValue = styled(Text, {
  fontFamily: '$body',
  fontSize: '$2',
  color: '$text',
  fontWeight: '600',
})

export const CompatibilityScore = styled(View, {
  position: 'absolute',
  top: '$3',
  right: '$3',
  backgroundColor: '$secondary',
  borderRadius: '$4',
  padding: '$2',
  minWidth: 60,
  alignItems: 'center',
})

export const CompatibilityText = styled(Text, {
  fontFamily: '$heading',
  fontSize: '$4',
  color: '$text',
  fontWeight: '600',
})

// Step indicator components
export const StepIndicator = styled(XStack, {
  justifyContent: 'center',
  marginTop: '$4',
  space: '$4',
})

export const StepDot = styled(View, {
  width: 10,
  height: 10,
  borderRadius: 5,
  backgroundColor: '$textSubtle',
  
  variants: {
    active: {
      true: {
        backgroundColor: '$secondary',
        scale: 1.2,
      },
    },
  } as const,
})

export type StepDotProps = GetProps<typeof StepDot>

export const FormContainer = styled(YStack, {
  space: '$4',
  marginTop: '$6',
})

export const ButtonContainer = styled(XStack, {
  justifyContent: 'space-between',
  marginTop: '$6',
  space: '$4',
})

// Astrological components
export const ZodiacIcon = styled(View, {
  width: 40,
  height: 40,
  borderRadius: 20,
  backgroundColor: '$secondary',
  alignItems: 'center',
  justifyContent: 'center',
  
  variants: {
    element: {
      fire: {
        backgroundColor: '$red8',
      },
      earth: {
        backgroundColor: '$green8',
      },
      air: {
        backgroundColor: '$yellow8',
      },
      water: {
        backgroundColor: '$blue8',
      },
    },
    size: {
      small: {
        width: 32,
        height: 32,
        borderRadius: 16,
      },
      large: {
        width: 48,
        height: 48,
        borderRadius: 24,
      },
    },
  } as const,
})

export type ZodiacIconProps = GetProps<typeof ZodiacIcon>

export const AspectLine = styled(View, {
  height: 2,
  backgroundColor: '$secondary',
  
  variants: {
    aspect: {
      conjunction: {
        backgroundColor: '$green8',
      },
      opposition: {
        backgroundColor: '$red8',
      },
      trine: {
        backgroundColor: '$blue8',
      },
      square: {
        backgroundColor: '$yellow8',
      },
      sextile: {
        backgroundColor: '$purple8',
      },
    },
  } as const,
})

export type AspectLineProps = GetProps<typeof AspectLine>

export const ChartWheel = styled(Circle, {
  width: 300,
  height: 300,
  borderWidth: 2,
  borderColor: '$borderColor',
  alignItems: 'center',
  justifyContent: 'center',
})

export const HouseSegment = styled(View, {
  position: 'absolute',
  width: '100%',
  height: '100%',
  borderWidth: 1,
  borderColor: '$borderColor',
  
  variants: {
    active: {
      true: {
        borderColor: '$secondary',
        borderWidth: 2,
      },
    },
  } as const,
})

export const PlanetSymbol = styled(Text, {
  fontSize: '$4',
  color: '$text',
  fontFamily: '$body',
  
  variants: {
    highlighted: {
      true: {
        color: '$secondary',
        fontSize: '$5',
      },
    },
  } as const,
})

export const AspectGrid = styled(View, {
  width: '100%',
  aspectRatio: 1,
  borderWidth: 1,
  borderColor: '$borderColor',
})

export const AspectCell = styled(View, {
  borderWidth: 0.5,
  borderColor: '$borderColor',
  alignItems: 'center',
  justifyContent: 'center',
  
  variants: {
    highlighted: {
      true: {
        backgroundColor: '$backgroundHover',
      },
    },
  } as const,
})

export const CompatibilityDetail = styled(YStack, {
  padding: '$3',
  borderRadius: '$2',
  backgroundColor: '$backgroundStrong',
  marginBottom: '$2',
})

export const CompatibilityLabel = styled(Text, {
  fontSize: '$3',
  color: '$textSecondary',
  marginBottom: '$1',
  fontFamily: '$body',
})

export const CompatibilityValue = styled(Text, {
  fontSize: '$4',
  color: '$text',
  fontWeight: 'bold',
  fontFamily: '$body',
})

export const ElementTag = styled(View, {
  paddingHorizontal: '$2',
  paddingVertical: '$1',
  borderRadius: '$1',
  
  variants: {
    element: {
      fire: {
        backgroundColor: '$red3',
      },
      earth: {
        backgroundColor: '$green3',
      },
      air: {
        backgroundColor: '$yellow3',
      },
      water: {
        backgroundColor: '$blue3',
      },
    },
  } as const,
})

export const ElementText = styled(Text, {
  fontSize: '$2',
  fontWeight: '600',
  fontFamily: '$body',
  
  variants: {
    element: {
      fire: {
        color: '$red11',
      },
      earth: {
        color: '$green11',
      },
      air: {
        color: '$yellow11',
      },
      water: {
        color: '$blue11',
      },
    },
  } as const,
})
