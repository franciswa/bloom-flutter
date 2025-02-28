import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/message.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/text_styles.dart';
import '../../../utils/helpers/date_helpers.dart';

/// Message bubble widget
class MessageBubble extends StatelessWidget {
  /// Message
  final Message message;

  /// Is from current user
  final bool isFromCurrentUser;

  /// Creates a new [MessageBubble] instance
  const MessageBubble({
    super.key,
    required this.message,
    required this.isFromCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Card(
          color: isFromCurrentUser ? AppColors.primary : Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message content
                _buildMessageContent(),

                // Message timestamp
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateHelpers.formatMessageTime(message.createdAt),
                          style: TextStyles.caption.copyWith(
                            color: isFromCurrentUser
                                ? AppColors.onPrimary.withOpacity(0.7)
                                : AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (isFromCurrentUser)
                          Icon(
                            message.status == MessageStatus.read
                                ? Icons.done_all
                                : Icons.done,
                            size: 12,
                            color: message.status == MessageStatus.read
                                ? AppColors.onPrimary.withOpacity(0.7)
                                : AppColors.onPrimary.withOpacity(0.5),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    if (message.mediaUrl != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: message.mediaUrl!,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
              fit: BoxFit.cover,
            ),
          ),
          if (message.text.isNotEmpty && message.text != 'Sent an image')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                message.text,
                style: TextStyles.body2.copyWith(
                  color: isFromCurrentUser
                      ? AppColors.onPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ),
        ],
      );
    } else {
      return Text(
        message.text,
        style: TextStyles.body2.copyWith(
          color:
              isFromCurrentUser ? AppColors.onPrimary : AppColors.textPrimary,
        ),
      );
    }
  }
}
