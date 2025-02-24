import * as SecureStore from 'expo-secure-store';
import { Platform } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

/**
 * Cross-platform secure storage utility
 * Uses SecureStore on native platforms and AsyncStorage with encryption on web
 */
class SecureStorage {
  private prefix: string;
  private isNative: boolean;

  constructor(prefix: string = 'bloom_secure_') {
    this.prefix = prefix;
    this.isNative = Platform.OS !== 'web';
  }

  /**
   * Saves a value securely
   * @param key Storage key
   * @param value Value to store
   * @returns Promise resolving when storage is complete
   */
  async setItem(key: string, value: string): Promise<void> {
    const prefixedKey = this.prefix + key;
    
    if (this.isNative) {
      // Use SecureStore on native platforms
      return SecureStore.setItemAsync(prefixedKey, value);
    } else {
      // On web, we need to encrypt the data before storing
      // For this example, we're just base64 encoding, but in production
      // a more robust encryption would be needed
      const encodedValue = btoa(value);
      return AsyncStorage.setItem(prefixedKey, encodedValue);
    }
  }

  /**
   * Retrieves a securely stored value
   * @param key Storage key
   * @returns Promise resolving to the stored value or null if not found
   */
  async getItem(key: string): Promise<string | null> {
    const prefixedKey = this.prefix + key;
    
    if (this.isNative) {
      // Use SecureStore on native platforms
      return SecureStore.getItemAsync(prefixedKey);
    } else {
      // On web, we need to decrypt the data after retrieving
      const encodedValue = await AsyncStorage.getItem(prefixedKey);
      if (encodedValue === null) return null;
      
      try {
        return atob(encodedValue);
      } catch (e) {
        console.error('Error decoding secure storage value:', e);
        return null;
      }
    }
  }

  /**
   * Deletes a securely stored value
   * @param key Storage key
   * @returns Promise resolving when deletion is complete
   */
  async removeItem(key: string): Promise<void> {
    const prefixedKey = this.prefix + key;
    
    if (this.isNative) {
      // Use SecureStore on native platforms
      return SecureStore.deleteItemAsync(prefixedKey);
    } else {
      // Use AsyncStorage on web
      return AsyncStorage.removeItem(prefixedKey);
    }
  }

  /**
   * Stores a JSON object securely
   * @param key Storage key
   * @param value Object to store
   * @returns Promise resolving when storage is complete
   */
  async setObject<T>(key: string, value: T): Promise<void> {
    try {
      const jsonValue = JSON.stringify(value);
      return this.setItem(key, jsonValue);
    } catch (e) {
      console.error('Error storing object in secure storage:', e);
      throw e;
    }
  }

  /**
   * Retrieves a JSON object from secure storage
   * @param key Storage key
   * @returns Promise resolving to the stored object or null if not found
   */
  async getObject<T>(key: string): Promise<T | null> {
    try {
      const jsonValue = await this.getItem(key);
      return jsonValue != null ? JSON.parse(jsonValue) as T : null;
    } catch (e) {
      console.error('Error retrieving object from secure storage:', e);
      return null;
    }
  }
}

// Create a singleton instance
const secureStorage = new SecureStorage();

export default secureStorage;