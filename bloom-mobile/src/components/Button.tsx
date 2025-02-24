import React from 'react';
import { Button as TamaguiButton, GetProps, styled, Text } from 'tamagui';
import { Spinner } from './Spinner';

export type ButtonVariant = 'primary' | 'success' | 'danger' | 'info' | 'warning';
export type ButtonSize = 'small' | 'medium' | 'large';

const StyledButton = styled(TamaguiButton, {
  name: 'Button',
  backgroundColor: '#BAF2BB',
  color: '#000000',
  alignItems: 'center',
  justifyContent: 'center',
  flexDirection: 'row',
  gap: 8,
  opacity: 1,
  animation: 'quick',
  hoverStyle: {
    opacity: 0.9,
    scale: 1.02,
  },
  pressStyle: {
    backgroundColor: '#A0E2A1',
    opacity: 0.9,
    scale: 0.98,
  },
  variants: {
    variant: {
      primary: {
        backgroundColor: '#BAF2BB',
        color: '#000000',
        hoverStyle: {
          backgroundColor: '#A0E2A1',
          opacity: 0.9,
          scale: 1.02,
        },
        pressStyle: {
          backgroundColor: '#90D291',
          opacity: 0.9,
          scale: 0.98,
        },
      },
      success: {
        backgroundColor: '#E8F8E8',
        color: '#34C759',
        hoverStyle: {
          backgroundColor: '#D8F8D8',
          opacity: 0.9,
          scale: 1.02,
        },
        pressStyle: {
          backgroundColor: '#34C759',
          color: '#FFFFFF',
          scale: 0.98,
        },
      },
      danger: {
        backgroundColor: '#FFE5E5',
        color: '#FF3B30',
        hoverStyle: {
          backgroundColor: '#FFD5D5',
          opacity: 0.9,
          scale: 1.02,
        },
        pressStyle: {
          backgroundColor: '#FF3B30',
          color: '#FFFFFF',
          scale: 0.98,
        },
      },
      info: {
        backgroundColor: '#E5F2FF',
        color: '#007AFF',
        hoverStyle: {
          backgroundColor: '#D5E2FF',
          opacity: 0.9,
          scale: 1.02,
        },
        pressStyle: {
          backgroundColor: '#007AFF',
          color: '#FFFFFF',
          scale: 0.98,
        },
      },
      warning: {
        backgroundColor: '#FFF9E5',
        color: '#FFCC00',
        hoverStyle: {
          backgroundColor: '#FFF5D5',
          opacity: 0.9,
          scale: 1.02,
        },
        pressStyle: {
          backgroundColor: '#FFCC00',
          color: '#FFFFFF',
          scale: 0.98,
        },
      },
    },
    size: {
      small: {
        height: 32,
        paddingHorizontal: 12,
        borderRadius: 6,
        fontSize: 14,
      },
      medium: {
        height: 40,
        paddingHorizontal: 16,
        borderRadius: 8,
        fontSize: 16,
      },
      large: {
        height: 48,
        paddingHorizontal: 20,
        borderRadius: 10,
        fontSize: 18,
      },
    },
  } as const,
  defaultVariants: {
    variant: 'primary',
    size: 'medium',
  },
});

type ButtonProps = Omit<GetProps<typeof StyledButton>, 'variant' | 'size'> & {
  variant?: ButtonVariant;
  size?: ButtonSize;
  loading?: boolean;
  children?: React.ReactNode;
};

const getSpinnerSize = (size: ButtonSize): number => {
  switch (size) {
    case 'small':
      return 16;
    case 'large':
      return 24;
    default:
      return 20;
  }
};

const getBackgroundColor = (variant: ButtonVariant, isPressed: boolean, isDisabled: boolean): string => {
  if (isDisabled) {
    switch (variant) {
      case 'primary':
        return '#BAF2BB80';
      case 'success':
        return '#E8F8E880';
      case 'danger':
        return '#FFE5E580';
      case 'info':
        return '#E5F2FF80';
      case 'warning':
        return '#FFF9E580';
      default:
        return '#BAF2BB80';
    }
  }

  if (isPressed) {
    switch (variant) {
      case 'primary':
        return '#90D291';
      case 'success':
        return '#34C759';
      case 'danger':
        return '#FF3B30';
      case 'info':
        return '#007AFF';
      case 'warning':
        return '#FFCC00';
      default:
        return '#90D291';
    }
  }

  switch (variant) {
    case 'primary':
      return '#BAF2BB';
    case 'success':
      return '#E8F8E8';
    case 'danger':
      return '#FFE5E5';
    case 'info':
      return '#E5F2FF';
    case 'warning':
      return '#FFF9E5';
    default:
      return '#BAF2BB';
  }
};

const getTextColor = (variant: ButtonVariant, isPressed: boolean, isDisabled: boolean): string => {
  if (isDisabled) {
    switch (variant) {
      case 'primary':
        return '#666666';
      case 'success':
        return '#34C75980';
      case 'danger':
        return '#FF3B3080';
      case 'info':
        return '#007AFF80';
      case 'warning':
        return '#FFCC0080';
      default:
        return '#666666';
    }
  }

  if (isPressed) {
    return '#FFFFFF';
  }

  switch (variant) {
    case 'primary':
      return '#000000';
    case 'success':
      return '#34C759';
    case 'danger':
      return '#FF3B30';
    case 'info':
      return '#007AFF';
    case 'warning':
      return '#FFCC00';
    default:
      return '#000000';
  }
};

const getFontSize = (size: ButtonSize): number => {
  switch (size) {
    case 'small':
      return 14;
    case 'large':
      return 18;
    default:
      return 16;
  }
};

export const Button = React.forwardRef<React.ElementRef<typeof StyledButton>, ButtonProps>(
  ({ variant = 'primary', size = 'medium', loading = false, disabled = false, children, ...props }, ref) => {
    const [isPressed, setIsPressed] = React.useState(false);
    const isDisabled = disabled || loading;

    const handlePressIn = React.useCallback(() => {
      if (!isDisabled) {
        setIsPressed(true);
      }
    }, [isDisabled]);

    const handlePressOut = React.useCallback(() => {
      if (!isDisabled) {
        setIsPressed(false);
      }
    }, [isDisabled]);

    return (
      <StyledButton
        {...props}
        variant={variant}
        size={size}
        ref={ref}
        disabled={isDisabled}
        backgroundColor={getBackgroundColor(variant, isPressed, isDisabled)}
        opacity={1}
        pressStyle={isDisabled ? undefined : {
          scale: 0.98,
          opacity: 0.9,
        }}
        onPressIn={handlePressIn}
        onPressOut={handlePressOut}
        animation="quick"
      >
        {loading && (
          <Spinner
            size={getSpinnerSize(size)}
            color={getTextColor(variant, isPressed, isDisabled)}
          />
        )}
        {typeof children === 'string' ? (
          <Text
            color={getTextColor(variant, isPressed, isDisabled)}
            fontSize={getFontSize(size)}
            fontWeight="600"
            textAlign="center"
            opacity={loading ? 0.8 : 1}
            animation="quick"
          >
            {children}
          </Text>
        ) : (
          children
        )}
      </StyledButton>
    );
  }
);
