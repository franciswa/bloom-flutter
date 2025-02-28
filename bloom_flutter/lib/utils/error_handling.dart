import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Error handler for the app
class ErrorHandler {
  /// Private constructor to prevent instantiation
  const ErrorHandler._();

  /// Log error to console and Sentry
  static Future<void> logError(
    dynamic error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, dynamic>? extras,
  }) async {
    // Always log to console
    debugPrint('ERROR: $error');
    if (stackTrace != null) {
      debugPrint('STACK TRACE: $stackTrace');
    }

    // Try to log to Sentry, but don't wait for it
    try {
      unawaited(_logToSentry(error,
          stackTrace: stackTrace, hint: hint, extras: extras));
    } catch (e) {
      // Ignore errors in error reporting
      debugPrint('Failed to log error to Sentry: $e');
    }
  }

  /// Log error to Sentry
  static Future<void> _logToSentry(
    dynamic error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, dynamic>? extras,
  }) async {
    try {
      final sentryId = await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: hint != null ? Hint.withMap({'hint': hint}) : null,
        // extras parameter is not available in the current version of Sentry
      );
      debugPrint('Error logged to Sentry with ID: $sentryId');
    } catch (e) {
      // Ignore errors in error reporting
      debugPrint('Failed to log error to Sentry: $e');
    }
  }

  /// Handle error with custom handler
  static Future<void> handleError(
    dynamic error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, dynamic>? extras,
    FutureOr<void> Function(dynamic error, StackTrace? stackTrace)? handler,
  }) async {
    // Log error
    await logError(error, stackTrace: stackTrace, hint: hint, extras: extras);

    // Call custom handler if provided
    if (handler != null) {
      try {
        await handler(error, stackTrace);
      } catch (e) {
        debugPrint('Error in custom error handler: $e');
      }
    }
  }

  /// Get error message from error
  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString();
    } else if (error is Error) {
      return error.toString();
    } else if (error is String) {
      return error;
    } else {
      return 'Unknown error';
    }
  }

  /// Get user-friendly error message
  static String getUserFriendlyErrorMessage(dynamic error) {
    final errorMessage = getErrorMessage(error);

    // Check for common error messages and provide user-friendly versions
    if (errorMessage.contains('connection refused') ||
        errorMessage.contains('network is unreachable') ||
        errorMessage.contains('connection timed out') ||
        errorMessage.contains('network error')) {
      return 'Unable to connect to the server. Please check your internet connection and try again.';
    } else if (errorMessage.contains('not found') ||
        errorMessage.contains('404')) {
      return 'The requested resource was not found. Please try again later.';
    } else if (errorMessage.contains('permission denied') ||
        errorMessage.contains('unauthorized') ||
        errorMessage.contains('not authorized') ||
        errorMessage.contains('403')) {
      return 'You do not have permission to perform this action. Please log in again or contact support.';
    } else if (errorMessage.contains('invalid credentials') ||
        errorMessage.contains('incorrect password') ||
        errorMessage.contains('invalid email') ||
        errorMessage.contains('invalid username')) {
      return 'Invalid login credentials. Please check your email and password and try again.';
    } else if (errorMessage.contains('timeout')) {
      return 'The operation timed out. Please try again later.';
    } else if (errorMessage.contains('server error') ||
        errorMessage.contains('500')) {
      return 'A server error occurred. Please try again later.';
    } else if (errorMessage.contains('validation failed') ||
        errorMessage.contains('invalid input')) {
      return 'Please check your input and try again.';
    } else if (errorMessage.contains('already exists')) {
      return 'This resource already exists. Please try a different one.';
    } else if (errorMessage.contains('not initialized')) {
      return 'The application is still initializing. Please try again in a moment.';
    } else if (errorMessage.contains('canceled')) {
      return 'The operation was canceled.';
    } else if (errorMessage.contains('rate limit') ||
        errorMessage.contains('too many requests')) {
      return 'You have made too many requests. Please try again later.';
    } else {
      // Generic error message for unknown errors
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  /// Check if error is a network error
  static bool isNetworkError(dynamic error) {
    final errorMessage = getErrorMessage(error);
    return errorMessage.contains('connection refused') ||
        errorMessage.contains('network is unreachable') ||
        errorMessage.contains('connection timed out') ||
        errorMessage.contains('network error') ||
        errorMessage.contains('socket') ||
        errorMessage.contains('host lookup') ||
        errorMessage.contains('connection closed');
  }

  /// Check if error is an authentication error
  static bool isAuthError(dynamic error) {
    final errorMessage = getErrorMessage(error);
    return errorMessage.contains('permission denied') ||
        errorMessage.contains('unauthorized') ||
        errorMessage.contains('not authorized') ||
        errorMessage.contains('403') ||
        errorMessage.contains('invalid credentials') ||
        errorMessage.contains('incorrect password') ||
        errorMessage.contains('invalid email') ||
        errorMessage.contains('invalid username') ||
        errorMessage.contains('token expired') ||
        errorMessage.contains('invalid token');
  }

  /// Check if error is a server error
  static bool isServerError(dynamic error) {
    final errorMessage = getErrorMessage(error);
    return errorMessage.contains('server error') ||
        errorMessage.contains('500') ||
        errorMessage.contains('502') ||
        errorMessage.contains('503') ||
        errorMessage.contains('504');
  }

  /// Check if error is a validation error
  static bool isValidationError(dynamic error) {
    final errorMessage = getErrorMessage(error);
    return errorMessage.contains('validation failed') ||
        errorMessage.contains('invalid input') ||
        errorMessage.contains('invalid format') ||
        errorMessage.contains('required field') ||
        errorMessage.contains('not valid');
  }
}
