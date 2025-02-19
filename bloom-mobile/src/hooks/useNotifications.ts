import { useState, useEffect, useCallback } from 'react';
import * as Notifications from 'expo-notifications';
import { useAuth } from './useAuth';
import {
  registerForPushNotifications,
  savePushToken,
  getNotifications,
  markNotificationAsRead,
  subscribeToMatchNotifications,
  subscribeToMessageNotifications,
  subscribeToDateReminders,
} from '../services/notifications';
import type { Notification } from '../types/database';

interface UseNotificationsResult {
  notifications: Notification[];
  unreadCount: number;
  loading: boolean;
  error: string | null;
  markAsRead: (notificationId: string) => Promise<void>;
  refreshNotifications: () => Promise<void>;
}

export function useNotifications(): UseNotificationsResult {
  const { user } = useAuth();
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Load notifications
  const loadNotifications = useCallback(async () => {
    if (!user) return;

    try {
      setLoading(true);
      const data = await getNotifications(user.id);
      setNotifications(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load notifications');
    } finally {
      setLoading(false);
    }
  }, [user]);

  // Register for push notifications
  useEffect(() => {
    if (!user) return;

    let isMounted = true;

    const registerDevice = async () => {
      try {
        const token = await registerForPushNotifications();
        if (token && isMounted) {
          await savePushToken(token, user.id);
        }
      } catch (err) {
        if (isMounted) {
          setError(err instanceof Error ? err.message : 'Failed to register for notifications');
        }
      }
    };

    registerDevice();

    return () => {
      isMounted = false;
    };
  }, [user]);

  // Subscribe to notifications
  useEffect(() => {
    if (!user) return;

    const matchSubscription = subscribeToMatchNotifications(
      async (notification) => {
        await loadNotifications();
      }
    );

    const messageSubscription = subscribeToMessageNotifications(
      async (notification) => {
        await loadNotifications();
      }
    );

    const reminderSubscription = subscribeToDateReminders(
      async (notification) => {
        await loadNotifications();
      }
    );

    // Handle notification response when app is in background
    const responseSubscription = Notifications.addNotificationResponseReceivedListener(
      async (response) => {
        const notificationId = response.notification.request.content.data?.notificationId;
        if (notificationId) {
          await markAsRead(notificationId);
        }
      }
    );

    // Initial load
    loadNotifications();

    return () => {
      matchSubscription.remove();
      messageSubscription.remove();
      reminderSubscription.remove();
      responseSubscription.remove();
    };
  }, [user, loadNotifications]);

  const markAsRead = useCallback(async (notificationId: string) => {
    try {
      await markNotificationAsRead(notificationId);
      setNotifications((prev) =>
        prev.map((notification) =>
          notification.id === notificationId
            ? { ...notification, read: true }
            : notification
        )
      );
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to mark notification as read');
    }
  }, []);

  const unreadCount = notifications.filter((n) => !n.read).length;

  return {
    notifications,
    unreadCount,
    loading,
    error,
    markAsRead,
    refreshNotifications: loadNotifications,
  };
}
