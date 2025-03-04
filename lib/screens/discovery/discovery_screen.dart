import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/profile.dart';
import '../../providers/profile_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/persistent_bottom_nav_bar.dart';

/// Discovery screen
class DiscoveryScreen extends StatefulWidget {
  /// Creates a new [DiscoveryScreen] instance
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  bool _isLoading = false;
  List<dynamic> _profiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      // In a real app, we would use the user's preferences to filter profiles
      final profiles = await profileProvider.getRecommendedProfiles(
        gender: Gender.female, // Example filter
        lookingFor: LookingFor.everyone, // Example filter
        minAge: 18,
        maxAge: 50,
      );

      if (mounted) {
        setState(() {
          _profiles = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profiles: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavBarScaffold(
      currentIndex: 1, // Discovery tab
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: LoadingIndicator(),
            )
          : _profiles.isEmpty
              ? _buildEmptyState()
              : _buildProfileGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.iconTertiary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No profiles found',
            style: TextStyles.headline6,
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search filters',
            style: TextStyles.body2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProfiles,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileGrid() {
    return RefreshIndicator(
      onRefresh: _loadProfiles,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _profiles.length,
        itemBuilder: (context, index) {
          final profile = _profiles[index];
          return _buildProfileCard(profile);
        },
      ),
    );
  }

  Widget _buildProfileCard(dynamic profile) {
    return GestureDetector(
      onTap: () {
        // Navigate to profile details
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile photo
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Profile image
                  profile.profilePhotoUrl != null
                      ? Image.network(
                          profile.profilePhotoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.primary.withOpacity(0.2),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.primary,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.primary.withOpacity(0.2),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        ),

                  // Zodiac sign badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        profile.zodiacSign.toString().split('.').last,
                        style: TextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Profile info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.displayName}, ${profile.age}',
                      style: TextStyles.subtitle1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (profile.currentLocation != null) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              profile.currentLocation!,
                              style: TextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    if (profile.bio != null) ...[
                      Text(
                        profile.bio!,
                        style: TextStyles.caption,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
