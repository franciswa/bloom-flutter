import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import '../../models/profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';
import '../../providers/profile_provider.dart';
import '../../utils/helpers/ui_helpers.dart';
import '../../widgets/common/loading_indicator.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input.dart';

/// Conversation screen
class ConversationScreen extends StatefulWidget {
  /// Conversation ID
  final String id;

  /// Creates a new [ConversationScreen] instance
  const ConversationScreen({
    super.key,
    required this.id,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  bool _isComposing = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadConversation().then((_) {
      if (mounted) {
        _loadOtherUserProfile();
      }
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreMessages();
    }
  }

  Future<void> _loadConversation() async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    try {
      await messageProvider.setCurrentConversation(widget.id);
    } catch (e) {
      if (!mounted) return;
      UIHelpers.showErrorDialog(
        context: context,
        title: 'Failed to load conversation',
        message: UIHelpers.getErrorMessage(e),
      );
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore) return;

    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    if (messageProvider.hasMoreMessages) {
      setState(() {
        _isLoadingMore = true;
      });

      try {
        await messageProvider.loadMoreMessages();
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    }
  }

  Future<void> _handleRefresh() async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    await messageProvider.refreshMessages();
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    try {
      await messageProvider.sendMessage(text: text);
    } catch (e) {
      if (!mounted) return;
      UIHelpers.showErrorDialog(
        context: context,
        title: 'Failed to send message',
        message: UIHelpers.getErrorMessage(e),
      );
    }
  }

  Future<void> _sendImageMessage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedFile.path)}';
      final imageUrl = await messageProvider.uploadMessagePhoto(
        filePath: pickedFile.path,
        fileName: fileName,
      );

      await messageProvider.sendMessage(
        text: 'Sent an image',
        imageUrl: imageUrl,
      );
    } catch (e) {
      if (!mounted) return;
      UIHelpers.showErrorDialog(
        context: context,
        title: 'Failed to send image',
        message: UIHelpers.getErrorMessage(e),
      );
    }
  }

  // Cache for other user profiles
  final Map<String, Profile?> _otherUserProfiles = {};
  String _otherUserName = 'Chat';

  Future<void> _loadOtherUserProfile() async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    if (messageProvider.currentConversation == null ||
        authProvider.currentUser == null) {
      setState(() {
        _otherUserName = 'Chat';
      });
      return;
    }

    final conversation = messageProvider.currentConversation!;
    final currentUserId = authProvider.currentUser!.id;
    final otherUserId = conversation.getOtherUserId(currentUserId);

    // Check cache first
    if (_otherUserProfiles.containsKey(otherUserId)) {
      setState(() {
        _otherUserName = _otherUserProfiles[otherUserId]?.displayName ?? 'User';
      });
      return;
    }

    try {
      final profile = await profileProvider.getProfileByUserId(otherUserId);
      if (mounted) {
        setState(() {
          _otherUserProfiles[otherUserId] = profile;
          _otherUserName = profile?.displayName ?? 'User';
        });
      }
    } catch (e) {
      // Fallback to default name on error
      if (mounted) {
        setState(() {
          _otherUserName = 'User';
        });
      }
    }
  }

  String _getOtherUserName() {
    return _otherUserName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<MessageProvider>(
          builder: (context, messageProvider, _) {
            if (messageProvider.currentConversation != null) {
              // Trigger profile load if conversation changes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadOtherUserProfile();
              });
            }
            return Text(_getOtherUserName());
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final messageProvider =
                Provider.of<MessageProvider>(context, listen: false);
            messageProvider.clearCurrentConversation();
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show conversation details
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

          if (messageProvider.currentConversation == null) {
            return const Center(
              child: Text('Conversation not found'),
            );
          }

          return Column(
            children: [
              // Messages list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16.0),
                    itemCount: messageProvider.messages.length +
                        (messageProvider.hasMoreMessages ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the end of the list
                      if (messageProvider.hasMoreMessages &&
                          index == messageProvider.messages.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        );
                      }

                      final message = messageProvider.messages[index];
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      final isFromCurrentUser =
                          message.senderId == authProvider.currentUser?.id;

                      return MessageBubble(
                        message: message,
                        isFromCurrentUser: isFromCurrentUser,
                      );
                    },
                  ),
                ),
              ),

              // Message input
              MessageInput(
                textController: _textController,
                isComposing: _isComposing,
                onTextChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSendMessage: _sendMessage,
                onSendImage: _sendImageMessage,
              ),
            ],
          );
        },
      ),
    );
  }
}
