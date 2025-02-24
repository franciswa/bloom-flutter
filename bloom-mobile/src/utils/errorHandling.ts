export class AppError extends Error {
  public readonly code: string;
  public readonly originalError?: Error;

  constructor(message: string, code: string, originalError?: Error) {
    super(message);
    this.name = 'AppError';
    this.code = code;
    this.originalError = originalError;
  }
}

export const ErrorCodes = {
  NETWORK: 'NETWORK_ERROR',
  DATABASE: 'DATABASE_ERROR',
  AUTHENTICATION: 'AUTH_ERROR',
  VALIDATION: 'VALIDATION_ERROR',
  PUSH_NOTIFICATION: 'PUSH_NOTIFICATION_ERROR',
  UNKNOWN: 'UNKNOWN_ERROR',
} as const;

type ErrorHandler = (error: Error) => void;
type ErrorFilter = (error: Error) => boolean;

class ErrorHandlingService {
  private globalHandlers: ErrorHandler[] = [];
  private filteredHandlers: Array<{ filter: ErrorFilter; handler: ErrorHandler }> = [];
  private isProduction = process.env.NODE_ENV === 'production';

  public registerGlobalHandler(handler: ErrorHandler) {
    this.globalHandlers.push(handler);
  }

  public registerFilteredHandler(filter: ErrorFilter, handler: ErrorHandler) {
    this.filteredHandlers.push({ filter, handler });
  }

  public handleError(error: Error | AppError, context?: string) {
    // Always log in development
    if (!this.isProduction) {
      console.error(`[${context || 'App'}]`, error);
    }

    // TODO: Add proper error tracking service integration (e.g. Sentry)
    if (this.isProduction) {
      // For now, we'll still log critical errors in production
      console.error(`[${context || 'App'}] Critical Error:`, {
        message: error.message,
        code: error instanceof AppError ? error.code : undefined,
        originalError: error instanceof AppError ? error.originalError : undefined,
      });
    }

    // Execute filtered handlers first
    let handled = false;
    for (const { filter, handler } of this.filteredHandlers) {
      if (filter(error)) {
        handler(error);
        handled = true;
      }
    }

    // If no filtered handler matched, execute global handlers
    if (!handled) {
      this.globalHandlers.forEach(handler => handler(error));
    }

    return error instanceof AppError ? error : new AppError(
      error.message,
      ErrorCodes.UNKNOWN,
      error
    );
  }

  public createErrorWrapper<T extends (...args: any[]) => Promise<any>>(
    fn: T,
    context?: string
  ): T {
    return (async (...args: Parameters<T>) => {
      try {
        return await fn(...args);
      } catch (error) {
        throw this.handleError(error instanceof Error ? error : new Error(String(error)), context);
      }
    }) as T;
  }

  public isNetworkError(error: Error): boolean {
    return (
      error.message.includes('network') ||
      error.message.includes('Network Error') ||
      error.message.includes('Failed to fetch') ||
      error.message.includes('Network request failed')
    );
  }

  public isAuthenticationError(error: Error): boolean {
    return (
      error instanceof AppError && error.code === ErrorCodes.AUTHENTICATION ||
      error.message.includes('authentication') ||
      error.message.includes('unauthorized') ||
      error.message.includes('not authenticated')
    );
  }
}

export const errorHandler = new ErrorHandlingService();

// Utility function to wrap async functions with error handling
export const withErrorHandling = <T extends (...args: any[]) => Promise<any>>(
  fn: T,
  context?: string
): T => {
  return errorHandler.createErrorWrapper(fn, context);
};

// Example usage:
// const wrappedFunction = withErrorHandling(async () => {
//   // Your async code here
// }, 'ComponentName');
