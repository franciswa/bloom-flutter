import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/message.dart';
import '../../../models/profile.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/text_styles.dart';
import '../../../utils/helpers/date_helpers.dart';

/// Conversation tile widget
class ConversationTile extends StatelessWidget {
  /// Conversation
  final Conversation conversation;

  /// Other user profile
  final Profile otherUserProfile;

  /// On tap
  final VoidCallback onTap;

  /// Creates a new [ConversationTile] instance
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.otherUserProfile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.currentUser?.id;
    
    if (currentUserId == null) {
      return const SizedBox.shrink();
    }
    
    final unreadCount = conversation.getUnreadCount(currentUserId);
    final hasUnread = unreadCount > 0;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        otherUserProfile.displayName,
                        style: TextStyles.subtitle1.copyWith(
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Text(
                        conversation.lastMessageTimestamp != null
                            ? DateHelpers.formatMessageTime(conversation.lastMessageTimestamp!)
                            : '',
                        style: TextStyles.caption.copyWith(
                          color: hasUnread ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Last message and unread count
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessageText ?? 'Start a conversation',
                          style: TextStyles.body2.copyWith(
                            color: hasUnread ? AppColors.textPrimary : AppColors.textSecondary,
                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: TextStyles.caption.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        // Avatar
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary,
          child: otherUserProfile.profilePhotoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: CachedNetworkImage(
                    imageUrl: otherUserProfile.profilePhotoUrl!,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 56,
                        height: 56,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Text(
                      otherUserProfile.displayName.substring(0, 1).toUpperCase(),
                      style: TextStyles.headline5.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                    fit: BoxFit.cover,
                    width: 56,
                    height: 56,
                  ),
                )
              : Text(
                  otherUserProfile.displayName.substring(0, 1).toUpperCase(),
                  style: TextStyles.headline5.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
        ),
        
        // Online indicator
        if (otherUserProfile.isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.success,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
      ],
    );
  }
}
