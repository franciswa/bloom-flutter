import React from 'react';
import {
  YStack,
  Text,
  H1,
  ScrollView,
  Card,
  styled,
} from 'tamagui';
import { StyledButton } from '../theme/components';
import { RefreshControl } from 'react-native';
import { useNotifications } from '../hooks/useNotifications';
import { formatDistanceToNow } from 'date-fns';

const Container = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
});

const Header = styled(YStack, {
  paddingHorizontal: '$4',
  paddingVertical: '$5',
});

const HeaderTitle = styled(H1, {
  color: '$text',
  fontFamily: '$heading',
});

const NotificationCard = styled(Card, {
  marginHorizontal: '$4',
  marginBottom: '$3',
  padding: '$4',
  backgroundColor: '$backgroundStrong',
  variants: {
  unread: {
    true: {
      borderLeftColor: '$secondary',
      borderLeftWidth: 4,
    },
  },
  },
});

const NotificationTitle = styled(Text, {
  fontSize: '$5',
  fontWeight: 'bold',
  color: '$text',
  marginBottom: '$1',
});

const NotificationMessage = styled(Text, {
  fontSize: '$4',
  color: '$gray11',
  marginBottom: '$2',
});

const NotificationTime = styled(Text, {
  fontSize: '$3',
  color: '$gray10',
});

const EmptyState = styled(YStack, {
  flex: 1,
  justifyContent: 'center',
  alignItems: 'center',
  padding: '$6',
});

const EmptyStateText = styled(Text, {
  fontSize: '$5',
  color: '$gray11',
  textAlign: 'center',
  marginBottom: '$4',
});

export default function NotificationsScreen() {
  const {
    notifications,
    loading,
    error,
    markAsRead,
    refreshNotifications,
  } = useNotifications();

  const handleNotificationPress = async (notificationId: string) => {
    await markAsRead(notificationId);
    // TODO: Navigate to relevant screen based on notification type
  };

  if (error) {
    return (
      <EmptyState>
        <EmptyStateText>Failed to load notifications</EmptyStateText>
        <StyledButton variant="primary" onPress={refreshNotifications}>
          Try Again
        </StyledButton>
      </EmptyState>
    );
  }

  return (
    <Container>
      <Header>
        <HeaderTitle>Notifications</HeaderTitle>
      </Header>

      <ScrollView
        refreshControl={
          <RefreshControl
            refreshing={loading}
            onRefresh={refreshNotifications}
          />
        }
      >
        {notifications.length === 0 ? (
          <EmptyState>
            <EmptyStateText>
              You don't have any notifications yet
            </EmptyStateText>
          </EmptyState>
        ) : (
          notifications.map((notification) => (
            <NotificationCard
              key={notification.id}
              unread={!notification.read}
              pressStyle={{ scale: 0.98 }}
              onPress={() => handleNotificationPress(notification.id)}
            >
              <NotificationTitle>{notification.title}</NotificationTitle>
              <NotificationMessage>{notification.message}</NotificationMessage>
              <NotificationTime>
                {formatDistanceToNow(new Date(notification.created_at), {
                  addSuffix: true,
                })}
              </NotificationTime>
            </NotificationCard>
          ))
        )}
      </ScrollView>
    </Container>
  );
}
