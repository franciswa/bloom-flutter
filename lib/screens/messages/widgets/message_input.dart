import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/text_styles.dart';

/// Message input widget
class MessageInput extends StatelessWidget {
  /// Text controller
  final TextEditingController textController;

  /// Is composing
  final bool isComposing;

  /// On text changed
  final Function(String) onTextChanged;

  /// On send message
  final VoidCallback onSendMessage;

  /// On send image
  final VoidCallback onSendImage;

  /// Creates a new [MessageInput] instance
  const MessageInput({
    super.key,
    required this.textController,
    required this.isComposing,
    required this.onTextChanged,
    required this.onSendMessage,
    required this.onSendImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            IconButton(
              icon: const Icon(Icons.add_photo_alternate_outlined),
              onPressed: onSendImage,
              color: AppColors.iconSecondary,
              tooltip: 'Send image',
            ),
            
            // Text field
            Expanded(
              child: TextField(
                controller: textController,
                onChanged: onTextChanged,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyles.body1,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyles.body1.copyWith(
                    color: AppColors.textHint,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onSubmitted: (text) {
                  if (isComposing) {
                    onSendMessage();
                  }
                },
              ),
            ),
            
            // Send button
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: isComposing ? onSendMessage : null,
              color: isComposing ? AppColors.primary : AppColors.iconTertiary,
              tooltip: 'Send message',
            ),
          ],
        ),
      ),
    );
  }
}
