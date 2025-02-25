import AsyncStorage from '@react-native-async-storage/async-storage';
import { handleValidationError } from './errorHandling';

/**
 * Validation rules for input fields
 */
interface ValidationRule {
  /** Whether the field is required */
  required?: boolean;
  /** Minimum length of the field */
  minLength?: number;
  /** Maximum length of the field */
  maxLength?: number;
  /** Regular expression pattern to match */
  pattern?: RegExp;
  /** Custom validation function */
  validate?: (value: any) => boolean;
  /** Error message to display if validation fails */
  message?: string;
}

/**
 * Validation rules for different field types
 */
const validationRules: Record<string, ValidationRule> = {
  email: {
    required: true,
    pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    message: 'Please enter a valid email address'
  },
  password: {
    required: true,
    minLength: 8,
    pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
    message: 'Password must be at least 8 characters and include uppercase, lowercase, number, and special character'
  },
  name: {
    required: true,
    minLength: 2,
    maxLength: 50,
    message: 'Name must be between 2 and 50 characters'
  },
  date: {
    required: true,
    validate: (value) => !isNaN(new Date(value).getTime()),
    message: 'Please enter a valid date'
  },
  time: {
    required: true,
    pattern: /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/,
    message: 'Please enter a valid time in 24-hour format (HH:MM)'
  },
  latitude: {
    required: true,
    validate: (value) => {
      const num = parseFloat(value);
      return !isNaN(num) && num >= -90 && num <= 90;
    },
    message: 'Latitude must be between -90 and 90'
  },
  longitude: {
    required: true,
    validate: (value) => {
      const num = parseFloat(value);
      return !isNaN(num) && num >= -180 && num <= 180;
    },
    message: 'Longitude must be between -180 and 180'
  },
  rating: {
    required: true,
    validate: (value) => {
      const num = parseInt(value, 10);
      return !isNaN(num) && num >= 1 && num <= 10;
    },
    message: 'Rating must be between 1 and 10'
  }
};

/**
 * Validate a single field
 * @param field Field name
 * @param value Field value
 * @param rules Validation rules
 * @returns Error message or null if valid
 */
export function validateField(
  field: string,
  value: any,
  rules: ValidationRule = {}
): string | null {
  // Check if field is required
  if (rules.required && (value === undefined || value === null || value === '')) {
    return rules.message || `${field} is required`;
  }
  
  // Skip further validation if value is empty and not required
  if (value === undefined || value === null || value === '') {
    return null;
  }
  
  // Check minimum length
  if (rules.minLength !== undefined && typeof value === 'string' && value.length < rules.minLength) {
    return rules.message || `${field} must be at least ${rules.minLength} characters`;
  }
  
  // Check maximum length
  if (rules.maxLength !== undefined && typeof value === 'string' && value.length > rules.maxLength) {
    return rules.message || `${field} must be at most ${rules.maxLength} characters`;
  }
  
  // Check pattern
  if (rules.pattern && typeof value === 'string' && !rules.pattern.test(value)) {
    return rules.message || `${field} is invalid`;
  }
  
  // Check custom validation
  if (rules.validate && !rules.validate(value)) {
    return rules.message || `${field} is invalid`;
  }
  
  return null;
}

/**
 * Validate an object against validation rules
 * @param data Object to validate
 * @param rules Validation rules
 * @returns Object with field errors or null if valid
 */
export function validateObject(
  data: Record<string, any>,
  rules: Record<string, ValidationRule>
): Record<string, string> | null {
  const errors: Record<string, string> = {};
  
  // Validate each field
  for (const [field, fieldRules] of Object.entries(rules)) {
    const error = validateField(field, data[field], fieldRules);
    if (error) {
      errors[field] = error;
    }
  }
  
  return Object.keys(errors).length > 0 ? errors : null;
}

/**
 * Validate questionnaire responses
 * @param data Questionnaire responses
 * @returns Object with field errors or null if valid
 */
export function validateQuestionnaireResponses(
  data: Record<string, any>
): Record<string, string> | null {
  const errors: Record<string, string> = {};
  
  // Validate personality ratings
  if (data.personality_ratings) {
    for (const [key, value] of Object.entries(data.personality_ratings)) {
      const error = validateField(`personality_ratings.${key}`, value, validationRules.rating);
      if (error) {
        errors[`personality_ratings.${key}`] = error;
      }
    }
  }
  
  // Validate lifestyle ratings
  if (data.lifestyle_ratings) {
    for (const [key, value] of Object.entries(data.lifestyle_ratings)) {
      const error = validateField(`lifestyle_ratings.${key}`, value, validationRules.rating);
      if (error) {
        errors[`lifestyle_ratings.${key}`] = error;
      }
    }
  }
  
  // Validate values ratings
  if (data.values_ratings) {
    for (const [key, value] of Object.entries(data.values_ratings)) {
      const error = validateField(`values_ratings.${key}`, value, validationRules.rating);
      if (error) {
        errors[`values_ratings.${key}`] = error;
      }
    }
  }
  
  // Validate birth information
  if (data.birth_date) {
    const error = validateField('birth_date', data.birth_date, validationRules.date);
    if (error) {
      errors.birth_date = error;
    }
  }
  
  if (data.birth_time) {
    const error = validateField('birth_time', data.birth_time, validationRules.time);
    if (error) {
      errors.birth_time = error;
    }
  }
  
  if (data.birth_location) {
    if (data.birth_location.latitude) {
      const error = validateField('birth_location.latitude', data.birth_location.latitude, validationRules.latitude);
      if (error) {
        errors['birth_location.latitude'] = error;
      }
    }
    
    if (data.birth_location.longitude) {
      const error = validateField('birth_location.longitude', data.birth_location.longitude, validationRules.longitude);
      if (error) {
        errors['birth_location.longitude'] = error;
      }
    }
  }
  
  return Object.keys(errors).length > 0 ? errors : null;
}

/**
 * Rate limiting configuration
 */
interface RateLimitConfig {
  /** Maximum number of attempts */
  maxAttempts: number;
  /** Time window in milliseconds */
  timeWindow: number;
  /** Lockout duration in milliseconds */
  lockoutDuration: number;
}

/**
 * Default rate limit configurations
 */
const rateLimitConfigs: Record<string, RateLimitConfig> = {
  signIn: {
    maxAttempts: 5,
    timeWindow: 5 * 60 * 1000, // 5 minutes
    lockoutDuration: 15 * 60 * 1000 // 15 minutes
  },
  signUp: {
    maxAttempts: 3,
    timeWindow: 60 * 60 * 1000, // 1 hour
    lockoutDuration: 24 * 60 * 60 * 1000 // 24 hours
  },
  resetPassword: {
    maxAttempts: 3,
    timeWindow: 60 * 60 * 1000, // 1 hour
    lockoutDuration: 60 * 60 * 1000 // 1 hour
  },
  api: {
    maxAttempts: 100,
    timeWindow: 60 * 1000, // 1 minute
    lockoutDuration: 5 * 60 * 1000 // 5 minutes
  }
};

/**
 * Rate limit attempt
 */
interface RateLimitAttempt {
  /** Timestamp of the attempt */
  timestamp: number;
  /** IP address of the attempt */
  ip?: string;
  /** User ID of the attempt */
  userId?: string;
}

/**
 * Rate limit entry
 */
interface RateLimitEntry {
  /** Attempts within the time window */
  attempts: RateLimitAttempt[];
  /** Timestamp when the lockout expires */
  lockoutExpiry?: number;
}

/**
 * Check if a rate limit has been exceeded
 * @param key Rate limit key
 * @param config Rate limit configuration
 * @param userId User ID (optional)
 * @param ip IP address (optional)
 * @returns True if rate limit exceeded, false otherwise
 */
export async function checkRateLimit(
  key: string,
  config: RateLimitConfig = rateLimitConfigs.api,
  userId?: string,
  ip?: string
): Promise<boolean> {
  try {
    // Create rate limit key
    const rateLimitKey = `rateLimit:${key}:${userId || ip || 'anonymous'}`;
    
    // Get current rate limit entry
    const storedValue = await AsyncStorage.getItem(rateLimitKey);
    let entry: RateLimitEntry = storedValue
      ? JSON.parse(storedValue)
      : { attempts: [] };
    
    // Check if currently locked out
    const now = Date.now();
    if (entry.lockoutExpiry && entry.lockoutExpiry > now) {
      return true;
    }
    
    // Filter attempts within time window
    const timeWindowStart = now - config.timeWindow;
    entry.attempts = entry.attempts.filter(attempt => attempt.timestamp >= timeWindowStart);
    
    // Check if rate limit exceeded
    if (entry.attempts.length >= config.maxAttempts) {
      // Set lockout expiry
      entry.lockoutExpiry = now + config.lockoutDuration;
      
      // Save updated entry
      await AsyncStorage.setItem(rateLimitKey, JSON.stringify(entry));
      
      return true;
    }
    
    return false;
  } catch (error) {
    console.warn('Error checking rate limit:', error);
    return false;
  }
}

/**
 * Record a rate limit attempt
 * @param key Rate limit key
 * @param config Rate limit configuration
 * @param userId User ID (optional)
 * @param ip IP address (optional)
 */
export async function recordRateLimitAttempt(
  key: string,
  config: RateLimitConfig = rateLimitConfigs.api,
  userId?: string,
  ip?: string
): Promise<void> {
  try {
    // Create rate limit key
    const rateLimitKey = `rateLimit:${key}:${userId || ip || 'anonymous'}`;
    
    // Get current rate limit entry
    const storedValue = await AsyncStorage.getItem(rateLimitKey);
    let entry: RateLimitEntry = storedValue
      ? JSON.parse(storedValue)
      : { attempts: [] };
    
    // Filter attempts within time window
    const now = Date.now();
    const timeWindowStart = now - config.timeWindow;
    entry.attempts = entry.attempts.filter(attempt => attempt.timestamp >= timeWindowStart);
    
    // Add new attempt
    entry.attempts.push({
      timestamp: now,
      userId,
      ip
    });
    
    // Check if rate limit exceeded
    if (entry.attempts.length >= config.maxAttempts) {
      // Set lockout expiry
      entry.lockoutExpiry = now + config.lockoutDuration;
    }
    
    // Save updated entry
    await AsyncStorage.setItem(rateLimitKey, JSON.stringify(entry));
  } catch (error) {
    console.warn('Error recording rate limit attempt:', error);
  }
}

/**
 * Reset a rate limit
 * @param key Rate limit key
 * @param userId User ID (optional)
 * @param ip IP address (optional)
 */
export async function resetRateLimit(
  key: string,
  userId?: string,
  ip?: string
): Promise<void> {
  try {
    // Create rate limit key
    const rateLimitKey = `rateLimit:${key}:${userId || ip || 'anonymous'}`;
    
    // Remove rate limit entry
    await AsyncStorage.removeItem(rateLimitKey);
  } catch (error) {
    console.warn('Error resetting rate limit:', error);
  }
}

/**
 * Validate and sanitize input to prevent XSS attacks
 * @param input Input to sanitize
 * @returns Sanitized input
 */
export function sanitizeInput(input: string): string {
  if (!input) return input;
  
  // Replace HTML tags and entities
  return input
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .replace(/\//g, '&#x2F;');
}

/**
 * Sanitize an object's string properties
 * @param obj Object to sanitize
 * @returns Sanitized object
 */
export function sanitizeObject<T extends Record<string, any>>(obj: T): T {
  const result = { ...obj } as Record<string, any>;
  
  for (const [key, value] of Object.entries(result)) {
    if (typeof value === 'string') {
      result[key] = sanitizeInput(value);
    } else if (typeof value === 'object' && value !== null) {
      result[key] = sanitizeObject(value);
    }
  }
  
  return result as T;
}
