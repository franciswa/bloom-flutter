import React from 'react';
import { Alert, FlatList } from 'react-native';
import {
  YStack,
  XStack,
  Text,
  H1,
  Button,
  Card,
  styled,
  Stack,
  ListItem,
} from 'tamagui';
import { Ionicons } from '@expo/vector-icons';
import { useNotifications } from '../hooks/useNotifications';
import { Notification } from '../types/database';
import { useNavigation } from '@react-navigation/native';
import { NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../types/navigation';

type NotificationsScreenNavigationProp = NavigationProp<RootStackParamList>;

const MainContainer = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
});

const Header = styled(XStack, {
  justifyContent: 'space-between',
  alignItems: 'center',
  paddingHorizontal: '$4',
  paddingVertical: '$5',
});

const HeaderTitle = styled(H1, {
  color: '$text',
  fontFamily: '$heading',
});

const MarkAllButton = styled(Button, {
  backgroundColor: 'transparent',
  color: '$primary',
});

const NotificationCard = styled(Card, {
  marginBottom: '$2',
  padding: '$4',
  
  variants: {
    read: {
      true: {
        backgroundColor: '$backgroundStrong',
      },
      false: {
        backgroundColor: '$backgroundHover',
      },
    },
  },
  pressStyle: {
    opacity: 0.8,
  },
});

const NotificationHeader = styled(XStack, {
  justifyContent: 'space-between',
  alignItems: 'center',
  marginBottom: '$1',
});

const NotificationTitle = styled(Text, {
  fontSize: '$4',
  fontWeight: 'bold',
  color: '$text',
  flex: 1,
  fontFamily: '$body',
});

const NotificationTime = styled(Text, {
  fontSize: '$2',
  color: '$gray10',
  marginLeft: '$2',
  fontFamily: '$body',
});

const NotificationMessage = styled(Text, {
  fontSize: '$3',
  lineHeight: 20,
  color: '$text',
  fontFamily: '$body',
});

const DeleteButton = styled(Button, {
  backgroundColor: 'transparent',
  padding: '$2',
  marginLeft: '$2',
});

const EmptyState = styled(Card, {
  margin: '$4',
  padding: '$8',
  backgroundColor: '$backgroundStrong',
  alignItems: 'center',
});

const EmptyText = styled(Text, {
  fontSize: '$4',
  marginTop: '$4',
  textAlign: 'center',
  color: '$text',
  fontFamily: '$body',
});

const LoadingContainer = styled(YStack, {
  flex: 1,
  justifyContent: 'center',
  alignItems: 'center',
  backgroundColor: '$background',
});

const LoadingText = styled(Text, {
  fontSize: '$4',
  color: '$text',
  fontFamily: '$body',
});

const ErrorText = styled(Text, {
  fontSize: '$4',
  color: '$red10',
  textAlign: 'center',
  fontFamily: '$body',
});

export default function NotificationsScreen() {
  const navigation = useNavigation<NotificationsScreenNavigationProp>();
  const {
    notifications,
    loading,
    error,
    markAsRead,
    markAllAsRead,
    deleteNotification,
  } = useNotifications();

  const handleNotificationPress = async (notification: Notification) => {
    if (!notification.read) {
      await markAsRead(notification.id);
    }

    // Navigate based on notification type and data
    if (notification.data) {
      switch (notification.type) {
        case 'match':
          if (notification.data.match_id) {
            navigation.navigate('Chat', { matchId: notification.data.match_id });
          }
          break;
        case 'message':
          if (notification.data.match_id) {
            navigation.navigate('Chat', { matchId: notification.data.match_id });
          }
          break;
        case 'date_reminder':
          if (notification.data.date_preference_id) {
            navigation.navigate('Date');
          }
          break;
      }
    }
  };

  const handleDelete = (notification: Notification) => {
    Alert.alert(
      'Delete Notification',
      'Are you sure you want to delete this notification?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: () => deleteNotification(notification.id),
        },
      ]
    );
  };

  const renderNotification = ({ item: notification }: { item: Notification }) => (
    <NotificationCard
      read={notification.read}
      onPress={() => handleNotificationPress(notification)}
      elevate
    >
      <XStack>
        <YStack flex={1}>
          <NotificationHeader>
            <NotificationTitle>{notification.title}</NotificationTitle>
            <NotificationTime>
              {new Date(notification.created_at).toLocaleTimeString([], {
                hour: '2-digit',
                minute: '2-digit',
              })}
            </NotificationTime>
          </NotificationHeader>
          <NotificationMessage>{notification.message}</NotificationMessage>
        </YStack>
        <DeleteButton onPress={() => handleDelete(notification)}>
          <Ionicons name="trash-outline" size={24} color="$red10" />
        </DeleteButton>
      </XStack>
    </NotificationCard>
  );

  if (loading) {
    return (
      <LoadingContainer>
        <LoadingText>Loading...</LoadingText>
      </LoadingContainer>
    );
  }

  if (error) {
    return (
      <LoadingContainer>
        <ErrorText>{error}</ErrorText>
      </LoadingContainer>
    );
  }

  return (
    <MainContainer>
      <Header>
        <HeaderTitle>Notifications</HeaderTitle>
        {notifications.length > 0 && (
          <MarkAllButton onPress={markAllAsRead}>
            Mark All Read
          </MarkAllButton>
        )}
      </Header>

      {notifications.length === 0 ? (
        <EmptyState elevate>
          <Ionicons name="notifications-outline" size={48} color="$primary" />
          <EmptyText>
            No notifications yet
          </EmptyText>
        </EmptyState>
      ) : (
        <FlatList
          data={notifications}
          renderItem={renderNotification}
          keyExtractor={item => item.id}
          contentContainerStyle={{ padding: 16 }}
          showsVerticalScrollIndicator={false}
        />
      )}
    </MainContainer>
  );
}
