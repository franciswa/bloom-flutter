import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'config/app_config.dart';
import 'navigation/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'services/analytics_service.dart';
import 'theme/app_theme.dart';

/// Bloom app
class BloomApp extends StatelessWidget {
  /// Creates a new [BloomApp] instance
  const BloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final router = AppRouter.createRouter(context);

    return MaterialApp.router(
      // App info
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,

      // Routing
      routerConfig: router,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('es', 'ES'), // Spanish
        Locale('fr', 'FR'), // French
        Locale('de', 'DE'), // German
        Locale('it', 'IT'), // Italian
        Locale('pt', 'BR'), // Portuguese
        Locale('ja', 'JP'), // Japanese
        Locale('ko', 'KR'), // Korean
        Locale('zh', 'CN'), // Chinese (Simplified)
      ],

      // Builder
      builder: (context, child) {
        // Apply text scaling
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}

/// Bloom app with providers
class BloomAppWithProviders extends StatefulWidget {
  /// Creates a new [BloomAppWithProviders] instance
  const BloomAppWithProviders({super.key});

  @override
  State<BloomAppWithProviders> createState() => _BloomAppWithProvidersState();
}

class _BloomAppWithProvidersState extends State<BloomAppWithProviders>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground
        AnalyticsService.trackAppForeground();
        break;
      case AppLifecycleState.paused:
        // App went to background
        AnalyticsService.trackAppBackground();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return const BloomApp();
      },
    );
  }
}
