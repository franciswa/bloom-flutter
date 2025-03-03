import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/common/persistent_bottom_nav_bar.dart';

/// Home screen
class HomeScreen extends StatelessWidget {
  /// Creates a new [HomeScreen] instance
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return NavBarScaffold(
      currentIndex: 0,
      appBar: AppBar(
        title: const Text('Bloom'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite,
              color: AppColors.primary,
              size: 100,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Bloom!',
              style: TextStyles.headline2,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cosmic connection awaits',
              style: TextStyles.subtitle1,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                context.go(AppRoutes.discovery);
              },
              child: const Text('Start Exploring'),
            ),
          ],
        ),
      ),
    );
  }
}
