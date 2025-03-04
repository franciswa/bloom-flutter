import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chart_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/questionnaire_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/chart/chart_view_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/liquid_nav_bar_scaffold.dart';
import '../../widgets/questionnaire/questionnaire_answers_widget.dart';

/// Profile screen
class ProfileScreen extends StatelessWidget {
  /// Creates a new [ProfileScreen] instance
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final chartProvider = Provider.of<ChartProvider>(context);
    final questionnaireProvider = Provider.of<QuestionnaireProvider>(context);

    return context.createProfileScaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(
              child: LoadingIndicator(),
            );
          }

          final profile = profileProvider.currentProfile;
          if (profile == null) {
            return const Center(
              child: Text('Profile not found'),
            );
          }

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                // Tab bar
                const TabBar(
                  tabs: [
                    Tab(text: 'Basic Info'),
                    Tab(text: 'Questionnaire'),
                    Tab(text: 'Birth Chart'),
                  ],
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    children: [
                      // Basic Info Tab
                      _buildBasicInfoTab(context, profile, authProvider),

                      // Questionnaire Tab
                      _buildQuestionnaireTab(context, questionnaireProvider),

                      // Birth Chart Tab
                      _buildBirthChartTab(context, chartProvider),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build basic info tab
  Widget _buildBasicInfoTab(
      BuildContext context, dynamic profile, AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile photo
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            backgroundImage: profile.profilePhotoUrl != null
                ? NetworkImage(profile.profilePhotoUrl!)
                : null,
            child: profile.profilePhotoUrl == null
                ? const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.primary,
                  )
                : null,
          ),
          const SizedBox(height: 16),

          // Display name
          Text(
            profile.displayName,
            style: TextStyles.headline4,
          ),
          const SizedBox(height: 8),

          // Full name and age
          Text(
            '${profile.fullName}, ${profile.age}',
            style: TextStyles.subtitle1,
          ),
          const SizedBox(height: 16),

          // Bio
          if (profile.bio != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
              child: Text(
                profile.bio!,
                style: TextStyles.body1,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Zodiac sign
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                profile.zodiacSign.toString().split('.').last,
                style: TextStyles.subtitle1.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Location
          if (profile.currentLocation != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  profile.currentLocation!,
                  style: TextStyles.body2,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // Edit profile button
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to edit profile
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
          const SizedBox(height: 16),

          // Logout button
          TextButton.icon(
            onPressed: () async {
              await authProvider.signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  /// Build questionnaire tab
  Widget _buildQuestionnaireTab(
      BuildContext context, QuestionnaireProvider provider) {
    return QuestionnaireAnswersWidget(
      onEdit: () {
        Navigator.of(context).pushNamed(AppRoutes.questionnaire);
      },
    );
  }

  /// Build birth chart tab
  Widget _buildBirthChartTab(BuildContext context, ChartProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: LoadingIndicator(),
      );
    }

    if (!provider.hasChart) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No birth chart available',
              style: TextStyles.headline5,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.birthInformation);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Birth Information'),
            ),
          ],
        ),
      );
    }

    return ChartViewWidget(
      chart: provider.currentUserChart!,
    );
  }
}
