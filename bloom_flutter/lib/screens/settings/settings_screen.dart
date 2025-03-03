import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/common/liquid_nav_bar_scaffold.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  /// Creates a new [SettingsScreen] instance
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return context.createSettingsScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<UserSettingsProvider>(
        builder: (context, settingsProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Account section
              _buildSectionHeader(context, 'Account'),
              _buildSettingsCard(
                context,
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Edit Profile',
                    icon: Icons.person,
                    onTap: () {
                      // Navigate to edit profile
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    title: 'Privacy Settings',
                    icon: Icons.lock,
                    onTap: () {
                      // Navigate to privacy settings
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    title: 'Blocked Users',
                    icon: Icons.block,
                    onTap: () {
                      // Navigate to blocked users
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Match Preferences section
              _buildSectionHeader(context, 'Match Preferences'),
              _buildSettingsCard(
                context,
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Date Preferences',
                    icon: Icons.favorite,
                    onTap: () {
                      // Navigate to date preferences
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    title: 'Distance Settings',
                    subtitle: 'Set maximum distance for matches',
                    icon: Icons.place,
                    onTap: () {
                      _showDistanceSettingsDialog(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Privacy & Notifications section
              _buildSectionHeader(context, 'Privacy & Notifications'),
              _buildSettingsCard(
                context,
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Privacy Settings',
                    subtitle: 'Control who can see your profile',
                    icon: Icons.lock,
                    onTap: () {
                      _showPrivacySettingsDialog(context);
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    title: 'Notifications',
                    icon: Icons.notifications,
                    onTap: () {
                      // Navigate to notification settings
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchItem(
                    context,
                    title: 'Read Receipts',
                    subtitle:
                        'Let others know when you\'ve read their messages',
                    icon: Icons.done_all,
                    value: true, // This would be from a provider in a real app
                    onChanged: (value) {
                      // Update read receipts setting
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Appearance section
              _buildSectionHeader(context, 'Appearance'),
              _buildSettingsCard(
                context,
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return _buildSwitchItem(
                        context,
                        title: 'Dark Mode',
                        icon: Icons.dark_mode,
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleThemeMode();
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Support section
              _buildSectionHeader(context, 'Support'),
              _buildSettingsCard(
                context,
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Help & Support',
                    icon: Icons.help,
                    onTap: () {
                      // Navigate to help & support
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    title: 'Privacy Policy',
                    icon: Icons.policy,
                    onTap: () {
                      // Navigate to privacy policy
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    title: 'Terms of Service',
                    icon: Icons.description,
                    onTap: () {
                      // Navigate to terms of service
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    title: 'About',
                    icon: Icons.info,
                    onTap: () {
                      // Navigate to about
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Account Management section
              _buildSectionHeader(context, 'Account Management'),
              _buildSettingsCard(
                context,
                children: [
                  _buildSettingsItem(
                    context,
                    title: 'Pause Account',
                    subtitle: 'Temporarily hide your profile from matches',
                    icon: Icons.pause_circle_outline,
                    onTap: () {
                      _showPauseAccountDialog(context);
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    context,
                    title: 'Delete Account',
                    subtitle: 'Permanently delete your account and all data',
                    icon: Icons.delete_forever,
                    onTap: () {
                      _showDeleteAccountDialog(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Logout button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return ElevatedButton.icon(
                    onPressed: () async {
                      await authProvider.signOut();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // App version
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyles.caption.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyles.subtitle1.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
  }) {
    return SwitchListTile(
      secondary: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 56,
    );
  }

  void _showDistanceSettingsDialog(BuildContext context) {
    double distance = 50.0; // Default value, would come from settings provider

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Distance Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Maximum distance: ${distance.toInt()} miles'),
                Slider(
                  value: distance,
                  min: 5,
                  max: 100,
                  divisions: 19,
                  label: '${distance.toInt()} miles',
                  onChanged: (value) {
                    setState(() {
                      distance = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Save distance setting
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPrivacySettingsDialog(BuildContext context) {
    bool showOnlineStatus = true;
    bool showLastActive = true;
    bool showProfileTo = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Privacy Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Show Online Status'),
                  value: showOnlineStatus,
                  onChanged: (value) {
                    setState(() {
                      showOnlineStatus = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Show Last Active'),
                  value: showLastActive,
                  onChanged: (value) {
                    setState(() {
                      showLastActive = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Show Profile to Everyone'),
                  value: showProfileTo,
                  onChanged: (value) {
                    setState(() {
                      showProfileTo = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Save privacy settings
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPauseAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pause Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pausing your account will hide your profile from all matches until you reactivate it. You will not receive new matches during this time.',
            ),
            SizedBox(height: 16),
            Text(
              'You can reactivate your account at any time by returning to this screen.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            onPressed: () {
              // Pause account logic
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account paused successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Pause Account'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    bool confirmDelete = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Delete Account'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Warning: This action cannot be undone. All your data, including matches, messages, and profile information will be permanently deleted.',
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                const Text(
                  'If you just want to take a break, consider pausing your account instead.',
                ),
                const SizedBox(height: 24),
                CheckboxListTile(
                  title: const Text(
                    'I understand this action is permanent',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: confirmDelete,
                  onChanged: (value) {
                    setState(() {
                      confirmDelete = value ?? false;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: confirmDelete
                    ? () {
                        // Delete account logic
                        Navigator.of(context).pop();
                        // This would typically sign the user out and navigate to login
                      }
                    : null,
                child: const Text('Delete Account'),
              ),
            ],
          );
        },
      ),
    );
  }
}
