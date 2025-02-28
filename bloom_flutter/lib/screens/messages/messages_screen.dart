import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../models/message.dart';
import '../../models/profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';
import '../../providers/profile_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/helpers/date_helpers.dart';
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
        // Ignore errors during preloading
      }
    }
  }

  Future<Profile?> _getProfileForUser(String userId) async {
    // Check cache first
    if (_profileCache.containsKey(userId)) {
      return _profileCache[userId];
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: AppColors.iconTertiary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No conversations yet',
                    style: TextStyles.headline6,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start matching with people to begin conversations',
                    style: TextStyles.body2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
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
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(),
              title: LinearProgressIndicator(),
            ),
          );
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
