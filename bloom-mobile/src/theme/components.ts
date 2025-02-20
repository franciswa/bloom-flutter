import { styled, GetProps } from 'tamagui'
import { View, YStack, XStack, Text, Button, Input, Card, Avatar as TamaguiAvatar } from 'tamagui'
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
