import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../config/routes.dart';
import '../providers/auth_provider.dart';
import '../services/analytics_service.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/messages/conversation_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/onboarding/birth_information_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/profile_creation_screen.dart';
import '../screens/onboarding/questionnaire_screen.dart';
import '../screens/splash_screen.dart';

/// Analytics route observer
class AnalyticsRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _trackScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _trackScreenView(previousRoute);
    }
  }

  void _trackScreenView(Route<dynamic> route) {
    final screenName = _getScreenName(route);
    if (screenName != null) {
      // Extract route parameters if available
      final Map<String, dynamic> properties = {};

      // For MaterialPageRoute with extra data
      if (route.settings.arguments != null) {
        properties['arguments'] = route.settings.arguments.toString();
      }

      // Extract path parameters from the route name if it contains them
      if (route.settings.name != null) {
        final name = route.settings.name!;

        // For routes with parameters in the name (e.g., "MatchDetails/123")
        if (name.contains('/')) {
          final parts = name.split('/');
          if (parts.length > 1) {
            properties['id'] = parts[1];
          }
        }
      }

      AnalyticsService.trackScreenView(screenName, properties: properties);
    }
  }

  String? _getScreenName(Route<dynamic> route) {
    if (route.settings.name != null) {
      return route.settings.name;
    }

    // Try to get screen name from route settings
    final routeSettings = route.settings;
    final name = routeSettings.name;
    if (name != null && name.isNotEmpty) {
      return name;
    }

    // Try to get screen name from route
    if (route is MaterialPageRoute) {
      final widget = route.builder(route.navigator!.context);
      return widget.runtimeType.toString();
    }

    return null;
  }
}

/// App router
class AppRouter {
  /// Private constructor to prevent instantiation
  const AppRouter._();

  /// Create router
  static GoRouter createRouter(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Create analytics observer
    final analyticsObserver = AnalyticsRouteObserver();

    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      refreshListenable: authProvider,
      observers: [analyticsObserver],
      onException: (_, GoRouterState state, GoRouter router) {
        // Track navigation errors
        AnalyticsService.trackError(
          errorMessage: 'Navigation error: ${state.error}',
          errorSource: 'Router',
          stackTrace: StackTrace.current,
        );

        // Redirect to splash screen on error
        return router.go(AppRoutes.splash);
      },
      redirect: (context, state) {
        // Simplified redirect logic
        final isInitialized = authProvider.currentUser != null;
        final isSplash = state.uri.path == AppRoutes.splash;
        final isAuthRoute = state.uri.path == AppRoutes.login ||
            state.uri.path == AppRoutes.register ||
            state.uri.path == AppRoutes.forgotPassword ||
            state.uri.path == AppRoutes.resetPassword ||
            state.uri.path == AppRoutes.emailVerification;

        // If not initialized, stay on splash screen
        if (!isInitialized && !isSplash && !isAuthRoute) {
          return AppRoutes.splash;
        }

        return null;
      },
      routes: [
        // Splash screen
        GoRoute(
          path: AppRoutes.splash,
          name: 'Splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Auth routes
        GoRoute(
          path: AppRoutes.login,
          name: 'Login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'Register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          name: 'ForgotPassword',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          name: 'ResetPassword',
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.emailVerification,
          name: 'EmailVerification',
          builder: (context, state) {
            final email = state.extra as String?;
            return EmailVerificationScreen(email: email);
          },
        ),

        // Messages routes
        GoRoute(
          path: AppRoutes.messages,
          name: 'Messages',
          builder: (context, state) => const MessagesScreen(),
        ),
        GoRoute(
          path: AppRoutes.conversation,
          name: 'Conversation',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ConversationScreen(id: id);
          },
        ),

        // Home route
        GoRoute(
          path: AppRoutes.home,
          name: 'Home',
          builder: (context, state) => const HomeScreen(),
        ),

        // Onboarding routes
        GoRoute(
          path: AppRoutes.onboarding,
          name: 'Onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppRoutes.profileCreation,
          name: 'ProfileCreation',
          builder: (context, state) => const ProfileCreationScreen(),
        ),
        GoRoute(
          path: AppRoutes.birthInformation,
          name: 'BirthInformation',
          builder: (context, state) => const BirthInformationScreen(),
        ),
        GoRoute(
          path: AppRoutes.questionnaire,
          name: 'Questionnaire',
          builder: (context, state) => const QuestionnaireScreen(),
        ),

        // Placeholder route for all other paths
        GoRoute(
          path: '/:path',
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: const Text('Screen Not Implemented'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'The screen \'${state.uri.path}\' is not yet implemented'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.splash),
                    child: const Text('Go to Splash Screen'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      ),
    );
  }
}
