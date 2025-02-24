import React from 'react';
import { Text, styled, Stack } from 'tamagui';

interface NotificationBadgeProps {
  count: number;
  size?: 'small' | 'large';
}

const Badge = styled(Stack, {
  position: 'absolute',
  top: -6,
  right: -6,
  backgroundColor: '$primary',
  justifyContent: 'center',
  alignItems: 'center',
  paddingHorizontal: '$1',
  
  variants: {
    size: {
      small: {
        minWidth: 18,
        height: 18,
        borderRadius: 9,
      },
      large: {
        minWidth: 24,
        height: 24,
        borderRadius: 12,
      },
    },
  } as const,
});

const BadgeText = styled(Text, {
  color: 'white',
  fontWeight: 'bold',
  textAlign: 'center',
  fontFamily: '$body',
  
  variants: {
    size: {
      small: {
        fontSize: '$1',
        lineHeight: 16,
      },
      large: {
        fontSize: '$2',
        lineHeight: 20,
      },
    },
  } as const,
});

export default function NotificationBadge({ count, size = 'small' }: NotificationBadgeProps) {
  if (count === 0) return null;

  const displayCount = count > 99 ? '99+' : count.toString();

  return (
    <Badge size={size}>
      <BadgeText size={size}>
        {displayCount}
      </BadgeText>
    </Badge>
  );
}
