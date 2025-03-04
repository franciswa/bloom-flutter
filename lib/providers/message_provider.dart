import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../providers/match_provider.dart';
import '../services/analytics_service.dart';
import '../services/service_registry.dart';

/// Message provider
class MessageProvider extends ChangeNotifier {
  /// Auth provider
  final AuthProvider _authProvider;

  /// Match provider
  final MatchProvider _matchProvider;

  /// Conversations
  List<Conversation> _conversations = [];

  /// Current conversation
  Conversation? _currentConversation;

  /// Messages for current conversation
  List<Message> _messages = [];

  /// Is loading
  bool _isLoading = false;

  /// Is loading more messages
  bool _isLoadingMore = false;

  /// Error message
  String? _errorMessage;

  /// Conversation channel
  RealtimeChannel? _conversationChannel;

  /// Message channel
  RealtimeChannel? _messageChannel;

  /// Next cursor for pagination
  String? _nextCursor;

  /// Has more messages
  bool _hasMoreMessages = false;

  /// Creates a new [MessageProvider] instance
  MessageProvider({
    required AuthProvider authProvider,
    required MatchProvider matchProvider,
  })  : _authProvider = authProvider,
        _matchProvider = matchProvider {
    _init();
  }

  /// Initialize
  Future<void> _init() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _loadConversations();
      await _subscribeToConversationChanges();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load conversations
  Future<void> _loadConversations() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;
    _conversations =
        await ServiceRegistry.messageService.getConversationsByUserId(userId);
  }

  /// Subscribe to conversation changes
  Future<void> _subscribeToConversationChanges() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;

    // Unsubscribe from previous channel if exists
    if (_conversationChannel != null) {
      await ServiceRegistry.messageService
          .unsubscribeFromConversationChanges(_conversationChannel!);
    }

    // Subscribe to conversation changes
    _conversationChannel =
        ServiceRegistry.messageService.subscribeToConversationChanges(
      userId,
      (payload) async {
        await _loadConversations();
        notifyListeners();
      },
    );
  }

  /// Load messages for conversation with pagination
  Future<void> _loadMessagesForConversation(String conversationId,
      {bool refresh = false}) async {
    if (refresh) {
      _messages = [];
      _nextCursor = null;
      _hasMoreMessages = false;
    }

    final result =
        await ServiceRegistry.messageService.getMessagesByConversationId(
      conversationId,
      cursor: _nextCursor,
    );

    _messages = [..._messages, ...result.messages];
    _nextCursor = result.nextCursor;
    _hasMoreMessages = result.hasMore;
  }

  /// Load more messages
  Future<void> loadMoreMessages() async {
    if (_currentConversation == null || !_hasMoreMessages || _isLoadingMore) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result =
          await ServiceRegistry.messageService.getMessagesByConversationId(
        _currentConversation!.id,
        cursor: _nextCursor,
      );

      _messages = [..._messages, ...result.messages];
      _nextCursor = result.nextCursor;
      _hasMoreMessages = result.hasMore;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Load newer messages
  Future<void> loadNewerMessages() async {
    if (_currentConversation == null || _messages.isEmpty) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newestMessageTime = _messages.first.createdAt.toIso8601String();
      final result =
          await ServiceRegistry.messageService.getMessagesByConversationId(
        _currentConversation!.id,
        cursor: newestMessageTime,
        loadNewer: true,
      );

      if (result.messages.isNotEmpty) {
        _messages = [...result.messages, ..._messages];
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Subscribe to message changes
  Future<void> _subscribeToMessageChanges(String conversationId) async {
    // Unsubscribe from previous channel if exists
    if (_messageChannel != null) {
      await ServiceRegistry.messageService
          .unsubscribeFromMessageChanges(_messageChannel!);
    }

    // Subscribe to message changes
    _messageChannel = ServiceRegistry.messageService.subscribeToMessageChanges(
      conversationId,
      (payload) async {
        // Only load new messages if the payload is an INSERT
        if (payload['eventType'] == 'INSERT') {
          await loadNewerMessages();
        } else {
          // For other events (UPDATE, DELETE), refresh all messages
          await refreshMessages();
        }
      },
    );
  }

  /// Update auth provider
  void updateAuthProvider({required AuthProvider authProvider}) {
    if (_authProvider.currentUser?.id != authProvider.currentUser?.id) {
      _init();
    }
  }

  /// Update match provider
  void updateMatchProvider({required MatchProvider matchProvider}) {
    // If active matches changed, we might need to update conversations
    if (_matchProvider.activeMatches.length !=
        matchProvider.activeMatches.length) {
      _loadConversations();
    }
  }

  /// Get conversations
  List<Conversation> get conversations => _conversations;

  /// Get current conversation
  Conversation? get currentConversation => _currentConversation;

  /// Get messages
  List<Message> get messages => _messages;

  /// Is loading
  bool get isLoading => _isLoading;

  /// Is loading more
  bool get isLoadingMore => _isLoadingMore;

  /// Has more messages
  bool get hasMoreMessages => _hasMoreMessages;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Set current conversation
  Future<void> setCurrentConversation(String conversationId) async {
    _isLoading = true;
    _messages = [];
    _nextCursor = null;
    _hasMoreMessages = false;
    notifyListeners();

    try {
      _currentConversation =
          _conversations.firstWhere((c) => c.id == conversationId);
      await _loadMessagesForConversation(conversationId, refresh: true);
      await _subscribeToMessageChanges(conversationId);
      await _markAllMessagesAsRead(conversationId);

      // Track conversation view
      await AnalyticsService.trackEvent(
        'conversation_viewed',
        properties: {'conversation_id': conversationId},
      );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear current conversation
  void clearCurrentConversation() {
    _currentConversation = null;
    _messages = [];
    _nextCursor = null;
    _hasMoreMessages = false;
    notifyListeners();
  }

  /// Get conversation by match ID
  Conversation? getConversationByMatchId(String matchId) {
    // Since Conversation doesn't have a matchId property, we need to find it by matching with matches
    // This is a simplified implementation - in a real app, you would have a proper relationship
    try {
      // Try to find a conversation that might be related to this match
      // This is just a placeholder implementation
      return _conversations.firstWhere(
        (c) =>
            c.id.contains(matchId) ||
            (c.lastMessage?.text.contains(matchId) ?? false),
        orElse: () => Conversation.empty,
      );
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  /// Get conversation by user ID
  Conversation? getConversationByUserId(String userId) {
    if (_authProvider.currentUser == null) {
      return null;
    }

    final currentUserId = _authProvider.currentUser!.id;
    try {
      return _conversations.firstWhere(
        (c) =>
            (c.firstUserId == currentUserId && c.secondUserId == userId) ||
            (c.firstUserId == userId && c.secondUserId == currentUserId),
        orElse: () => Conversation.empty,
      );
    } catch (e) {
      return null;
    }
  }

  /// Create or get conversation
  Future<Conversation> createOrGetConversation({
    required String matchId,
    required String user1Id,
    required String user2Id,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final conversation =
          await ServiceRegistry.messageService.createOrGetConversation(
        matchId: matchId,
        user1Id: user1Id,
        user2Id: user2Id,
      );

      // If it's a new conversation, add it to the conversations list
      if (!_conversations.any((c) => c.id == conversation.id)) {
        _conversations.add(conversation);
      }

      _errorMessage = null;
      return conversation;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Send message
  Future<void> sendMessage({
    required String text,
    String? imageUrl,
  }) async {
    if (_authProvider.currentUser == null || _currentConversation == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;
      final conversationId = _currentConversation!.id;

      await ServiceRegistry.messageService.sendMessage(
        conversationId: conversationId,
        senderId: userId,
        text: text,
        imageUrl: imageUrl,
      );

      // Track message sent event
      await AnalyticsService.trackMessageSent(
        conversationId: conversationId,
        messageType: imageUrl != null ? 'image' : 'text',
      );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Upload message photo
  Future<String> uploadMessagePhoto({
    required String filePath,
    required String fileName,
  }) async {
    if (_currentConversation == null) {
      throw Exception('No current conversation');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final conversationId = _currentConversation!.id;
      final photoUrl = await ServiceRegistry.messageService.uploadMessagePhoto(
        conversationId: conversationId,
        filePath: filePath,
        fileName: fileName,
      );

      _errorMessage = null;
      return photoUrl;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark message as read
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await ServiceRegistry.messageService.markMessageAsRead(messageId);

      // Update message in messages list
      final index = _messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        // Since Message doesn't have an isRead property, we need to update the status
        _messages[index] = _messages[index].copyWith(
          status: MessageStatus.read,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  /// Mark all messages as read
  Future<void> _markAllMessagesAsRead(String conversationId) async {
    if (_authProvider.currentUser == null) {
      return;
    }

    try {
      final userId = _authProvider.currentUser!.id;
      await ServiceRegistry.messageService
          .markAllMessagesAsRead(conversationId, userId);

      // Update all messages in messages list
      for (var i = 0; i < _messages.length; i++) {
        if (_messages[i].senderId != userId &&
            _messages[i].status != MessageStatus.read) {
          _messages[i] = _messages[i].copyWith(
            status: MessageStatus.read,
          );
        }
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  /// Get unread message count
  Future<int> getUnreadMessageCount() async {
    if (_authProvider.currentUser == null) {
      return 0;
    }

    try {
      final userId = _authProvider.currentUser!.id;
      return await ServiceRegistry.messageService.getUnreadMessageCount(userId);
    } catch (e) {
      _errorMessage = e.toString();
      return 0;
    }
  }

  /// Delete message
  Future<void> deleteMessage(String messageId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.messageService.deleteMessage(messageId);

      // Remove message from messages list
      _messages.removeWhere((m) => m.id == messageId);

      // Track message deletion
      if (_currentConversation != null) {
        await AnalyticsService.trackEvent(
          'message_deleted',
          properties: {'conversation_id': _currentConversation!.id},
        );
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete conversation
  Future<void> deleteConversation(String conversationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.messageService.deleteConversation(conversationId);

      // Remove conversation from conversations list
      _conversations.removeWhere((c) => c.id == conversationId);

      // Clear current conversation if it's the one being deleted
      if (_currentConversation?.id == conversationId) {
        _currentConversation = null;
        _messages = [];
        _nextCursor = null;
        _hasMoreMessages = false;
      }

      // Track conversation deletion
      await AnalyticsService.trackEvent(
        'conversation_deleted',
        properties: {'conversation_id': conversationId},
      );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh conversations
  Future<void> refreshConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadConversations();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh messages
  Future<void> refreshMessages() async {
    if (_currentConversation == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _loadMessagesForConversation(_currentConversation!.id,
          refresh: true);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Dispose
  @override
  void dispose() {
    if (_conversationChannel != null) {
      ServiceRegistry.messageService
          .unsubscribeFromConversationChanges(_conversationChannel!);
    }
    if (_messageChannel != null) {
      ServiceRegistry.messageService
          .unsubscribeFromMessageChanges(_messageChannel!);
    }
    super.dispose();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
