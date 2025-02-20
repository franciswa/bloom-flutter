import * as Notifications from 'expo-notifications';
import * as Device from 'expo-device';
import { Platform } from 'react-native';
import { supabase } from '../lib/supabase';
import { Notification, PushToken } from '../types/database';

// Configure notification behavior
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true,
  }),
});

export async function registerForPushNotifications(): Promise<string | null> {
  if (!Device.isDevice) {
    throw new Error('Push Notifications are only supported on physical devices');
  }

  // Check permissions
  const { status: existingStatus } = await Notifications.getPermissionsAsync();
  let finalStatus = existingStatus;

  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync();
    finalStatus = status;
  }

  if (finalStatus !== 'granted') {
    throw new Error('Permission to receive push notifications was denied');
  }

  // Get push token
  const { data: token } = await Notifications.getExpoPushTokenAsync({
    projectId: process.env.EXPO_PROJECT_ID,
  });

  // Configure for Android
  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('default', {
      name: 'default',
      importance: Notifications.AndroidImportance.MAX,
      vibrationPattern: [0, 250, 250, 250],
      lightColor: '#FF8FB1',
    });
  }

  return token;
}

export async function savePushToken(token: string, userId: string): Promise<void> {
  try {
    const { error } = await supabase.from('push_tokens').upsert({
      user_id: userId,
      token,
      device_id: Device.deviceName || 'unknown',
      platform: Platform.OS,
      is_valid: true,
      last_used: new Date().toISOString(),
    });
    
    if (error) throw error;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to save push token');
  }
}

export async function sendPushNotification(
  token: string,
  title: string,
  body: string,
  data?: Record<string, string>
): Promise<void> {
  const message = {
    to: token,
    sound: 'default',
    title,
    body,
    data,
  };

  await fetch('https://exp.host/--/api/v2/push/send', {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      'Accept-encoding': 'gzip, deflate',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(message),
  });
}

export async function getNotifications(userId: string): Promise<Notification[]> {
  try {
    const { data, error } = await supabase
      .from('notifications')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .limit(50);

    if (error) throw error;
    return data || [];
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to fetch notifications');
  }
}

export async function markNotificationAsRead(notificationId: string): Promise<void> {
  try {
    const { error } = await supabase
      .from('notifications')
      .update({ 
        read: true,
        updated_at: new Date().toISOString()
      })
      .eq('id', notificationId);

    if (error) throw error;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to mark notification as read');
  }
}

// Subscribe to real-time notifications
export function subscribeToMatchNotifications(
  onNotification: (notification: Notification) => void
): { remove: () => void } {
  const channel = supabase
    .channel('match_notifications')
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'notifications',
        filter: 'type=eq.match',
      },
      (payload) => {
        const notification = payload.new as Notification;
        onNotification(notification);
      }
    )
    .subscribe();

  return {
    remove: () => {
      channel.unsubscribe();
    },
  };
}

export function subscribeToMessageNotifications(
  onNotification: (notification: Notification) => void
): { remove: () => void } {
  const channel = supabase
    .channel('message_notifications')
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'notifications',
        filter: 'type=eq.message',
      },
      (payload) => {
        const notification = payload.new as Notification;
        onNotification(notification);
      }
    )
    .subscribe();

  return {
    remove: () => {
      channel.unsubscribe();
    },
  };
}

export function subscribeToDateReminders(
  onNotification: (notification: Notification) => void
): { remove: () => void } {
  const channel = supabase
    .channel('date_reminders')
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'notifications',
        filter: 'type=eq.date_reminder',
      },
      (payload) => {
        const notification = payload.new as Notification;
        onNotification(notification);
      }
    )
    .subscribe();

  return {
    remove: () => {
      channel.unsubscribe();
    },
  };
}

export async function deleteNotification(notificationId: string): Promise<void> {
  try {
    const { error } = await supabase
      .from('notifications')
      .delete()
      .eq('id', notificationId);

    if (error) throw error;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to delete notification');
  }
}

export async function clearAllNotifications(userId: string): Promise<void> {
  try {
    const { error } = await supabase
      .from('notifications')
      .delete()
      .eq('user_id', userId);

    if (error) throw error;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to clear notifications');
  }
}

export async function getUnreadNotificationCount(userId: string): Promise<number> {
  try {
    const { count, error } = await supabase
      .from('notifications')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId)
      .eq('read', false);

    if (error) throw error;
    return count || 0;
  } catch (err) {
    throw new Error(err instanceof Error ? err.message : 'Failed to get unread notification count');
  }
}
