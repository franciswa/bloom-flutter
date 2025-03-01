import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
      await Sentry.captureException(e, stackTrace: stackTrace);
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
      await Sentry.captureException(e, stackTrace: stackTrace);
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
      await Sentry.captureException(e, stackTrace: stackTrace);
    }
  }

  /// Track event
  static Future<void> trackEvent(String eventName,
      {Map<String, dynamic>? properties}) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _posthog.capture(
        eventName: eventName,
        properties: properties as Map<String, Object>?,
      );
      if (kDebugMode) {
        ErrorHandler.logError('Event tracked: $eventName', hint: 'Analytics');
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError(e,
          stackTrace: stackTrace, hint: 'Failed to track event');
      await Sentry.captureException(e, stackTrace: stackTrace);
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
        ...?properties,
      };

      await _posthog.screen(
        screenName: screenName,
        properties: screenProperties as Map<String, Object>?,
      );
      if (kDebugMode) {
        ErrorHandler.logError('Screen view tracked: $screenName',
            hint: 'Analytics');
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError(e,
          stackTrace: stackTrace, hint: 'Failed to track screen view');
      await Sentry.captureException(e, stackTrace: stackTrace);
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

    // Also send to Sentry
    await Sentry.captureException(
      Exception(errorMessage),
      stackTrace: stackTrace,
      hint: Hint.withMap({'source': errorSource}),
    );
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

    // Also send to Sentry
    await Sentry.captureException(
      Exception(errorMessage),
      stackTrace: stackTrace,
      hint: Hint.withMap({'source': errorSource}),
    );
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

  /// Track user report
  static Future<void> trackUserReport({
    required String reportedUserId,
    required String reportReason,
    String? reportDetails,
  }) async {
    await trackEvent('user_report', properties: {
      'reported_user_id': reportedUserId,
      'report_reason': reportReason,
      'report_details': reportDetails,
    });
  }

  /// Track user block
  static Future<void> trackUserBlock({
    required String blockedUserId,
    String? blockReason,
  }) async {
    await trackEvent('user_block', properties: {
      'blocked_user_id': blockedUserId,
      'block_reason': blockReason,
    });
  }

  /// Track user unblock
  static Future<void> trackUserUnblock({
    required String unblockedUserId,
  }) async {
    await trackEvent('user_unblock', properties: {
      'unblocked_user_id': unblockedUserId,
    });
  }

  /// Track user like
  static Future<void> trackUserLike({
    required String likedUserId,
  }) async {
    await trackEvent('user_like', properties: {
      'liked_user_id': likedUserId,
    });
  }

  /// Track user unlike
  static Future<void> trackUserUnlike({
    required String unlikedUserId,
  }) async {
    await trackEvent('user_unlike', properties: {
      'unliked_user_id': unlikedUserId,
    });
  }

  /// Track user view
  static Future<void> trackUserView({
    required String viewedUserId,
  }) async {
    await trackEvent('user_view', properties: {
      'viewed_user_id': viewedUserId,
    });
  }

  /// Track user search
  static Future<void> trackUserSearch({
    required Map<String, dynamic> searchCriteria,
  }) async {
    await trackEvent('user_search', properties: {
      'search_criteria': searchCriteria,
    });
  }

  /// Track user filter
  static Future<void> trackUserFilter({
    required Map<String, dynamic> filterCriteria,
  }) async {
    await trackEvent('user_filter', properties: {
      'filter_criteria': filterCriteria,
    });
  }

  /// Track user sort
  static Future<void> trackUserSort({
    required String sortBy,
    required String sortOrder,
  }) async {
    await trackEvent('user_sort', properties: {
      'sort_by': sortBy,
      'sort_order': sortOrder,
    });
  }

  /// Track user pagination
  static Future<void> trackUserPagination({
    required String listType,
    required int page,
    required int pageSize,
  }) async {
    await trackEvent('user_pagination', properties: {
      'list_type': listType,
      'page': page,
      'page_size': pageSize,
    });
  }

  /// Track user refresh
  static Future<void> trackUserRefresh({
    required String listType,
  }) async {
    await trackEvent('user_refresh', properties: {
      'list_type': listType,
    });
  }

  /// Track user pull to refresh
  static Future<void> trackUserPullToRefresh({
    required String listType,
  }) async {
    await trackEvent('user_pull_to_refresh', properties: {
      'list_type': listType,
    });
  }

  /// Track user infinite scroll
  static Future<void> trackUserInfiniteScroll({
    required String listType,
    required int page,
  }) async {
    await trackEvent('user_infinite_scroll', properties: {
      'list_type': listType,
      'page': page,
    });
  }

  /// Track user tap
  static Future<void> trackUserTap({
    required String elementType,
    required String elementId,
    String? elementName,
  }) async {
    await trackEvent('user_tap', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
    });
  }

  /// Track user long press
  static Future<void> trackUserLongPress({
    required String elementType,
    required String elementId,
    String? elementName,
  }) async {
    await trackEvent('user_long_press', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
    });
  }

  /// Track user swipe
  static Future<void> trackUserSwipe({
    required String direction,
    required String elementType,
    required String elementId,
    String? elementName,
  }) async {
    await trackEvent('user_swipe', properties: {
      'direction': direction,
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
    });
  }

  /// Track user drag
  static Future<void> trackUserDrag({
    required String elementType,
    required String elementId,
    String? elementName,
  }) async {
    await trackEvent('user_drag', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
    });
  }

  /// Track user drop
  static Future<void> trackUserDrop({
    required String elementType,
    required String elementId,
    String? elementName,
    required String targetType,
    required String targetId,
    String? targetName,
  }) async {
    await trackEvent('user_drop', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
      'target_type': targetType,
      'target_id': targetId,
      'target_name': targetName,
    });
  }

  /// Track user zoom
  static Future<void> trackUserZoom({
    required String elementType,
    required String elementId,
    String? elementName,
    required double scale,
  }) async {
    await trackEvent('user_zoom', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
      'scale': scale,
    });
  }

  /// Track user rotate
  static Future<void> trackUserRotate({
    required String elementType,
    required String elementId,
    String? elementName,
    required double angle,
  }) async {
    await trackEvent('user_rotate', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
      'angle': angle,
    });
  }

  /// Track user pinch
  static Future<void> trackUserPinch({
    required String elementType,
    required String elementId,
    String? elementName,
    required double scale,
  }) async {
    await trackEvent('user_pinch', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
      'scale': scale,
    });
  }

  /// Track user pan
  static Future<void> trackUserPan({
    required String elementType,
    required String elementId,
    String? elementName,
    required double deltaX,
    required double deltaY,
  }) async {
    await trackEvent('user_pan', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
      'delta_x': deltaX,
      'delta_y': deltaY,
    });
  }

  /// Track user scroll
  static Future<void> trackUserScroll({
    required String elementType,
    required String elementId,
    String? elementName,
    required double scrollDelta,
  }) async {
    await trackEvent('user_scroll', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
      'scroll_delta': scrollDelta,
    });
  }

  /// Track user hover
  static Future<void> trackUserHover({
    required String elementType,
    required String elementId,
    String? elementName,
  }) async {
    await trackEvent('user_hover', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
    });
  }

  /// Track user focus
  static Future<void> trackUserFocus({
    required String elementType,
    required String elementId,
    String? elementName,
  }) async {
    await trackEvent('user_focus', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
    });
  }

  /// Track user blur
  static Future<void> trackUserBlur({
    required String elementType,
    required String elementId,
    String? elementName,
  }) async {
    await trackEvent('user_blur', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
    });
  }

  /// Track user input
  static Future<void> trackUserInput({
    required String elementType,
    required String elementId,
    String? elementName,
  }) async {
    await trackEvent('user_input', properties: {
      'element_type': elementType,
      'element_id': elementId,
      'element_name': elementName,
    });
  }

  /// Track user submit
  static Future<void> trackUserSubmit({
    required String formType,
    required String formId,
    String? formName,
  }) async {
    await trackEvent('user_submit', properties: {
      'form_type': formType,
      'form_id': formId,
      'form_name': formName,
    });
  }

  /// Track user cancel
  static Future<void> trackUserCancel({
    required String formType,
    required String formId,
    String? formName,
  }) async {
    await trackEvent('user_cancel', properties: {
      'form_type': formType,
      'form_id': formId,
      'form_name': formName,
    });
  }

  /// Track user reset
  static Future<void> trackUserReset({
    required String formType,
    required String formId,
    String? formName,
  }) async {
    await trackEvent('user_reset', properties: {
      'form_type': formType,
      'form_id': formId,
      'form_name': formName,
    });
  }

  /// Track user validation error
  static Future<void> trackUserValidationError({
    required String formType,
    required String formId,
    String? formName,
    required String fieldName,
    required String errorMessage,
  }) async {
    await trackEvent('user_validation_error', properties: {
      'form_type': formType,
      'form_id': formId,
      'form_name': formName,
      'field_name': fieldName,
      'error_message': errorMessage,
    });
  }

  /// Track user success
  static Future<void> trackUserSuccess({
    required String actionType,
    required String actionId,
    String? actionName,
  }) async {
    await trackEvent('user_success', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
    });
  }

  /// Track user error
  static Future<void> trackUserError({
    required String actionType,
    required String actionId,
    String? actionName,
    required String errorMessage,
  }) async {
    await trackEvent('user_error', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'error_message': errorMessage,
    });
  }

  /// Track user warning
  static Future<void> trackUserWarning({
    required String actionType,
    required String actionId,
    String? actionName,
    required String warningMessage,
  }) async {
    await trackEvent('user_warning', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'warning_message': warningMessage,
    });
  }

  /// Track user info
  static Future<void> trackUserInfo({
    required String actionType,
    required String actionId,
    String? actionName,
    required String infoMessage,
  }) async {
    await trackEvent('user_info', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'info_message': infoMessage,
    });
  }

  /// Track user debug
  static Future<void> trackUserDebug({
    required String actionType,
    required String actionId,
    String? actionName,
    required String debugMessage,
  }) async {
    await trackEvent('user_debug', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'debug_message': debugMessage,
    });
  }

  /// Track user log
  static Future<void> trackUserLog({
    required String actionType,
    required String actionId,
    String? actionName,
    required String logMessage,
  }) async {
    await trackEvent('user_log', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'log_message': logMessage,
    });
  }

  /// Track user trace
  static Future<void> trackUserTrace({
    required String actionType,
    required String actionId,
    String? actionName,
    required String traceMessage,
  }) async {
    await trackEvent('user_trace', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'trace_message': traceMessage,
    });
  }

  /// Track user verbose
  static Future<void> trackUserVerbose({
    required String actionType,
    required String actionId,
    String? actionName,
    required String verboseMessage,
  }) async {
    await trackEvent('user_verbose', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'verbose_message': verboseMessage,
    });
  }

  /// Track user fatal
  static Future<void> trackUserFatal({
    required String actionType,
    required String actionId,
    String? actionName,
    required String fatalMessage,
  }) async {
    await trackEvent('user_fatal', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'fatal_message': fatalMessage,
    });
  }

  /// Track user critical
  static Future<void> trackUserCritical({
    required String actionType,
    required String actionId,
    String? actionName,
    required String criticalMessage,
  }) async {
    await trackEvent('user_critical', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'critical_message': criticalMessage,
    });
  }

  /// Track user emergency
  static Future<void> trackUserEmergency({
    required String actionType,
    required String actionId,
    String? actionName,
    required String emergencyMessage,
  }) async {
    await trackEvent('user_emergency', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'emergency_message': emergencyMessage,
    });
  }

  /// Track user alert
  static Future<void> trackUserAlert({
    required String actionType,
    required String actionId,
    String? actionName,
    required String alertMessage,
  }) async {
    await trackEvent('user_alert', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'alert_message': alertMessage,
    });
  }

  /// Track user notice
  static Future<void> trackUserNotice({
    required String actionType,
    required String actionId,
    String? actionName,
    required String noticeMessage,
  }) async {
    await trackEvent('user_notice', properties: {
      'action_type': actionType,
      'action_id': actionId,
      'action_name': actionName,
      'notice_message': noticeMessage,
    });
  }
}
