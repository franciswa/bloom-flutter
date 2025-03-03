import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../models/astrology.dart';
import '../../models/date_preference.dart';
import '../../providers/auth_provider.dart';
import '../../providers/date_preference_provider.dart';
import '../../providers/date_request_manager_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/helpers/ui_helpers.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_indicator.dart';

/// Extension for DateType
extension DateTypeNameExtension on DateType {
  /// Get date type name
  String get name {
    switch (this) {
      case DateType.dining:
        return 'Dining';
      case DateType.coffee:
        return 'Coffee';
      case DateType.drinks:
        return 'Drinks';
      case DateType.outdoors:
        return 'Outdoors';
      case DateType.entertainment:
        return 'Entertainment';
      case DateType.cultural:
        return 'Cultural';
      case DateType.sports:
        return 'Sports';
      case DateType.other:
        return 'Other';
    }
  }
}

/// DateTypeSelectionScreen
class DateTypeSelectionScreen extends StatefulWidget {
  /// Selected sign
  final ZodiacSign selectedSign;

  /// Creates a new [DateTypeSelectionScreen] instance
  const DateTypeSelectionScreen({
    super.key,
    required this.selectedSign,
  });

  @override
  State<DateTypeSelectionScreen> createState() =>
      _DateTypeSelectionScreenState();
}

class _DateTypeSelectionScreenState extends State<DateTypeSelectionScreen> {
  DateType? _selectedType;
  bool _isLoading = false;
  String? _error;

  void _handleSelectType(DateType type) {
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
      _selectedType = type;
    });

    // Create date preference immediately
    _createDatePreference(type);
  }

  Future<void> _createDatePreference(DateType type) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final datePreferenceProvider =
          Provider.of<DatePreferenceProvider>(context, listen: false);

      if (authProvider.currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Create date preference
      await datePreferenceProvider.createDatePreference(
        DatePreference.defaultPreference(authProvider.currentUser!.id).copyWith(
          preferredTypes: [type],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Navigate back to date night screen
      if (mounted) {
        context.go(AppRoutes.dateSuggestions);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingIndicator(),
              SizedBox(height: 16),
              Text('Creating your date preference...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Date Type'),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  widget.selectedSign.symbol,
                  style: const TextStyle(
                    fontSize: 48,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose Your Date Type',
                  style: TextStyles.headline3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'What kind of date would you like to go on with your ${widget.selectedSign.name}?',
                  style: TextStyles.body2.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _error!,
                      style: TextStyles.body2.copyWith(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),

          // Date type options
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: DateType.values.length,
              itemBuilder: (context, index) {
                final type = DateType.values[index];
                final isSelected = _selectedType == type;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CustomButton(
                    text: type.name,
                    onPressed: () => _handleSelectType(type),
                    type: isSelected ? ButtonType.primary : ButtonType.outline,
                    backgroundColor: isSelected ? AppColors.primary : null,
                    foregroundColor: isSelected ? Colors.white : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
