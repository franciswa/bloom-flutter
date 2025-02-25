import { Alert } from 'react-native';
import { PostgrestError } from '@supabase/supabase-js';

/**
 * Error types for categorizing errors
 */
export enum ErrorType {
  AUTHENTICATION = 'authentication',
  DATABASE = 'database',
  NETWORK = 'network',
  VALIDATION = 'validation',
  COMPATIBILITY = 'compatibility',
  UNKNOWN = 'unknown'
}

/**
 * Custom error class with additional properties
 */
export class AppError extends Error {
  type: ErrorType;
  originalError?: any;
  code?: string;
  details?: Record<string, any>;

  constructor(
    message: string,
    type: ErrorType = ErrorType.UNKNOWN,
    originalError?: any,
    code?: string,
    details?: Record<string, any>
  ) {
    super(message);
    this.name = 'AppError';
    this.type = type;
    this.originalError = originalError;
    this.code = code;
    this.details = details;
  }
}

/**
 * Handle authentication errors
 * @param error Error to handle
 * @returns AppError with appropriate type and message
 */
export function handleAuthError(error: any): AppError {
  console.error('Authentication error:', error);
  
  // Extract error message and code
  const errorMessage = error?.message || 'Authentication failed';
  const errorCode = error?.code || 'unknown';
  
  // Map common error codes to user-friendly messages
  let userMessage = 'Authentication failed. Please try again.';
  
  switch (errorCode) {
    case 'invalid_credentials':
      userMessage = 'Invalid email or password. Please try again.';
      break;
    case 'user_not_found':
      userMessage = 'User not found. Please check your email or sign up.';
      break;
    case 'email_not_confirmed':
      userMessage = 'Please confirm your email before signing in.';
      break;
    case 'password_recovery_code_expired':
      userMessage = 'Password reset link has expired. Please request a new one.';
      break;
    case 'network_error':
      userMessage = 'Network error. Please check your connection and try again.';
      break;
    default:
      if (errorMessage.includes('password')) {
        userMessage = 'Invalid password. Please try again.';
      } else if (errorMessage.includes('email')) {
        userMessage = 'Invalid email format. Please check your email.';
      }
  }
  
  return new AppError(
    userMessage,
    ErrorType.AUTHENTICATION,
    error,
    errorCode
  );
}

/**
 * Handle database errors
 * @param error Error to handle
 * @returns AppError with appropriate type and message
 */
export function handleDatabaseError(error: any): AppError {
  console.error('Database error:', error);
  
  // Handle Supabase PostgrestError
  if (error && 'code' in error) {
    const postgrestError = error as PostgrestError;
    
    // Map common Postgres error codes to user-friendly messages
    let userMessage = 'Database operation failed. Please try again.';
    
    switch (postgrestError.code) {
      case '23505': // unique_violation
        userMessage = 'This record already exists.';
        break;
      case '23503': // foreign_key_violation
        userMessage = 'This operation references a record that does not exist.';
        break;
      case '42P01': // undefined_table
        userMessage = 'System error: Table not found.';
        break;
      case '42703': // undefined_column
        userMessage = 'System error: Column not found.';
        break;
      case '28P01': // invalid_password
        userMessage = 'Invalid credentials. Please try again.';
        break;
      case '28000': // invalid_authorization_specification
        userMessage = 'Authorization error. Please sign in again.';
        break;
      case '3D000': // invalid_catalog_name
        userMessage = 'System error: Database not found.';
        break;
      case '3F000': // invalid_schema_name
        userMessage = 'System error: Schema not found.';
        break;
      case '40001': // serialization_failure
        userMessage = 'Database conflict. Please try again.';
        break;
      case '40P01': // deadlock_detected
        userMessage = 'Database conflict. Please try again.';
        break;
      case '53100': // disk_full
        userMessage = 'Server storage error. Please try again later.';
        break;
      case '53200': // out_of_memory
        userMessage = 'Server memory error. Please try again later.';
        break;
      case '53300': // too_many_connections
        userMessage = 'Server connection error. Please try again later.';
        break;
      case '57P01': // admin_shutdown
      case '57P02': // crash_shutdown
      case '57P03': // cannot_connect_now
        userMessage = 'Server is currently unavailable. Please try again later.';
        break;
      default:
        userMessage = `Database error: ${postgrestError.message || 'Unknown error'}`;
    }
    
    return new AppError(
      userMessage,
      ErrorType.DATABASE,
      error,
      postgrestError.code,
      { details: postgrestError.details }
    );
  }
  
  // Handle other database errors
  return new AppError(
    'Database operation failed. Please try again.',
    ErrorType.DATABASE,
    error
  );
}

/**
 * Handle network errors
 * @param error Error to handle
 * @returns AppError with appropriate type and message
 */
export function handleNetworkError(error: any): AppError {
  console.error('Network error:', error);
  
  // Extract error message and code
  const errorMessage = error?.message || 'Network request failed';
  const errorCode = error?.code || 'unknown';
  
  // Map common error codes to user-friendly messages
  let userMessage = 'Network error. Please check your connection and try again.';
  
  if (errorMessage.includes('timeout')) {
    userMessage = 'Request timed out. Please try again.';
  } else if (errorMessage.includes('Network request failed')) {
    userMessage = 'Network connection failed. Please check your internet connection.';
  } else if (errorMessage.includes('ENOTFOUND') || errorMessage.includes('404')) {
    userMessage = 'Resource not found. Please try again later.';
  } else if (errorMessage.includes('ECONNREFUSED')) {
    userMessage = 'Connection refused. Server may be down.';
  }
  
  return new AppError(
    userMessage,
    ErrorType.NETWORK,
    error,
    errorCode
  );
}

/**
 * Handle validation errors
 * @param error Error to handle
 * @param fieldErrors Optional field-specific error messages
 * @returns AppError with appropriate type and message
 */
export function handleValidationError(
  error: any,
  fieldErrors?: Record<string, string>
): AppError {
  console.error('Validation error:', error);
  
  // Extract error message
  const errorMessage = error?.message || 'Validation failed';
  
  // Create user-friendly message
  let userMessage = 'Please check your input and try again.';
  
  if (fieldErrors) {
    // Create message from field errors
    const errorMessages = Object.entries(fieldErrors)
      .map(([field, message]) => `${field}: ${message}`)
      .join('\n');
    
    userMessage = `Please correct the following errors:\n${errorMessages}`;
  } else if (errorMessage) {
    userMessage = errorMessage;
  }
  
  return new AppError(
    userMessage,
    ErrorType.VALIDATION,
    error,
    undefined,
    { fieldErrors }
  );
}

/**
 * Handle compatibility calculation errors
 * @param error Error to handle
 * @returns AppError with appropriate type and message
 */
export function handleCompatibilityError(error: any): AppError {
  console.error('Compatibility calculation error:', error);
  
  // Extract error message
  const errorMessage = error?.message || 'Compatibility calculation failed';
  
  // Create user-friendly message
  let userMessage = 'Failed to calculate compatibility. Please try again.';
  
  if (errorMessage.includes('birth')) {
    userMessage = 'Invalid birth data. Please check birth date, time, and location.';
  } else if (errorMessage.includes('profile')) {
    userMessage = 'Profile data is incomplete. Please complete your profile.';
  } else if (errorMessage.includes('questionnaire')) {
    userMessage = 'Questionnaire data is incomplete. Please complete the questionnaire.';
  }
  
  return new AppError(
    userMessage,
    ErrorType.COMPATIBILITY,
    error
  );
}

/**
 * Handle unknown errors
 * @param error Error to handle
 * @returns AppError with appropriate type and message
 */
export function handleUnknownError(error: any): AppError {
  console.error('Unknown error:', error);
  
  // Extract error message
  const errorMessage = error?.message || 'An unknown error occurred';
  
  return new AppError(
    'An unexpected error occurred. Please try again.',
    ErrorType.UNKNOWN,
    error
  );
}

/**
 * Handle any error and return an AppError
 * @param error Error to handle
 * @param defaultType Default error type if not specified
 * @returns AppError with appropriate type and message
 */
export function handleError(
  error: any,
  defaultType: ErrorType = ErrorType.UNKNOWN
): AppError {
  // If error is already an AppError, return it
  if (error instanceof AppError) {
    return error;
  }
  
  // Handle error based on type
  switch (defaultType) {
    case ErrorType.AUTHENTICATION:
      return handleAuthError(error);
    case ErrorType.DATABASE:
      return handleDatabaseError(error);
    case ErrorType.NETWORK:
      return handleNetworkError(error);
    case ErrorType.VALIDATION:
      return handleValidationError(error);
    case ErrorType.COMPATIBILITY:
      return handleCompatibilityError(error);
    default:
      return handleUnknownError(error);
  }
}

/**
 * Show an error alert with a user-friendly message
 * @param error Error to show
 * @param title Alert title
 */
export function showErrorAlert(
  error: any,
  title: string = 'Error'
): void {
  const appError = error instanceof AppError
    ? error
    : handleError(error);
  
  Alert.alert(
    title,
    appError.message,
    [{ text: 'OK' }]
  );
}

/**
 * Log an error to the console and optionally to an error tracking service
 * @param error Error to log
 * @param context Additional context information
 */
export function logError(
  error: any,
  context?: Record<string, any>
): void {
  const appError = error instanceof AppError
    ? error
    : handleError(error);
  
  console.error('Error:', {
    message: appError.message,
    type: appError.type,
    code: appError.code,
    details: appError.details,
    context,
    originalError: appError.originalError
  });
  
  // Here you would add code to log to an error tracking service
  // For example, Sentry, Firebase Crashlytics, etc.
  // Example:
  // if (Sentry) {
  //   Sentry.captureException(appError, { extra: { context } });
  // }
}

/**
 * Try to execute a function and handle any errors
 * @param fn Function to execute
 * @param errorType Error type for handling
 * @param showAlert Whether to show an alert on error
 * @param alertTitle Alert title
 * @returns Result of the function or undefined on error
 */
export async function tryCatch<T>(
  fn: () => Promise<T>,
  errorType: ErrorType = ErrorType.UNKNOWN,
  showAlert: boolean = true,
  alertTitle: string = 'Error'
): Promise<T | undefined> {
  try {
    return await fn();
  } catch (error) {
    const appError = handleError(error, errorType);
    logError(appError);
    
    if (showAlert) {
      showErrorAlert(appError, alertTitle);
    }
    
    return undefined;
  }
}
