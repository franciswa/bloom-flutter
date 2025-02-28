/// App routes
class AppRoutes {
  /// Private constructor to prevent instantiation
  const AppRoutes._();

  // Auth routes
  /// Splash route
  static const String splash = '/';

  /// Login route
  static const String login = '/login';

  /// Register route
  static const String register = '/register';

  /// Forgot password route
  static const String forgotPassword = '/forgot-password';

  /// Reset password route
  static const String resetPassword = '/reset-password';

  /// Email verification route
  static const String emailVerification = '/email-verification';

  // Onboarding routes
  /// Onboarding route
  static const String onboarding = '/onboarding';

  /// Profile creation route
  static const String profileCreation = '/onboarding/profile';

  /// Birth information route
  static const String birthInformation = '/onboarding/birth-info';

  /// Questionnaire route
  static const String questionnaire = '/onboarding/questionnaire';

  /// Preferences route
  static const String preferences = '/onboarding/preferences';

  // Main app routes
  /// Home route
  static const String home = '/home';

  /// Discovery route
  static const String discovery = '/discovery';

  /// Match details route
  static const String matchDetails = '/match/:id';

  /// Compatibility details route
  static const String compatibilityDetails = '/compatibility/:id';

  /// Messages route
  static const String messages = '/messages';

  /// Conversation route
  static const String conversation = '/messages/:id';

  /// Profile route
  static const String profile = '/profile';

  /// Edit profile route
  static const String editProfile = '/profile/edit';

  /// Settings route
  static const String settings = '/settings';

  /// Notifications route
  static const String notifications = '/notifications';

  /// Date suggestions route
  static const String dateSuggestions = '/date-suggestions';

  /// Date suggestion details route
  static const String dateSuggestionDetails = '/date-suggestions/:id';

  /// Chart details route
  static const String chartDetails = '/chart/:id';

  /// Questionnaire results route
  static const String questionnaireResults = '/questionnaire-results/:id';

  /// Blocked users route
  static const String blockedUsers = '/blocked-users';

  /// Privacy policy route
  static const String privacyPolicy = '/privacy-policy';

  /// Terms of service route
  static const String termsOfService = '/terms-of-service';

  /// Help and support route
  static const String helpAndSupport = '/help-and-support';

  /// About route
  static const String about = '/about';

  // Helper methods
  /// Get match details route
  static String getMatchDetailsRoute(String id) => '/match/$id';

  /// Get compatibility details route
  static String getCompatibilityDetailsRoute(String id) => '/compatibility/$id';

  /// Get conversation route
  static String getConversationRoute(String id) => '/messages/$id';

  /// Get date suggestion details route
  static String getDateSuggestionDetailsRoute(String id) => '/date-suggestions/$id';

  /// Get chart details route
  static String getChartDetailsRoute(String id) => '/chart/$id';

  /// Get questionnaire results route
  static String getQuestionnaireResultsRoute(String id) => '/questionnaire-results/$id';
}
