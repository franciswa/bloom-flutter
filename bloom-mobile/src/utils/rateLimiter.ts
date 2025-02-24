import AsyncStorage from '@react-native-async-storage/async-storage';

interface AttemptRecord {
  attempts: number;
  resetTime: number;
}

/**
 * Simple rate limiter for client-side protection against brute force attacks
 */
export class RateLimiter {
  private key: string;
  private maxAttempts: number;
  private windowMs: number;

  /**
   * Creates a new rate limiter
   * @param key Unique identifier for this rate limiter
   * @param maxAttempts Maximum number of attempts allowed in the time window
   * @param windowMs Time window in milliseconds
   */
  constructor(key: string, maxAttempts: number = 5, windowMs: number = 60 * 1000) {
    this.key = `rate_limiter_${key}`;
    this.maxAttempts = maxAttempts;
    this.windowMs = windowMs;
  }

  /**
   * Checks if the action should be rate limited
   * @returns Promise<{limited: boolean, remainingAttempts: number, resetTime: number}>
   */
  async check(): Promise<{
    limited: boolean;
    remainingAttempts: number;
    resetTime: number;
  }> {
    try {
      const now = Date.now();
      const storedRecord = await AsyncStorage.getItem(this.key);
      
      if (!storedRecord) {
        // First attempt
        const newRecord: AttemptRecord = {
          attempts: 1,
          resetTime: now + this.windowMs,
        };
        await AsyncStorage.setItem(this.key, JSON.stringify(newRecord));
        return {
          limited: false,
          remainingAttempts: this.maxAttempts - 1,
          resetTime: newRecord.resetTime,
        };
      }

      const record: AttemptRecord = JSON.parse(storedRecord);
      
      // Check if the rate limit window has expired
      if (now > record.resetTime) {
        // Reset the counter
        const newRecord: AttemptRecord = {
          attempts: 1,
          resetTime: now + this.windowMs,
        };
        await AsyncStorage.setItem(this.key, JSON.stringify(newRecord));
        return {
          limited: false,
          remainingAttempts: this.maxAttempts - 1,
          resetTime: newRecord.resetTime,
        };
      }

      // Window is still active
      const attempts = record.attempts + 1;
      const limited = attempts > this.maxAttempts;
      
      if (!limited) {
        // Update attempts count
        await AsyncStorage.setItem(
          this.key,
          JSON.stringify({
            ...record,
            attempts,
          })
        );
      }

      return {
        limited,
        remainingAttempts: Math.max(0, this.maxAttempts - attempts),
        resetTime: record.resetTime,
      };
    } catch (error) {
      // In case of storage error, don't block the user
      console.error('Rate limiter error:', error);
      return {
        limited: false,
        remainingAttempts: this.maxAttempts,
        resetTime: Date.now() + this.windowMs,
      };
    }
  }

  /**
   * Resets the rate limiter
   */
  async reset(): Promise<void> {
    await AsyncStorage.removeItem(this.key);
  }
}

// Create common rate limiters
export const authRateLimiter = new RateLimiter('auth', 5, 5 * 60 * 1000); // 5 attempts per 5 minutes
export const passwordResetRateLimiter = new RateLimiter('password_reset', 3, 10 * 60 * 1000); // 3 attempts per 10 minutes