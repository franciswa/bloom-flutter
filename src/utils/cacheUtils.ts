import AsyncStorage from '@react-native-async-storage/async-storage';

/**
 * Cache entry with data and expiration time
 */
interface CacheEntry<T> {
  data: T;
  expiry: number;
}

/**
 * Cache options
 */
interface CacheOptions {
  /** Cache expiry time in milliseconds */
  expiryTime?: number;
  /** Whether to refresh the cache in the background */
  refreshInBackground?: boolean;
}

/**
 * Default cache options
 */
const DEFAULT_CACHE_OPTIONS: CacheOptions = {
  expiryTime: 24 * 60 * 60 * 1000, // 24 hours
  refreshInBackground: true
};

/**
 * In-memory cache for faster access
 */
const memoryCache: Record<string, CacheEntry<any>> = {};

/**
 * Check if a cache entry is valid
 * @param entry Cache entry to check
 * @returns True if the entry is valid, false otherwise
 */
function isCacheValid<T>(entry: CacheEntry<T> | null): boolean {
  if (!entry) return false;
  return Date.now() < entry.expiry;
}

/**
 * Get a value from the cache
 * @param key Cache key
 * @returns Cached value or null if not found or expired
 */
export async function getCachedValue<T>(key: string): Promise<T | null> {
  try {
    // Check memory cache first
    const memoryEntry = memoryCache[key];
    if (isCacheValid(memoryEntry)) {
      return memoryEntry.data;
    }
    
    // Check AsyncStorage if not in memory
    const storedValue = await AsyncStorage.getItem(key);
    if (!storedValue) return null;
    
    const entry = JSON.parse(storedValue) as CacheEntry<T>;
    if (!isCacheValid(entry)) {
      // Remove expired entry
      await AsyncStorage.removeItem(key);
      delete memoryCache[key];
      return null;
    }
    
    // Update memory cache
    memoryCache[key] = entry;
    
    return entry.data;
  } catch (error) {
    console.warn('Error getting cached value:', error);
    return null;
  }
}

/**
 * Set a value in the cache
 * @param key Cache key
 * @param value Value to cache
 * @param options Cache options
 */
export async function setCachedValue<T>(
  key: string,
  value: T,
  options: CacheOptions = {}
): Promise<void> {
  try {
    const { expiryTime } = { ...DEFAULT_CACHE_OPTIONS, ...options };
    
    const entry: CacheEntry<T> = {
      data: value,
      expiry: Date.now() + expiryTime!
    };
    
    // Update memory cache
    memoryCache[key] = entry;
    
    // Update AsyncStorage
    await AsyncStorage.setItem(key, JSON.stringify(entry));
  } catch (error) {
    console.warn('Error setting cached value:', error);
  }
}

/**
 * Remove a value from the cache
 * @param key Cache key
 */
export async function removeCachedValue(key: string): Promise<void> {
  try {
    // Remove from memory cache
    delete memoryCache[key];
    
    // Remove from AsyncStorage
    await AsyncStorage.removeItem(key);
  } catch (error) {
    console.warn('Error removing cached value:', error);
  }
}

/**
 * Clear all cached values
 */
export async function clearCache(): Promise<void> {
  try {
    // Clear memory cache
    Object.keys(memoryCache).forEach(key => {
      delete memoryCache[key];
    });
    
    // Get all cache keys
    const keys = await AsyncStorage.getAllKeys();
    const cacheKeys = keys.filter(key => key.startsWith('cache:'));
    
    // Remove all cache entries
    if (cacheKeys.length > 0) {
      await AsyncStorage.multiRemove(cacheKeys);
    }
  } catch (error) {
    console.warn('Error clearing cache:', error);
  }
}

/**
 * Get a cached value or fetch it if not in cache
 * @param key Cache key
 * @param fetchFn Function to fetch the value if not in cache
 * @param options Cache options
 * @returns Cached or fetched value
 */
export async function getCachedOrFetch<T>(
  key: string,
  fetchFn: () => Promise<T>,
  options: CacheOptions = {}
): Promise<T> {
  const { refreshInBackground } = { ...DEFAULT_CACHE_OPTIONS, ...options };
  
  // Try to get from cache
  const cachedValue = await getCachedValue<T>(key);
  if (cachedValue !== null) {
    // Refresh cache in background if needed
    if (refreshInBackground) {
      refreshCacheInBackground(key, fetchFn, options);
    }
    
    return cachedValue;
  }
  
  // Fetch value if not in cache
  const value = await fetchFn();
  
  // Cache the value
  await setCachedValue(key, value, options);
  
  return value;
}

/**
 * Refresh a cached value in the background
 * @param key Cache key
 * @param fetchFn Function to fetch the value
 * @param options Cache options
 */
async function refreshCacheInBackground<T>(
  key: string,
  fetchFn: () => Promise<T>,
  options: CacheOptions = {}
): Promise<void> {
  try {
    // Get cache entry
    const storedValue = await AsyncStorage.getItem(key);
    if (!storedValue) return;
    
    const entry = JSON.parse(storedValue) as CacheEntry<T>;
    
    // Check if cache is about to expire (75% of expiry time)
    const { expiryTime } = { ...DEFAULT_CACHE_OPTIONS, ...options };
    const refreshThreshold = Date.now() + (expiryTime! * 0.25);
    
    if (entry.expiry < refreshThreshold) {
      // Fetch new value
      const value = await fetchFn();
      
      // Update cache
      await setCachedValue(key, value, options);
    }
  } catch (error) {
    console.warn('Error refreshing cache in background:', error);
  }
}

/**
 * Create a cache key for compatibility calculations
 * @param userId1 First user ID
 * @param userId2 Second user ID
 * @returns Cache key
 */
export function createCompatibilityKey(userId1: string, userId2: string): string {
  // Sort user IDs to ensure consistent key regardless of order
  const sortedIds = [userId1, userId2].sort();
  return `cache:compatibility:${sortedIds[0]}:${sortedIds[1]}`;
}

/**
 * Create a cache key for match lists
 * @param userId User ID
 * @param status Match status (optional)
 * @param page Page number (optional)
 * @param pageSize Page size (optional)
 * @returns Cache key
 */
export function createMatchesKey(
  userId: string,
  status?: string,
  page?: number,
  pageSize?: number
): string {
  let key = `cache:matches:${userId}`;
  
  if (status) {
    key += `:${status}`;
  }
  
  if (page !== undefined && pageSize !== undefined) {
    key += `:${page}:${pageSize}`;
  }
  
  return key;
}

/**
 * Create a cache key for user profiles
 * @param userId User ID
 * @returns Cache key
 */
export function createProfileKey(userId: string): string {
  return `cache:profile:${userId}`;
}

/**
 * Create a pagination result
 * @param data Data items
 * @param page Current page
 * @param pageSize Page size
 * @param totalCount Total count of items
 * @returns Pagination result
 */
export function createPaginationResult<T>(
  data: T[],
  page: number,
  pageSize: number,
  totalCount: number
): {
  data: T[];
  page: number;
  pageSize: number;
  totalPages: number;
  totalCount: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
} {
  const totalPages = Math.ceil(totalCount / pageSize);
  
  return {
    data,
    page,
    pageSize,
    totalPages,
    totalCount,
    hasNextPage: page < totalPages,
    hasPreviousPage: page > 1
  };
}
