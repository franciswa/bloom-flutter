import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App environment enum
enum AppEnvironment {
  /// Development environment
  development,

  /// Staging environment
  staging,

  /// Production environment
  production,
}

/// App configuration
class AppConfig {
  /// Current environment
  static late AppEnvironment environment;

  /// Initialize app configuration
  static Future<void> initialize(AppEnvironment env) async {
    environment = env;
    
    // Load environment variables
    await dotenv.load(
      fileName: _getEnvFileName(env),
      mergeWith: Platform.environment,
    );
  }

  /// Get environment file name
  static String _getEnvFileName(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.development:
        return '.env.development';
      case AppEnvironment.staging:
        return '.env.staging';
      case AppEnvironment.production:
        return '.env.production';
    }
  }

  /// Private constructor to prevent instantiation
  const AppConfig._();

  /// App name
  static const String appName = 'Bloom';

  /// App version
  static const String appVersion = '1.0.0';

  /// App build number
  static const int appBuildNumber = 1;

  /// App bundle ID
  static const String appBundleId = 'com.example.bloom';

  /// App package name
  static const String appPackageName = 'com.example.bloom';

  /// App team ID
  static const String appTeamId = 'XXXXXXXXXX';

  /// App store ID
  static const String appStoreId = '000000000';

  /// App store URL
  static const String appStoreUrl = 'https://apps.apple.com/app/id$appStoreId';

  /// Play store URL
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$appPackageName';

  /// App website URL
  static const String appWebsiteUrl = 'https://example.com';

  /// App privacy policy URL
  static const String appPrivacyPolicyUrl = '$appWebsiteUrl/privacy-policy';

  /// App terms of service URL
  static const String appTermsOfServiceUrl = '$appWebsiteUrl/terms-of-service';

  /// App support email
  static const String appSupportEmail = 'support@example.com';

  /// App feedback email
  static const String appFeedbackEmail = 'feedback@example.com';

  /// App copyright
  static String get appCopyright => '© ${DateTime.now().year} Bloom';

  /// Is debug mode
  static bool get isDebugMode => kDebugMode;

  /// Is release mode
  static bool get isReleaseMode => kReleaseMode;

  /// Is profile mode
  static bool get isProfileMode => kProfileMode;

  /// Is web platform
  static bool get isWeb => kIsWeb;

  /// Supabase URL
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  /// Supabase anonymous key
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Supabase service role key
  static String get supabaseServiceRoleKey => dotenv.env['SUPABASE_SERVICE_ROLE_KEY'] ?? '';
  
  /// Sentry DSN
  static String get sentryDsn => dotenv.env['SENTRY_DSN'] ?? '';
  
  /// PostHog API key
  static String get posthogApiKey => dotenv.env['POSTHOG_API_KEY'] ?? '';
  
  /// PostHog host
  static String get posthogHost => dotenv.env['POSTHOG_HOST'] ?? 'https://app.posthog.com';

  /// Supabase storage URL
  static String get supabaseStorageUrl => '$supabaseUrl/storage/v1';

  /// Supabase realtime URL
  static String get supabaseRealtimeUrl => '$supabaseUrl/realtime/v1';

  /// Supabase functions URL
  static String get supabaseFunctionsUrl => '$supabaseUrl/functions/v1';

  /// Supabase auth URL
  static String get supabaseAuthUrl => '$supabaseUrl/auth/v1';

  /// Supabase REST URL
  static String get supabaseRestUrl => '$supabaseUrl/rest/v1';

  /// Supabase GraphQL URL
  static String get supabaseGraphQLUrl => '$supabaseUrl/graphql/v1';

  /// Supabase storage bucket
  static const String supabaseStorageBucket = 'bloom';

  /// Supabase storage profile photos bucket
  static const String supabaseStorageProfilePhotosBucket = 'profile_photos';

  /// Supabase storage message photos bucket
  static const String supabaseStorageMessagePhotosBucket = 'message_photos';

  /// Supabase storage chart images bucket
  static const String supabaseStorageChartImagesBucket = 'chart_images';

  /// Supabase storage date suggestion photos bucket
  static const String supabaseStorageDateSuggestionPhotosBucket = 'date_suggestion_photos';

  /// Supabase profiles table
  static const String supabaseProfilesTable = 'profiles';

  /// Supabase matches table
  static const String supabaseMatchesTable = 'matches';

  /// Supabase conversations table
  static const String supabaseConversationsTable = 'conversations';

  /// Supabase messages table
  static const String supabaseMessagesTable = 'messages';

  /// Supabase notifications table
  static const String supabaseNotificationsTable = 'notifications';

  /// Supabase notification settings table
  static const String supabaseNotificationSettingsTable = 'notification_settings';

  /// Supabase user settings table
  static const String supabaseUserSettingsTable = 'user_settings';

  /// Supabase date preferences table
  static const String supabaseDatePreferencesTable = 'date_preferences';

  /// Supabase date suggestions table
  static const String supabaseDateSuggestionsTable = 'date_suggestions';

  /// Supabase charts table
  static const String supabaseChartsTable = 'charts';

  /// Supabase compatibility table
  static const String supabaseCompatibilityTable = 'compatibility';

  /// Supabase questionnaire questions table
  static const String supabaseQuestionnaireQuestionsTable = 'questionnaire_questions';

  /// Supabase questionnaire answers table
  static const String supabaseQuestionnaireAnswersTable = 'questionnaire_answers';

  /// Supabase questionnaire results table
  static const String supabaseQuestionnaireResultsTable = 'questionnaire_results';

  /// Supabase blocked users table
  static const String supabaseBlockedUsersTable = 'blocked_users';

  /// Supabase reported users table
  static const String supabaseReportedUsersTable = 'reported_users';

  /// Supabase feedback table
  static const String supabaseFeedbackTable = 'feedback';

  /// Supabase app version table
  static const String supabaseAppVersionTable = 'app_version';

  /// Supabase app settings table
  static const String supabaseAppSettingsTable = 'app_settings';

  /// Supabase admin users table
  static const String supabaseAdminUsersTable = 'admin_users';

  /// Supabase user roles table
  static const String supabaseUserRolesTable = 'user_roles';

  /// Supabase user permissions table
  static const String supabaseUserPermissionsTable = 'user_permissions';

  /// Supabase user activity table
  static const String supabaseUserActivityTable = 'user_activity';

  /// Supabase user devices table
  static const String supabaseUserDevicesTable = 'user_devices';

  /// Supabase user sessions table
  static const String supabaseUserSessionsTable = 'user_sessions';

  /// Supabase user locations table
  static const String supabaseUserLocationsTable = 'user_locations';

  /// Supabase user analytics table
  static const String supabaseUserAnalyticsTable = 'user_analytics';

  /// Supabase user feedback table
  static const String supabaseUserFeedbackTable = 'user_feedback';

  /// Supabase user reports table
  static const String supabaseUserReportsTable = 'user_reports';

  /// Supabase user blocks table
  static const String supabaseUserBlocksTable = 'user_blocks';

  /// Supabase user likes table
  static const String supabaseUserLikesTable = 'user_likes';

  /// Supabase user views table
  static const String supabaseUserViewsTable = 'user_views';

  /// Supabase user matches table
  static const String supabaseUserMatchesTable = 'user_matches';

  /// Supabase user messages table
  static const String supabaseUserMessagesTable = 'user_messages';

  /// Supabase user notifications table
  static const String supabaseUserNotificationsTable = 'user_notifications';

  /// Supabase user date suggestions table
  static const String supabaseUserDateSuggestionsTable = 'user_date_suggestions';

  /// Supabase user charts table
  static const String supabaseUserChartsTable = 'user_charts';

  /// Supabase user compatibility table
  static const String supabaseUserCompatibilityTable = 'user_compatibility';

  /// Supabase user settings table
  static const String supabaseUserSettingsTable2 = 'user_settings';

  /// Supabase user preferences table
  static const String supabaseUserPreferencesTable = 'user_preferences';

  /// Supabase user profiles table
  static const String supabaseUserProfilesTable = 'user_profiles';

  /// Supabase user roles table
  static const String supabaseUserRolesTable2 = 'user_roles';

  /// Supabase user permissions table
  static const String supabaseUserPermissionsTable2 = 'user_permissions';

  /// Supabase user activity table
  static const String supabaseUserActivityTable2 = 'user_activity';

  /// Supabase user devices table
  static const String supabaseUserDevicesTable2 = 'user_devices';

  /// Supabase user sessions table
  static const String supabaseUserSessionsTable2 = 'user_sessions';

  /// Supabase user locations table
  static const String supabaseUserLocationsTable2 = 'user_locations';

  /// Supabase user analytics table
  static const String supabaseUserAnalyticsTable2 = 'user_analytics';

  /// Supabase user feedback table
  static const String supabaseUserFeedbackTable2 = 'user_feedback';

  /// Supabase user reports table
  static const String supabaseUserReportsTable2 = 'user_reports';

  /// Supabase user blocks table
  static const String supabaseUserBlocksTable2 = 'user_blocks';

  /// Supabase user likes table
  static const String supabaseUserLikesTable2 = 'user_likes';

  /// Supabase user views table
  static const String supabaseUserViewsTable2 = 'user_views';

  /// Supabase user matches table
  static const String supabaseUserMatchesTable2 = 'user_matches';

  /// Supabase user messages table
  static const String supabaseUserMessagesTable2 = 'user_messages';

  /// Supabase user notifications table
  static const String supabaseUserNotificationsTable2 = 'user_notifications';

  /// Supabase user date suggestions table
  static const String supabaseUserDateSuggestionsTable2 = 'user_date_suggestions';

  /// Supabase user charts table
  static const String supabaseUserChartsTable2 = 'user_charts';

  /// Supabase user compatibility table
  static const String supabaseUserCompatibilityTable2 = 'user_compatibility';

  /// Supabase user settings table
  static const String supabaseUserSettingsTable3 = 'user_settings';

  /// Supabase user preferences table
  static const String supabaseUserPreferencesTable2 = 'user_preferences';

  /// Supabase user profiles table
  static const String supabaseUserProfilesTable2 = 'user_profiles';
}
