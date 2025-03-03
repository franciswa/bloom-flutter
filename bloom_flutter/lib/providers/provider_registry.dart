import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'auth_provider.dart';
import 'chart_provider.dart';
import 'compatibility_provider.dart';
import 'date_preference_provider.dart';
import 'date_request_manager_provider.dart';
import 'match_provider.dart';
import 'message_provider.dart';
import 'notification_provider.dart';
import 'profile_provider.dart';
import 'questionnaire_provider.dart';
import 'theme_provider.dart';
import 'user_settings_provider.dart';

/// Provider registry
class ProviderRegistry {
  /// Private constructor to prevent instantiation
  const ProviderRegistry._();

  /// Create providers
  static List<SingleChildWidget> createProviders() {
    return [
      // Auth provider
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(),
      ),

      // Theme provider
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
      ),

      // Profile provider
      ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
        create: (context) => ProfileProvider(
          authProvider: Provider.of<AuthProvider>(context, listen: false),
        ),
        update: (context, authProvider, previous) {
          previous!.update(authProvider: authProvider);
          return previous;
        },
      ),

      // Chart provider
      ChangeNotifierProxyProvider2<AuthProvider, ProfileProvider,
          ChartProvider>(
        create: (context) => ChartProvider(
          authProvider: Provider.of<AuthProvider>(context, listen: false),
          profileProvider: Provider.of<ProfileProvider>(context, listen: false),
        ),
        update: (context, authProvider, profileProvider, previous) {
          previous!.updateAuthProvider(authProvider: authProvider);
          previous.updateProfileProvider(profileProvider: profileProvider);
          return previous;
        },
      ),

      // Compatibility provider
      ChangeNotifierProxyProvider3<AuthProvider, ProfileProvider, ChartProvider,
          CompatibilityProvider>(
        create: (context) => CompatibilityProvider(
          authProvider: Provider.of<AuthProvider>(context, listen: false),
          profileProvider: Provider.of<ProfileProvider>(context, listen: false),
          chartProvider: Provider.of<ChartProvider>(context, listen: false),
        ),
        update:
            (context, authProvider, profileProvider, chartProvider, previous) {
          previous!.updateAuthProvider(authProvider: authProvider);
          previous.updateProfileProvider(profileProvider: profileProvider);
          previous.updateChartProvider(chartProvider: chartProvider);
          return previous;
        },
      ),

      // Match provider
      ChangeNotifierProxyProvider2<AuthProvider, ProfileProvider,
          MatchProvider>(
        create: (context) => MatchProvider(
          authProvider: Provider.of<AuthProvider>(context, listen: false),
          profileProvider: Provider.of<ProfileProvider>(context, listen: false),
        ),
        update: (context, authProvider, profileProvider, previous) {
          previous!.updateAuthProvider(authProvider: authProvider);
          previous.updateProfileProvider(profileProvider: profileProvider);
          return previous;
        },
      ),

      // Message provider
      ChangeNotifierProxyProvider2<AuthProvider, MatchProvider,
          MessageProvider>(
        create: (context) => MessageProvider(
          authProvider: Provider.of<AuthProvider>(context, listen: false),
          matchProvider: Provider.of<MatchProvider>(context, listen: false),
        ),
        update: (context, authProvider, matchProvider, previous) {
          previous!.updateAuthProvider(authProvider: authProvider);
          previous.updateMatchProvider(matchProvider: matchProvider);
          return previous;
        },
      ),

      // Notification provider
      ChangeNotifierProxyProvider<AuthProvider, NotificationProvider>(
        create: (context) => NotificationProvider(
          authProvider: Provider.of<AuthProvider>(context, listen: false),
        ),
        update: (context, authProvider, previous) {
          previous!.updateAuthProvider(authProvider: authProvider);
          return previous;
        },
      ),

      // Date preference provider
      ChangeNotifierProxyProvider2<AuthProvider, ProfileProvider,
          DatePreferenceProvider>(
        create: (context) => DatePreferenceProvider(
          authProvider: Provider.of<AuthProvider>(context, listen: false),
          profileProvider: Provider.of<ProfileProvider>(context, listen: false),
        ),
        update: (context, authProvider, profileProvider, previous) {
          previous!.updateAuthProvider(authProvider: authProvider);
          previous.updateProfileProvider(profileProvider: profileProvider);
          return previous;
        },
      ),

      // User settings provider
      ChangeNotifierProxyProvider2<AuthProvider, ThemeProvider,
          UserSettingsProvider>(
        create: (context) => UserSettingsProvider(
          authProvider: Provider.of<AuthProvider>(context, listen: false),
          themeProvider: Provider.of<ThemeProvider>(context, listen: false),
        ),
        update: (context, authProvider, themeProvider, previous) {
          previous!.updateAuthProvider(authProvider: authProvider);
          return previous;
        },
      ),

      // Questionnaire provider
      ChangeNotifierProxyProvider<AuthProvider, QuestionnaireProvider>(
        create: (context) => QuestionnaireProvider(
          authProvider: Provider.of<AuthProvider>(context, listen: false),
        ),
        update: (context, authProvider, previous) {
          previous!.updateAuthProvider(authProvider: authProvider);
          return previous;
        },
      ),

      // Date request manager provider
      ChangeNotifierProxyProvider2<MessageProvider, DatePreferenceProvider,
          DateRequestManagerProvider>(
        create: (context) => DateRequestManagerProvider(
          messageProvider: Provider.of<MessageProvider>(context, listen: false),
          datePreferenceProvider:
              Provider.of<DatePreferenceProvider>(context, listen: false),
        ),
        update: (context, messageProvider, datePreferenceProvider, previous) {
          previous!.updateMessageProvider(messageProvider: messageProvider);
          previous.updateDatePreferenceProvider(
              datePreferenceProvider: datePreferenceProvider);
          return previous;
        },
      ),
    ];
  }
}
