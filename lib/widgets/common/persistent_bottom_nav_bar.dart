import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes.dart';
import '../../theme/app_colors.dart';

/// Persistent bottom navigation bar
class PersistentBottomNavBar extends StatefulWidget {
  /// Current index
  final int currentIndex;

  /// Creates a new [PersistentBottomNavBar] instance
  const PersistentBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  State<PersistentBottomNavBar> createState() => _PersistentBottomNavBarState();
}

class _PersistentBottomNavBarState extends State<PersistentBottomNavBar> {
  final GlobalKey<CurvedNavigationBarState> _navBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: _navBarKey,
      index: widget.currentIndex,
      height: 60.0,
      items: const <Widget>[
        Icon(Icons.calendar_today, size: 30, color: Colors.white),
        Icon(Icons.message, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
        Icon(Icons.settings, size: 30, color: Colors.white),
      ],
      color: AppColors.primary,
      buttonBackgroundColor: AppColors.primary,
      backgroundColor: Colors.white,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      onTap: (index) {
        _navigateToTab(index);
      },
    );
  }

  void _navigateToTab(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.dateSuggestions);
        break;
      case 1:
        context.go(AppRoutes.messages);
        break;
      case 2:
        context.go(AppRoutes.profile);
        break;
      case 3:
        context.go(AppRoutes.settings);
        break;
    }
  }
}

/// Navigation bar scaffold
class NavBarScaffold extends StatelessWidget {
  /// Current index
  final int currentIndex;

  /// Body
  final Widget body;

  /// App bar
  final PreferredSizeWidget? appBar;

  /// Creates a new [NavBarScaffold] instance
  const NavBarScaffold({
    super.key,
    required this.currentIndex,
    required this.body,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: PersistentBottomNavBar(
        currentIndex: currentIndex,
      ),
    );
  }
}
