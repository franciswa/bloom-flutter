import React, { createContext, useState, useCallback, useEffect, ReactNode } from 'react';
import { Platform } from 'react-native';
import * as ExpoNotifications from 'expo-notifications';
import { Notification } from '../types/database';
import { useAuth } from './useAuth';
import {
  registerForPushNotifications,
  savePushToken,
  getUnreadNotifications,
  markNotificationAsRead,
  markAllNotificationsAsRead,
  deleteNotification,
  clearAllNotifications,
} from '../services/notifications';

ExpoNotifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true,
  }),
});

export interface NotificationsContextType {
  notifications: Notification[];
  loading: boolean;
  error: string | null;
  loadNotifications: () => Promise<void>;
  markAsRead: (notificationId: string) => Promise<void>;
  markAllRead: () => Promise<void>;
  remove: (notificationId: string) => Promise<void>;
  clearAll: () => Promise<void>;
}

interface NotificationsProviderProps {
  children: ReactNode;
}

export const NotificationsContext = createContext<NotificationsContextType | undefined>(undefined);

export function NotificationsProvider({ children }: NotificationsProviderProps) {
  const { user } = useAuth();
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const setupPushNotifications = useCallback(async () => {
    if (!user) return;

    try {
      const token = await registerForPushNotifications();
      if (token) {
        await savePushToken(user.id, token);
      }
    } catch (err) {
      console.error('Error setting up push notifications:', err);
    }
  }, [user]);

  const loadNotifications = useCallback(async () => {
    if (!user) return;

    try {
      setLoading(true);
      setError(null);
      const unreadNotifications = await getUnreadNotifications(user.id);
      setNotifications(unreadNotifications);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load notifications');
    } finally {
      setLoading(false);
    }
  }, [user]);

  const markAsRead = useCallback(async (notificationId: string) => {
    try {
      await markNotificationAsRead(notificationId);
      setNotifications(prev =>
        prev.map(n =>
          n.id === notificationId
            ? { ...n, read_at: new Date().toISOString() }
            : n
        )
      );
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to mark notification as read');
    }
  }, []);

  const markAllRead = useCallback(async () => {
    if (!user) return;

    try {
      await markAllNotificationsAsRead(user.id);
      setNotifications(prev =>
        prev.map(n => ({ ...n, read_at: new Date().toISOString() }))
      );
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to mark all notifications as read');
    }
  }, [user]);

  const remove = useCallback(async (notificationId: string) => {
    try {
      await deleteNotification(notificationId);
      setNotifications(prev => prev.filter(n => n.id !== notificationId));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to delete notification');
    }
  }, []);

  const clearAll = useCallback(async () => {
    if (!user) return;

    try {
      await clearAllNotifications(user.id);
      setNotifications([]);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to clear notifications');
    }
  }, [user]);

  useEffect(() => {
    if (user) {
      setupPushNotifications();
      loadNotifications();
    } else {
      setNotifications([]);
    }
  }, [user, setupPushNotifications, loadNotifications]);

  const value = {
    notifications,
    loading,
    error,
    loadNotifications,
    markAsRead,
    markAllRead,
    remove,
    clearAll,
  };

  return (
    <NotificationsContext.Provider value={value}>
      {children}
    </NotificationsContext.Provider>
  );
}
