import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../models/profile.dart';
import '../../models/astrology.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../theme/text_styles.dart';
import '../../utils/helpers/ui_helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Profile creation screen
class ProfileCreationScreen extends StatefulWidget {
  /// Creates a new [ProfileCreationScreen] instance
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();

  String? _selectedGender;
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say'
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        if (authProvider.currentUser == null) {
          throw Exception('User not authenticated');
        }

        // Convert gender string to Gender enum
        Gender gender;
        switch (_selectedGender) {
          case 'Male':
            gender = Gender.male;
            break;
          case 'Female':
            gender = Gender.female;
            break;
          case 'Non-binary':
            gender = Gender.nonBinary;
            break;
          default:
            gender = Gender.preferNotToSay;
        }

        // Create a partial profile with the information we have so far
        final profile = Profile(
          userId: authProvider.currentUser!.id,
          displayName: _displayNameController.text.trim(),
          firstName: _displayNameController.text
              .trim(), // Use display name as first name for now
          lastName: null,
          birthDate: DateTime.now().subtract(const Duration(
              days: 365 *
                  25)), // Default age, will be updated in birth info screen
          birthTime: null,
          birthCity: '', // Will be filled in birth info screen
          birthCountry: '', // Will be filled in birth info screen
          birthLocation: '', // Will be filled in birth info screen
          birthLatitude: null,
          birthLongitude: null,
          currentLocation: null,
          currentLatitude: null,
          currentLongitude: null,
          bio: _bioController.text.trim(),
          gender: gender,
          zodiacSign: ZodiacSign.aries, // Default, will be calculated later
          lookingFor:
              LookingFor.everyone, // Default, can be updated in preferences
          minAgePreference: 18,
          maxAgePreference: 99,
          maxDistancePreference: 100.0,
          profilePhotoUrl: null,
          photoUrls: const [],
          isProfileComplete: false, // Not complete until all steps are done
          isProfileVisible: false, // Not visible until profile is complete
          isOnline: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save the profile
        await profileProvider.createProfile(profile);

        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          context.go(AppRoutes.birthInformation);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          UIHelpers.showErrorDialog(
            context: context,
            title: 'Error Saving Profile',
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
        title: const Text('Create Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Your Profile',
                  style: TextStyles.headline2,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tell us a bit about yourself to get started.',
                  style: TextStyles.body1,
                ),
                const SizedBox(height: 32),

                // Profile photo
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 20,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              // Add photo functionality would go here
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Display name
                CustomTextField(
                  controller: _displayNameController,
                  labelText: 'Display Name',
                  hintText: 'Enter your display name',
                  prefixIcon: const Icon(Icons.person),
                  validator: Validators.validateRequired,
                ),
                const SizedBox(height: 16),

                // Gender
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: const Icon(Icons.people),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: _selectedGender,
                  hint: const Text('Select your gender'),
                  items: _genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Bio
                CustomTextField(
                  controller: _bioController,
                  labelText: 'Bio',
                  hintText: 'Tell us about yourself',
                  prefixIcon: const Icon(Icons.description),
                  maxLines: 3,
                  validator: Validators.validateRequired,
                ),
                const SizedBox(height: 32),

                // Save button
                CustomButton(
                  text: 'Continue',
                  isLoading: _isLoading,
                  onPressed: _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
