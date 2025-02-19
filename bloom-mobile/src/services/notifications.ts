import * as Notifications from 'expo-notifications';
import * as Device from 'expo-device';
import { Platform } from 'react-native';
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
  // TODO: Save token to database
  // const { error } = await supabase.from('push_tokens').upsert({
  //   user_id: userId,
  //   token,
  //   device_id: Device.deviceName || 'unknown',
  //   platform: Platform.OS,
  //   is_valid: true,
  // });
  // if (error) throw error;
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
  // TODO: Fetch notifications from database
  // const { data, error } = await supabase
  //   .from('notifications')
  //   .select('*')
  //   .eq('user_id', userId)
  //   .order('created_at', { ascending: false });
  // if (error) throw error;
  // return data;

  // Mock data for now
  return [
    {
      id: '1',
      user_id: userId,
      type: 'match',
      title: 'New Match!',
      message: 'You have a new match waiting to connect',
      data: { match_id: '123' },
      read: false,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
  ];
}

export async function markNotificationAsRead(
  notificationId: string
): Promise<void> {
  // TODO: Update notification in database
  // const { error } = await supabase
  //   .from('notifications')
  //   .update({ read: true })
  //   .eq('id', notificationId);
  // if (error) throw error;
}

// Subscribe to push notifications for specific events
export function subscribeToMatchNotifications(
  onNotification: (notification: Notifications.Notification) => void
): Notifications.Subscription {
  return Notifications.addNotificationReceivedListener(onNotification);
}

export function subscribeToMessageNotifications(
  onNotification: (notification: Notifications.Notification) => void
): Notifications.Subscription {
  return Notifications.addNotificationReceivedListener(onNotification);
}

export function subscribeToDateReminders(
  onNotification: (notification: Notifications.Notification) => void
): Notifications.Subscription {
  return Notifications.addNotificationReceivedListener(onNotification);
}
