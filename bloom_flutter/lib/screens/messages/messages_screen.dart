import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../utils/error_handling.dart';
import '../../models/message.dart';
import '../../models/profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';
import '../../providers/profile_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/helpers/ui_helpers.dart';
import '../../widgets/common/loading_indicator.dart';
import 'widgets/conversation_tile.dart';

/// Messages screen
class MessagesScreen extends StatefulWidget {
  /// Creates a new [MessagesScreen] instance
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // Cache for user profiles
  final Map<String, Profile?> _profileCache = {};

  @override
  void initState() {
    super.initState();
    _refreshConversations();
  }

  Future<void> _refreshConversations() async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    await messageProvider.refreshConversations();

    // Preload profiles for all conversations
    _preloadProfiles();
  }

  Future<void> _preloadProfiles() async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    if (authProvider.currentUser == null) return;

    final currentUserId = authProvider.currentUser!.id;

    for (final conversation in messageProvider.conversations) {
      final otherUserId = conversation.getOtherUserId(currentUserId);

      // Skip if already in cache
      if (_profileCache.containsKey(otherUserId)) continue;

      try {
        final profile = await profileProvider.getProfileByUserId(otherUserId);
        if (mounted) {
          setState(() {
            _profileCache[otherUserId] = profile;
          });
        }
      } catch (e) {
        // Log error but continue preloading others
        ErrorHandler.logError(e, hint: 'Error preloading profile');
      }
    }
  }

  Future<Profile?> _getProfileForUser(String userId) async {
    // Check cache first
    if (_profileCache.containsKey(userId)) {
      return _profileCache[userId];
    }

    // Store context and error handling function before async operation
    final currentContext = context;

    // Function to show error dialog
    void showError(String message) {
      UIHelpers.showErrorDialog(
        context: currentContext,
        title: 'Failed to load profile',
        message: message,
      );
    }

    // Load profile if not in cache
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    try {
      final profile = await profileProvider.getProfileByUserId(userId);
      if (mounted) {
        setState(() {
          _profileCache[userId] = profile;
        });
      }
      return profile;
    } catch (e) {
      // Use the stored function to show error
      showError(UIHelpers.getErrorMessage(e));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search
            },
          ),
        ],
      ),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          if (messageProvider.isLoading) {
            return const Center(
              child: LoadingIndicator(),
            );
          }

          if (messageProvider.conversations.isEmpty) {
            return const _EmptyConversationsView();
          }

          return RefreshIndicator(
            onRefresh: _refreshConversations,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: messageProvider.conversations.length,
              itemBuilder: (context, index) {
                final conversation = messageProvider.conversations[index];
                return _buildConversationTile(conversation);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildConversationTile(Conversation conversation) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.currentUser == null) {
      return const SizedBox.shrink();
    }

    final currentUserId = authProvider.currentUser!.id;
    final otherUserId = conversation.getOtherUserId(currentUserId);

    // Use FutureBuilder to handle the async profile loading
    return FutureBuilder<Profile?>(
      // Use the cached profile or load it if not available
      future: _getProfileForUser(otherUserId),
      builder: (context, snapshot) {
        // Show loading placeholder while loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingListTile();
        }

        // Skip if profile couldn't be loaded
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        // Show conversation tile with loaded profile
        return ConversationTile(
          conversation: conversation,
          otherUserProfile: snapshot.data!,
          onTap: () {
            context.push(AppRoutes.getConversationRoute(conversation.id));
          },
        );
      },
    );
  }
}

/// Empty conversations view
class _EmptyConversationsView extends StatelessWidget {
  /// Creates a new [_EmptyConversationsView] instance
  const _EmptyConversationsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.iconTertiary,
          ),
          SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyles.headline6,
          ),
          SizedBox(height: 8),
          Text(
            'Start matching with people to begin conversations',
            style: TextStyles.body2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Loading list tile widget
class _LoadingListTile extends StatelessWidget {
  /// Creates a new [_LoadingListTile] instance
  const _LoadingListTile();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: _EmptyAvatar(),
        title: _LoadingIndicator(),
      ),
    );
  }
}

/// Empty avatar widget
class _EmptyAvatar extends StatelessWidget {
  /// Creates a new [_EmptyAvatar] instance
  const _EmptyAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar();
  }
}

/// Loading indicator widget
class _LoadingIndicator extends StatelessWidget {
  /// Creates a new [_LoadingIndicator] instance
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator();
  }
}
