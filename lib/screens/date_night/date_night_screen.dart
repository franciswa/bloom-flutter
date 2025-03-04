import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../models/astrology.dart';
import '../../providers/date_request_manager_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/helpers/ui_helpers.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/liquid_nav_bar_scaffold.dart';
import '../../widgets/zodiac/zodiac_selector.dart';

/// DateNight screen
class DateNightScreen extends StatefulWidget {
  /// Creates a new [DateNightScreen] instance
  const DateNightScreen({super.key});

  @override
  State<DateNightScreen> createState() => _DateNightScreenState();
}

class _DateNightScreenState extends State<DateNightScreen> {
  ZodiacSign? _selectedSign;

  void _handleSelectSign(ZodiacSign sign) {
    final dateRequestManagerProvider =
        Provider.of<DateRequestManagerProvider>(context, listen: false);

    // Check if user has reached the limit
    if (dateRequestManagerProvider.hasReachedLimit()) {
      // Show error dialog
      UIHelpers.showErrorDialog(
        context: context,
        title: 'Date Request Limit Reached',
        message:
            'You can have a maximum of 3 active date requests and conversations combined. Please complete or cancel some of your existing requests before creating a new one.',
      );
      return;
    }

    setState(() {
      _selectedSign = sign;
    });

    // Navigate to date type selection screen
    context.push(
      AppRoutes.dateTypeSelection,
      extra: sign,
    );
  }

  void _navigateToDatePreferences() {
    // Navigate to date preferences screen
    // For now, we'll just show a dialog since we don't have that screen yet
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Date Preferences'),
        content: const Text(
          'Date preferences screen coming soon!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.createDateSuggestionsScaffold(
      appBar: AppBar(
        title: const Text('Date Night'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToDatePreferences,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Choose Your Date\'s Sign',
                  style: TextStyles.headline3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rotate the wheel to select the zodiac sign you\'d like to match with',
                  style: TextStyles.body2.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Zodiac selector
          Expanded(
            child: Center(
              child: ZodiacSelector(
                onSelectSign: _handleSelectSign,
              ),
            ),
          ),

          // Bottom section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_selectedSign != null)
                  Text(
                    'Selected: ${_selectedSign!.name}',
                    style: TextStyles.subtitle1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 16),
                // Date request limit info
                Consumer<DateRequestManagerProvider>(
                  builder: (context, provider, child) {
                    final remainingRequests =
                        provider.getRemainingDateRequests();
                    final hasReachedLimit = provider.hasReachedLimit();

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: hasReachedLimit
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: hasReachedLimit
                              ? Colors.red.withOpacity(0.5)
                              : Colors.green.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hasReachedLimit
                                ? Icons.error_outline
                                : Icons.check_circle_outline,
                            color: hasReachedLimit ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              hasReachedLimit
                                  ? 'You have reached the maximum of 3 active date requests and conversations.'
                                  : 'You have $remainingRequests remaining date requests available (max 3).',
                              style: TextStyles.body2.copyWith(
                                color:
                                    hasReachedLimit ? Colors.red : Colors.green,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'View Date Preferences',
                  onPressed: _navigateToDatePreferences,
                  type: ButtonType.outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
