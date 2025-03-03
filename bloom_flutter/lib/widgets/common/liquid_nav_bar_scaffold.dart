import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../../config/routes.dart';
import '../../theme/app_colors.dart';
import 'persistent_bottom_nav_bar.dart';

/// Liquid Navigation Bar Scaffold
///
/// A scaffold that combines liquid swipe with the persistent bottom navigation bar
class LiquidNavBarScaffold extends StatefulWidget {
  /// Current index
  final int currentIndex;

  /// Pages to display
  final List<Widget> pages;

  /// App bar
  final PreferredSizeWidget? appBar;

  /// Creates a new [LiquidNavBarScaffold] instance
  const LiquidNavBarScaffold({
    super.key,
    required this.currentIndex,
    required this.pages,
    this.appBar,
  });

  @override
  State<LiquidNavBarScaffold> createState() => _LiquidNavBarScaffoldState();
}

class _LiquidNavBarScaffoldState extends State<LiquidNavBarScaffold> {
  late int _currentIndex;
  late LiquidController _liquidController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _liquidController = LiquidController();
  }

  @override
  void didUpdateWidget(LiquidNavBarScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _currentIndex) {
      setState(() {
        _currentIndex = widget.currentIndex;
      });
      // Animate to the new page when the index changes externally
      _liquidController.animateToPage(
        page: _currentIndex,
        duration: 400,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create liquid pages with waveType and enableSideReveal for better effect
    final pages = widget.pages.map((page) {
      return Container(
        color: Colors.white,
        child: page,
      );
    }).toList();

    return Scaffold(
      appBar: widget.appBar,
      body: Stack(
        children: [
          LiquidSwipe(
            pages: pages,
            liquidController: _liquidController,
            enableLoop: false,
            fullTransitionValue: 600, // Adjust for sensitivity
            enableSideReveal: true,
            slideIconWidget: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primary,
            ),
            waveType: WaveType.liquidReveal,
            onPageChangeCallback: (index) {
              if (index != _currentIndex) {
                setState(() {
                  _currentIndex = index;
                });
                _navigateToTab(index);
              }
            },
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: _buildPageIndicator(),
          ),
        ],
      ),
      bottomNavigationBar: PersistentBottomNavBar(
        currentIndex: _currentIndex,
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(widget.pages.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.3),
            ),
          );
        }),
      ),
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

/// Helper extension to create liquid nav bar scaffolds for main screens
extension LiquidNavBarScaffoldExtension on BuildContext {
  /// Create a liquid nav bar scaffold for the date suggestions screen
  Widget createDateSuggestionsScaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
  }) {
    return LiquidNavBarScaffold(
      currentIndex: 0,
      pages: _getMainPages(body),
      appBar: appBar,
    );
  }

  /// Create a liquid nav bar scaffold for the messages screen
  Widget createMessagesScaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
  }) {
    return LiquidNavBarScaffold(
      currentIndex: 1,
      pages: _getMainPages(body),
      appBar: appBar,
    );
  }

  /// Create a liquid nav bar scaffold for the profile screen
  Widget createProfileScaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
  }) {
    return LiquidNavBarScaffold(
      currentIndex: 2,
      pages: _getMainPages(body),
      appBar: appBar,
    );
  }

  /// Create a liquid nav bar scaffold for the settings screen
  Widget createSettingsScaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
  }) {
    return LiquidNavBarScaffold(
      currentIndex: 3,
      pages: _getMainPages(body),
      appBar: appBar,
    );
  }

  /// Get the main pages for the liquid nav bar scaffold
  List<Widget> _getMainPages(Widget currentBody) {
    // We need to create placeholder widgets for the other pages
    // These will be replaced when navigating to those pages
    return [
      currentBody, // Date Suggestions
      _createPlaceholderIfNeeded(currentBody, 0),
      _createPlaceholderIfNeeded(currentBody, 1),
      _createPlaceholderIfNeeded(currentBody, 2),
    ];
  }

  /// Create a placeholder widget if the current body is not for the specified index
  Widget _createPlaceholderIfNeeded(Widget currentBody, int targetIndex) {
    // If we're already showing the body for this index, return it
    // Otherwise return a placeholder
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
