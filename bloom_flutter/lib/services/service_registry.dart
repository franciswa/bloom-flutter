import 'auth_service.dart';
import 'chart_service.dart';
import 'compatibility_service.dart';
import 'date_preference_service.dart';
import 'match_service.dart';
import 'message_service.dart';
import 'notification_service.dart';
import 'profile_service.dart';
import 'questionnaire_service.dart';
import 'user_settings_service.dart';

/// Service registry
class ServiceRegistry {
  /// Private constructor to prevent instantiation
  const ServiceRegistry._();

  /// Auth service
  static final AuthService authService = AuthService();

  /// Profile service
  static final ProfileService profileService = ProfileService();

  /// Chart service
  static final ChartService chartService = ChartService();
  
  /// Questionnaire service
  static final QuestionnaireService questionnaireService = QuestionnaireService();

  /// Compatibility service
  static final CompatibilityService compatibilityService = CompatibilityService(
    chartService: chartService,
    questionnaireService: questionnaireService,
  );

  /// Match service
  static final MatchService matchService = MatchService();

  /// Message service
  static final MessageService messageService = MessageService();

  /// Notification service
  static final NotificationService notificationService = NotificationService();

  /// Date preference service
  static final DatePreferenceService datePreferenceService = DatePreferenceService();

  /// User settings service
  static final UserSettingsService userSettingsService = UserSettingsService();
}
