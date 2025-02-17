import AsyncStorage from '@react-native-async-storage/async-storage';
import { Platform } from 'react-native';

const DEVICE_ID_KEY = '@bloom:device_id';

export async function getDeviceId(): Promise<string> {
  let deviceId = await AsyncStorage.getItem(DEVICE_ID_KEY);
  
  if (!deviceId) {
    // Generate a random device ID if none exists
    deviceId = `${Platform.OS}_${Date.now()}_${Math.random().toString(36).slice(2)}`;
    await AsyncStorage.setItem(DEVICE_ID_KEY, deviceId);
  }
  
  return deviceId;
}
