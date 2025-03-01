import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/helpers/ui_helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Birth information screen
class BirthInformationScreen extends StatefulWidget {
  /// Creates a new [BirthInformationScreen] instance
  const BirthInformationScreen({super.key});

  @override
  State<BirthInformationScreen> createState() => _BirthInformationScreenState();
}

class _BirthInformationScreenState extends State<BirthInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _birthDateController = TextEditingController();
  final _birthTimeController = TextEditingController();
  final _birthCityController = TextEditingController();
  final _birthCountryController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  @override
  void dispose() {
    _birthDateController.dispose();
    _birthTimeController.dispose();
    _birthCityController.dispose();
    _birthCountryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text =
            '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _birthTimeController.text = picked.format(context);
      });
    }
  }

  Future<void> _saveBirthInformation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        if (authProvider.currentUser == null || !profileProvider.hasProfile) {
          throw Exception('User not authenticated or profile not created');
        }

        // Get current profile
        final currentProfile = profileProvider.currentProfile!;

        // Create birth location string
        final birthLocation =
            '${_birthCityController.text.trim()}, ${_birthCountryController.text.trim()}';

        // Format birth time as HH:MM
        String? birthTime;
        if (_selectedTime != null) {
          final hour = _selectedTime!.hour.toString().padLeft(2, '0');
          final minute = _selectedTime!.minute.toString().padLeft(2, '0');
          birthTime = '$hour:$minute';
        }

        // Update profile with birth information
        final updatedProfile = currentProfile.copyWith(
          birthDate: _selectedDate ?? currentProfile.birthDate,
          birthTime: () => birthTime,
          birthCity: _birthCityController.text.trim(),
          birthCountry: _birthCountryController.text.trim(),
          birthLocation: birthLocation,
          // We would normally set latitude and longitude here based on geocoding the location
          // For now, we'll leave them as null
        );

        // Save updated profile
        await profileProvider.updateProfile(updatedProfile);

        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          context.go(AppRoutes.questionnaire);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          UIHelpers.showErrorDialog(
            context: context,
            title: 'Error Saving Birth Information',
            message: UIHelpers.getErrorMessage(e),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Birth Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Birth Details',
                  style: TextStyles.headline2,
                ),
                const SizedBox(height: 8),
                Text(
                  'We need your birth information to calculate your astrological chart.',
                  style: TextStyles.body1,
                ),
                const SizedBox(height: 32),

                // Birth date
                CustomTextField(
                  controller: _birthDateController,
                  labelText: 'Birth Date',
                  hintText: 'MM/DD/YYYY',
                  prefixIcon: const Icon(Icons.calendar_today),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: Validators.validateRequired,
                ),
                const SizedBox(height: 16),

                // Birth time
                CustomTextField(
                  controller: _birthTimeController,
                  labelText: 'Birth Time (if known)',
                  hintText: 'HH:MM AM/PM',
                  prefixIcon: const Icon(Icons.access_time),
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  validator: Validators.validateTimeOfBirth,
                ),
                const SizedBox(height: 16),

                // Birth city
                CustomTextField(
                  controller: _birthCityController,
                  labelText: 'Birth City',
                  hintText: 'Enter your birth city',
                  prefixIcon: const Icon(Icons.location_city),
                  validator: Validators.validateRequired,
                ),
                const SizedBox(height: 16),

                // Birth country
                CustomTextField(
                  controller: _birthCountryController,
                  labelText: 'Birth Country',
                  hintText: 'Enter your birth country',
                  prefixIcon: const Icon(Icons.public),
                  validator: Validators.validateRequired,
                ),
                const SizedBox(height: 32),

                // Save button
                CustomButton(
                  text: 'Continue',
                  isLoading: _isLoading,
                  onPressed: _saveBirthInformation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
