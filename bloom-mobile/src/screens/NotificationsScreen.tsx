import React from 'react';
import { View, FlatList, RefreshControl } from 'react-native';
import { YStack, Text, Card, XStack, Spinner, AlertDialog } from 'tamagui';
import { useNotifications } from '../hooks/useNotifications';
import { MainScreenProps } from '../types/navigation';
import { formatDistanceToNow } from 'date-fns';
import { Notification } from '../types/database';
import { Button } from '../components/Button';

type Props = MainScreenProps<'Notifications'>;

export default function NotificationsScreen({ navigation }: Props) {
  const {
    notifications,
    loading,
    error,
    loadNotifications,
    markAsRead,
    markAllRead,
    remove,
    clearAll,
  } = useNotifications();

  const [loadingStates, setLoadingStates] = React.useState<{
    markingRead: string | null;
    removing: string | null;
    markingAllRead: boolean;
    clearing: boolean;
    retrying: boolean;
    confirmingDelete: boolean;
  }>({
    markingRead: null,
    removing: null,
    markingAllRead: false,
    clearing: false,
    retrying: false,
    confirmingDelete: false,
  });

  const [deleteConfirmation, setDeleteConfirmation] = React.useState<{
    open: boolean;
    notificationId: string | null;
    isAll: boolean;
  }>({
    open: false,
    notificationId: null,
    isAll: false,
  });

  const handleMarkAsRead = async (id: string) => {
    setLoadingStates(prev => ({ ...prev, markingRead: id }));
    try {
      await markAsRead(id);
    } finally {
      setLoadingStates(prev => ({ ...prev, markingRead: null }));
    }
  };

  const handleRemove = async (id: string) => {
    setLoadingStates(prev => ({ ...prev, removing: id }));
    try {
      await remove(id);
    } finally {
      setLoadingStates(prev => ({ ...prev, removing: null }));
    }
  };

  const handleMarkAllRead = async () => {
    setLoadingStates(prev => ({ ...prev, markingAllRead: true }));
    try {
      await markAllRead();
    } finally {
      setLoadingStates(prev => ({ ...prev, markingAllRead: false }));
    }
  };

  const handleClearAll = async () => {
    setLoadingStates(prev => ({ ...prev, clearing: true }));
    try {
      await clearAll();
    } finally {
      setLoadingStates(prev => ({ ...prev, clearing: false }));
    }
  };

  const handleRetry = async () => {
    setLoadingStates(prev => ({ ...prev, retrying: true }));
    try {
      await loadNotifications();
    } finally {
      setLoadingStates(prev => ({ ...prev, retrying: false }));
    }
  };

  const handleConfirmDelete = async () => {
    setLoadingStates(prev => ({ ...prev, confirmingDelete: true }));
    try {
      if (deleteConfirmation.isAll) {
        await handleClearAll();
      } else if (deleteConfirmation.notificationId) {
        await handleRemove(deleteConfirmation.notificationId);
      }
    } finally {
      setLoadingStates(prev => ({ ...prev, confirmingDelete: false }));
      setDeleteConfirmation({ open: false, notificationId: null, isAll: false });
    }
  };

  const renderNotification = ({ item }: { item: Notification }) => (
    <Card
      bordered
      elevate
      marginHorizontal="$4"
      marginVertical="$2"
      padding="$4"
      animation="bouncy"
      scale={1}
      hoverStyle={{ scale: 1.02 }}
      pressStyle={{ scale: 0.97 }}
      onPress={() => {
        if (!item.read_at) {
          handleMarkAsRead(item.id);
        }
        if (item.action_url) {
          // Handle navigation based on action_url
          // TODO: Implement deep linking
        }
      }}
      backgroundColor={item.read_at ? '$backgroundHover' : '$background'}
    >
      <YStack space="$2">
        <XStack justifyContent="space-between" alignItems="center">
          <Text
            fontFamily="$heading"
            fontSize="$5"
            opacity={item.read_at ? 0.6 : 1}
            animation="quick"
          >
            {item.title}
          </Text>
          <Text
            color="$colorHover"
            fontSize="$2"
            opacity={item.read_at ? 0.6 : 0.8}
            animation="quick"
          >
            {formatDistanceToNow(new Date(item.created_at), { addSuffix: true })}
          </Text>
        </XStack>

        <Text
          fontSize="$4"
          opacity={item.read_at ? 0.6 : 1}
          animation="quick"
        >
          {item.message}
        </Text>

        <XStack space="$2" justifyContent="flex-end" marginTop="$2">
          {!item.read_at && (
            <Button
              size="small"
              variant="success"
              onPress={() => handleMarkAsRead(item.id)}
              loading={loadingStates.markingRead === item.id}
            >
              Mark as Read
            </Button>
          )}
          <Button
            size="small"
            variant="danger"
            onPress={() => setDeleteConfirmation({ open: true, notificationId: item.id, isAll: false })}
            loading={loadingStates.removing === item.id}
          >
            Delete
          </Button>
        </XStack>
      </YStack>
    </Card>
  );

  if (error) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 }}>
        <Text color="$danger" fontSize="$5" textAlign="center" marginBottom="$4">
          {error}
        </Text>
        <Button
          variant="info"
          onPress={handleRetry}
          loading={loadingStates.retrying}
          size="medium"
        >
          Retry
        </Button>
      </View>
    );
  }

  const renderEmptyComponent = () => {
    if (loading) {
      return (
        <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 }}>
          <Spinner size="large" color="$color" />
          <Text color="$colorHover" fontSize="$4" textAlign="center" marginTop="$4">
            Loading notifications...
          </Text>
        </View>
      );
    }

    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 }}>
        <Text color="$colorHover" fontSize="$4" textAlign="center">
          No notifications yet
        </Text>
        <Button
          variant="info"
          onPress={loadNotifications}
          size="small"
          marginTop="$4"
        >
          Refresh
        </Button>
      </View>
    );
  };

  return (
    <View style={{ flex: 1 }}>
      <YStack padding="$4" space="$4">
        <XStack justifyContent="space-between" alignItems="center">
          <Text fontFamily="$heading" fontSize="$6">
            Notifications
          </Text>
          <XStack space="$2">
            <Button
              size="small"
              variant="success"
              onPress={handleMarkAllRead}
              disabled={notifications.every(n => n.read_at)}
              loading={loadingStates.markingAllRead}
            >
              Mark All Read
            </Button>
            <Button
              size="small"
              variant="danger"
              onPress={() => setDeleteConfirmation({ open: true, notificationId: null, isAll: true })}
              disabled={notifications.length === 0}
              loading={loadingStates.clearing}
            >
              Clear All
            </Button>
          </XStack>
        </XStack>
      </YStack>

      <FlatList
        data={notifications}
        renderItem={renderNotification}
        keyExtractor={(item) => item.id}
        contentContainerStyle={[
          { paddingBottom: 20 },
          notifications.length === 0 && { flex: 1 }
        ]}
        refreshControl={
          <RefreshControl
            refreshing={loading}
            onRefresh={loadNotifications}
            tintColor="#666666"
          />
        }
        ListEmptyComponent={renderEmptyComponent}
      />

      <AlertDialog
        native
        open={deleteConfirmation.open}
        onOpenChange={(open) => {
          if (!open) {
            setDeleteConfirmation({ open: false, notificationId: null, isAll: false });
          }
        }}
      >
        <AlertDialog.Portal>
          <AlertDialog.Overlay
            key="overlay"
            animation="quick"
            opacity={0.5}
            enterStyle={{ opacity: 0 }}
            exitStyle={{ opacity: 0 }}
          />
          <AlertDialog.Content
            bordered
            elevate
            key="content"
            animation={[
              'quick',
              {
                opacity: {
                  overshootClamping: true,
                },
              },
            ]}
            enterStyle={{ x: 0, y: -20, opacity: 0, scale: 0.9 }}
            exitStyle={{ x: 0, y: 10, opacity: 0, scale: 0.95 }}
            x={0}
            scale={1}
            opacity={1}
            y={0}
            backgroundColor="$background"
            padding="$4"
          >
            <YStack space="$4">
              <AlertDialog.Title>
                <Text fontFamily="$heading" fontSize="$6" textAlign="center">
                  {deleteConfirmation.isAll ? 'Clear All Notifications' : 'Delete Notification'}
                </Text>
              </AlertDialog.Title>
              <AlertDialog.Description>
                <Text fontSize="$4" textAlign="center" color="$colorHover">
                  {deleteConfirmation.isAll
                    ? 'Are you sure you want to delete all notifications? This action cannot be undone.'
                    : 'Are you sure you want to delete this notification? This action cannot be undone.'}
                </Text>
              </AlertDialog.Description>

              <XStack space="$3" justifyContent="center" marginTop="$2">
                <Button
                  variant="info"
                  size="medium"
                  onPress={() => setDeleteConfirmation({ open: false, notificationId: null, isAll: false })}
                  disabled={loadingStates.confirmingDelete}
                >
                  Cancel
                </Button>
                <Button
                  variant="danger"
                  size="medium"
                  onPress={handleConfirmDelete}
                  loading={loadingStates.confirmingDelete}
                >
                  Delete
                </Button>
              </XStack>
            </YStack>
          </AlertDialog.Content>
        </AlertDialog.Portal>
      </AlertDialog>
    </View>
  );
}
