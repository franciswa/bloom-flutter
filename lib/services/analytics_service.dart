import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
// import 'package:sentry_flutter/sentry_flutter.dart'; // Temporarily disabled for Linux build

import '../config/app_config.dart';
import '../models/user.dart';
import '../utils/error_handling.dart';

/// Analytics service for tracking user events and errors
class AnalyticsService {
  /// PostHog instance
  static late Posthog _posthog;

  /// Whether analytics is initialized
  static bool _isInitialized = false;

  /// Initialize analytics service
  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      // Initialize PostHog
      _posthog = Posthog();
      await _posthog.capture(
        eventName: 'app_initialized',
        properties: {
          'app_version': AppConfig.appVersion,
          'environment': AppConfig.environment.toString(),
          'platform': kIsWeb ? 'web' : 'mobile',
        },
      );

      _isInitialized = true;
      if (kDebugMode) {
        ErrorHandler.logError('Analytics service initialized',
            hint: 'Analytics');
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError(e,
          stackTrace: stackTrace,
          hint: 'Failed to initialize analytics service');
      // Sentry disabled for Linux build
      // if (!kIsWeb) {
      //   await Sentry.captureException(e, stackTrace: stackTrace);
      // }
    }
  }

  /// Identify user
  static Future<void> identifyUser(User user) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _posthog.identify(userId: user.id);
      if (kDebugMode) {
        ErrorHandler.logError('User identified: ${user.id}', hint: 'Analytics');
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError(e,
          stackTrace: stackTrace, hint: 'Failed to identify user');
      // Sentry disabled for Linux build
      // if (!kIsWeb) {
      //   await Sentry.captureException(e, stackTrace: stackTrace);
      // }
    }
  }

  /// Reset user
  static Future<void> resetUser() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _posthog.reset();
      if (kDebugMode) {
        ErrorHandler.logError('User reset', hint: 'Analytics');
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError(e,
          stackTrace: stackTrace, hint: 'Failed to reset user');
      // Sentry disabled for Linux build
      // if (!kIsWeb) {
      //   await Sentry.captureException(e, stackTrace: stackTrace);
      // }
    }
  }

  /// Track event
  static Future<void> trackEvent(String eventName,
      {Map<String, dynamic>? properties}) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final Map<String, dynamic> allProperties = {
        'platform': kIsWeb ? 'web' : 'mobile',
        ...?properties,
      };

      // Convert the properties to a Map<String, Object> to avoid type errors
      final Map<String, Object> convertedProperties = {};
      allProperties.forEach((key, value) {
        if (value != null) {
          convertedProperties[key] = value.toString();
        }
      });

      await _posthog.capture(
        eventName: eventName,
        properties: convertedProperties,
      );
      if (kDebugMode) {
        ErrorHandler.logError('Event tracked: $eventName', hint: 'Analytics');
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError(e,
          stackTrace: stackTrace, hint: 'Failed to track event');
      // Sentry disabled for Linux build
      // if (!kIsWeb) {
      //   await Sentry.captureException(e, stackTrace: stackTrace);
      // }
    }
  }

  /// Track screen view
  static Future<void> trackScreenView(String screenName,
      {Map<String, dynamic>? properties}) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final screenProperties = {
        'screen': screenName,
        'platform': kIsWeb ? 'web' : 'mobile',
        ...?properties,
      };

      // Convert the properties to a Map<String, Object> to avoid type errors
      final Map<String, Object> convertedScreenProperties = {};
      screenProperties.forEach((key, value) {
        if (value != null) {
          convertedScreenProperties[key] = value.toString();
        }
      });

      await _posthog.screen(
        screenName: screenName,
        properties: convertedScreenProperties,
      );
      if (kDebugMode) {
        ErrorHandler.logError('Screen view tracked: $screenName',
            hint: 'Analytics');
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError(e,
          stackTrace: stackTrace, hint: 'Failed to track screen view');
      // Sentry disabled for Linux build
      // if (!kIsWeb) {
      //   await Sentry.captureException(e, stackTrace: stackTrace);
      // }
    }
  }

  /// Track login
  static Future<void> trackLogin(String method) async {
    await trackEvent('login', properties: {'method': method});
  }

  /// Track registration
  static Future<void> trackRegistration(String method) async {
    await trackEvent('registration', properties: {'method': method});
  }

  /// Track logout
  static Future<void> trackLogout() async {
    await trackEvent('logout');
  }

  /// Track profile update
  static Future<void> trackProfileUpdate({
    required Map<String, dynamic> updatedFields,
  }) async {
    await trackEvent('profile_updated', properties: {
      'updated_fields': updatedFields.keys.toList(),
    });
  }

  /// Track match
  static Future<void> trackMatch({
    required String matchId,
    required double compatibilityScore,
  }) async {
    await trackEvent('match_created', properties: {
      'match_id': matchId,
      'compatibility_score': compatibilityScore,
    });
  }

  /// Track message sent
  static Future<void> trackMessageSent({
    required String conversationId,
    required String messageType,
  }) async {
    await trackEvent('message_sent', properties: {
      'conversation_id': conversationId,
      'message_type': messageType,
    });
  }

  /// Track chart generated
  static Future<void> trackChartGenerated({
    required String chartId,
    required String chartType,
  }) async {
    await trackEvent('chart_generated', properties: {
      'chart_id': chartId,
      'chart_type': chartType,
    });
  }

  /// Track date preference update
  static Future<void> trackDatePreferenceUpdate({
    required Map<String, dynamic> updatedPreferences,
  }) async {
    await trackEvent('date_preference_updated', properties: {
      'updated_preferences': updatedPreferences.keys.toList(),
    });
  }

  /// Track questionnaire completed
  static Future<void> trackQuestionnaireCompleted({
    required String questionnaireId,
    required int questionCount,
  }) async {
    await trackEvent('questionnaire_completed', properties: {
      'questionnaire_id': questionnaireId,
      'question_count': questionCount,
    });
  }

  /// Track notification received
  static Future<void> trackNotificationReceived({
    required String notificationId,
    required String notificationType,
  }) async {
    await trackEvent('notification_received', properties: {
      'notification_id': notificationId,
      'notification_type': notificationType,
    });
  }

  /// Track notification opened
  static Future<void> trackNotificationOpened({
    required String notificationId,
    required String notificationType,
  }) async {
    await trackEvent('notification_opened', properties: {
      'notification_id': notificationId,
      'notification_type': notificationType,
    });
  }

  /// Track error
  static Future<void> trackError({
    required String errorMessage,
    required String errorSource,
    StackTrace? stackTrace,
  }) async {
    await trackEvent('error', properties: {
      'error_message': errorMessage,
      'error_source': errorSource,
      'stack_trace': stackTrace?.toString(),
    });

    // Sentry disabled for Linux build
    // if (!kIsWeb) {
    //   await Sentry.captureException(
    //     Exception(errorMessage),
    //     stackTrace: stackTrace,
    //     hint: Hint.withMap({'source': errorSource}),
    //   );
    // }
  }

  /// Track feature usage
  static Future<void> trackFeatureUsage({
    required String featureName,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent('feature_used', properties: {
      'feature_name': featureName,
      ...?properties,
    });
  }

  /// Track app start
  static Future<void> trackAppStart() async {
    await trackEvent('app_start', properties: {
      'app_version': AppConfig.appVersion,
      'build_number': AppConfig.appBuildNumber,
      'environment': AppConfig.environment.toString(),
    });
  }

  /// Track app background
  static Future<void> trackAppBackground() async {
    await trackEvent('app_background');
  }

  /// Track app foreground
  static Future<void> trackAppForeground() async {
    await trackEvent('app_foreground');
  }

  /// Track app crash
  static Future<void> trackAppCrash({
    required String errorMessage,
    required String errorSource,
    StackTrace? stackTrace,
  }) async {
    await trackEvent('app_crash', properties: {
      'error_message': errorMessage,
      'error_source': errorSource,
      'stack_trace': stackTrace?.toString(),
    });

    // Sentry disabled for Linux build
    // if (!kIsWeb) {
    //   await Sentry.captureException(
    //     Exception(errorMessage),
    //     stackTrace: stackTrace,
    //     hint: Hint.withMap({'source': errorSource}),
    //   );
    // }
  }

  /// Track performance metric
  static Future<void> trackPerformanceMetric({
    required String metricName,
    required double value,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent('performance_metric', properties: {
      'metric_name': metricName,
      'value': value,
      ...?properties,
    });
  }

  /// Track user feedback
  static Future<void> trackUserFeedback({
    required String feedbackType,
    required String feedbackContent,
    required int rating,
  }) async {
    await trackEvent('user_feedback', properties: {
      'feedback_type': feedbackType,
      'feedback_content': feedbackContent,
      'rating': rating,
    });
  }
}
