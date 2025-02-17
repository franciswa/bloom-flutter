import { useState, useEffect, useCallback } from 'react';
import { Platform } from 'react-native';
import * as Notifications from 'expo-notifications';
import { getDeviceId } from '../utils/deviceId';
import { supabase } from '../lib/supabaseClient';
import { Notification, PushToken } from '../types/database';
import { AppError, ErrorCodes, withErrorHandling } from '../utils/errorHandling';

export interface UseNotificationsResult {
  notifications: Notification[];
  unreadCount: number;
  loading: boolean;
  error: string | null;
  markAsRead: (notificationId: string) => Promise<void>;
  markAllAsRead: () => Promise<void>;
  deleteNotification: (notificationId: string) => Promise<void>;
  requestPermissions: () => Promise<boolean>;
}

export function useNotifications(): UseNotificationsResult {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchNotifications = useCallback(
    withErrorHandling(async () => {
      const { user } = await supabase.auth.getUser();
      if (!user) throw new AppError('No user found', ErrorCodes.AUTHENTICATION);

      const data = await supabase.select<'notifications'>(
        'notifications',
        '*',
        'Notifications.Fetch'
      );

      setNotifications(data);
      setError(null);
      setLoading(false);
    }, 'Notifications.Fetch'),
    []
  );

  const markAsRead = useCallback(
    withErrorHandling(async (notificationId: string) => {
      await supabase.update<'notifications'>(
        'notifications',
        { id: notificationId },
        { read: true },
        'Notifications.MarkAsRead'
      );

      setNotifications(prev =>
        prev.map(notification =>
          notification.id === notificationId
            ? { ...notification, read: true }
            : notification
        )
      );
    }, 'Notifications.MarkAsRead'),
    []
  );

  const markAllAsRead = useCallback(
    withErrorHandling(async () => {
      const { user } = await supabase.auth.getUser();
      if (!user) throw new AppError('No user found', ErrorCodes.AUTHENTICATION);

      await supabase.update<'notifications'>(
        'notifications',
        { user_id: user.id, read: false },
        { read: true },
        'Notifications.MarkAllAsRead'
      );

      setNotifications(prev =>
        prev.map(notification => ({ ...notification, read: true }))
      );
    }, 'Notifications.MarkAllAsRead'),
    []
  );

  const deleteNotification = useCallback(
    withErrorHandling(async (notificationId: string) => {
      await supabase.delete<'notifications'>(
        'notifications',
        { id: notificationId },
        'Notifications.Delete'
      );

      setNotifications(prev =>
        prev.filter(notification => notification.id !== notificationId)
      );
    }, 'Notifications.Delete'),
    []
  );

  const registerPushToken = useCallback(
    withErrorHandling(async (token: string) => {
      const { user } = await supabase.auth.getUser();
      if (!user) throw new AppError('No user found', ErrorCodes.AUTHENTICATION);

      const deviceId = await getDeviceId();
      const platform = Platform.OS as PushToken['platform'];

      // First invalidate any existing tokens for this device
      await supabase.update<'push_tokens'>(
        'push_tokens',
        { device_id: deviceId, is_valid: true },
        { is_valid: false },
        'PushToken.Invalidate'
      );

      // Then insert the new token
      await supabase.insert<'push_tokens'>(
        'push_tokens',
        {
          user_id: user.id,
          token,
          device_id: deviceId,
          platform,
          is_valid: true,
        },
        'PushToken.Register'
      );
    }, 'PushToken.Register'),
    []
  );

  const requestPermissions = useCallback(
    withErrorHandling(async () => {
      if (Platform.OS === 'web') return false;

      const { status: existingStatus } = await Notifications.getPermissionsAsync();
      let finalStatus = existingStatus;

      if (existingStatus !== 'granted') {
        const { status } = await Notifications.requestPermissionsAsync();
        finalStatus = status;
      }

      if (finalStatus !== 'granted') {
        throw new AppError(
          'Permission to receive notifications was denied',
          ErrorCodes.PUSH_NOTIFICATION
        );
      }

      // Get push token
      const { data: token } = await Notifications.getExpoPushTokenAsync({
        projectId: process.env.EXPO_PROJECT_ID,
      });

      // Store token in database
      await registerPushToken(token);

      return true;
    }, 'Notifications.RequestPermissions'),
    [registerPushToken]
  );

  // Subscribe to notification changes
  useEffect(() => {
    const setupSubscription = async () => {
      const { user } = await supabase.auth.getUser();
      if (!user) return;

      const subscription = supabase
        .channel('notifications_changes')
        .on(
          'postgres_changes',
          {
            event: '*',
            schema: 'public',
            table: 'notifications',
            filter: `user_id=eq.${user.id}`,
          },
          async () => {
            await fetchNotifications();
          }
        )
        .subscribe();

      return () => {
        subscription.unsubscribe();
      };
    };

    setupSubscription();
  }, [fetchNotifications]);

  // Initial fetch
  useEffect(() => {
    fetchNotifications();
  }, [fetchNotifications]);

  // Configure notification handler
  useEffect(() => {
    if (Platform.OS === 'web') return;

    Notifications.setNotificationHandler({
      handleNotification: async () => ({
        shouldShowAlert: true,
        shouldPlaySound: true,
        shouldSetBadge: true,
      }),
    });

    // Listen for incoming notifications when app is foregrounded
    const subscription = Notifications.addNotificationReceivedListener(notification => {
      fetchNotifications();
    });

    return () => {
      subscription.remove();
    };
  }, [fetchNotifications]);

  const unreadCount = notifications.filter(n => !n.read).length;

  return {
    notifications,
    unreadCount,
    loading,
    error,
    markAsRead,
    markAllAsRead,
    deleteNotification,
    requestPermissions,
  };
}
