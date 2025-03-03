import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'app.dart';
import 'config/app_config.dart';
import 'providers/provider_registry.dart';
import 'services/analytics_service.dart';
import 'services/cache_service.dart';
import 'utils/error_handling.dart';

// Global error handler for uncaught errors
void _handleUncaughtError(Object error, StackTrace stackTrace) {
  debugPrint('Uncaught error: $error');
  // Report to Sentry
  try {
    Sentry.captureException(error, stackTrace: stackTrace);
  } catch (_) {
    // Ignore errors in error reporting
  }
}

Future<void> main() async {
  // Set up error handling for the entire app
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    _handleUncaughtError(
        details.exception, details.stack ?? StackTrace.current);
  };

  // Handle errors in the Zone
  runZonedGuarded(() async {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Set preferred orientations
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (e, stackTrace) {
      debugPrint('Failed to set preferred orientations: $e');
      ErrorHandler.logError(e, stackTrace: stackTrace);
      // Continue anyway, this is not critical
    }

    // Set system UI overlay style
    try {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Failed to set system UI overlay style: $e');
      ErrorHandler.logError(e, stackTrace: stackTrace);
      // Continue anyway, this is not critical
    }

    // Initialize app configuration
    try {
      await AppConfig.initialize(AppEnvironment.development);
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize app configuration: $e');
      ErrorHandler.logError(e, stackTrace: stackTrace);
      // This is critical, but we'll try to continue with default values
      // AppConfig should have fallback values for critical settings
    }

    // Initialize cache service
    try {
      await CacheService.initialize();
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize cache service: $e');
      ErrorHandler.logError(e, stackTrace: stackTrace);
      // Continue anyway, the app can function without cache
    }

    // Check connectivity before initializing Supabase
    bool isConnected = false;
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      isConnected =
          connectivityResult.contains(ConnectivityResult.none) == false;
    } catch (e) {
      debugPrint('Failed to check connectivity: $e');
      // Assume connected and try anyway
      isConnected = true;
    }

    // Initialize Supabase
    if (isConnected) {
      try {
        // Skip Supabase initialization in web for now
        if (!kIsWeb) {
          await Supabase.initialize(
            url: AppConfig.supabaseUrl,
            anonKey: AppConfig.supabaseAnonKey,
            // Use default auth flow
            realtimeClientOptions: const RealtimeClientOptions(
              eventsPerSecond: 10,
            ),
          );
          debugPrint('Supabase initialized successfully');
        } else {
          debugPrint(
              'Web environment detected, skipping Supabase initialization');
        }
      } catch (e, stackTrace) {
        debugPrint('Failed to initialize Supabase: $e');
        ErrorHandler.logError(e, stackTrace: stackTrace);
        // This is critical, but we'll try to continue with offline mode
      }
    } else {
      debugPrint('No internet connection, skipping Supabase initialization');
    }

    // Initialize PostHog analytics (non-blocking)
    try {
      // Skip analytics initialization in web for now
      if (!kIsWeb) {
        await AnalyticsService.initialize();
        // Track app start event
        unawaited(AnalyticsService.trackAppStart());
      } else {
        debugPrint(
            'Web environment detected, skipping analytics initialization');
      }
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize analytics: $e');
      ErrorHandler.logError(e, stackTrace: stackTrace);
      // Continue anyway, analytics is not critical
    }

    // Initialize Sentry
    try {
      // Skip Sentry initialization in web for now
      if (!kIsWeb) {
        await SentryFlutter.init(
          (options) {
            options.dsn = AppConfig.sentryDsn;
            options.tracesSampleRate = 1.0; // Capture 100% of transactions
            options.enableAutoSessionTracking = true;
            options.attachStacktrace = true;
            options.enableNativeCrashHandling = true;
          },
          appRunner: () => runApp(const MyApp()),
        );
      } else {
        debugPrint('Web environment detected, skipping Sentry initialization');
        // Just run the app directly in web
        runApp(const MyApp());
      }
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize Sentry: $e');
      ErrorHandler.logError(e, stackTrace: stackTrace);
      // If Sentry fails, just run the app directly
      runApp(const MyApp());
    }
  }, _handleUncaughtError);
}

/// My app
class MyApp extends StatelessWidget {
  /// Creates a new [MyApp] instance
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderRegistry.createProviders(),
      child: const BloomAppWithProviders(),
    );
  }
}
