import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/message.dart';
import 'supabase_service.dart';

/// Message service
class MessageService {
  /// Conversations table name
  static const String _conversationsTable =
      AppConfig.supabaseConversationsTable;

  /// Messages table name
  static const String _messagesTable = AppConfig.supabaseMessagesTable;

  /// Storage bucket name
  static const String _storageBucket =
      AppConfig.supabaseStorageMessagePhotosBucket;

  /// Default page size
  static const int defaultPageSize = 20;

  /// Get conversation by ID
  Future<Conversation?> getConversationById(String conversationId) async {
    final response = await SupabaseService.from(_conversationsTable)
        .select()
        .eq('id', conversationId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Conversation.fromJson(response);
  }

  /// Get conversation by match ID
  Future<Conversation?> getConversationByMatchId(String matchId) async {
    final response = await SupabaseService.from(_conversationsTable)
        .select()
        .eq('match_id', matchId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Conversation.fromJson(response);
  }

  /// Get conversations by user ID
  Future<List<Conversation>> getConversationsByUserId(String userId) async {
    final response = await SupabaseService.from(_conversationsTable)
        .select()
        .or('user1_id.eq.$userId,user2_id.eq.$userId')
        .order('updated_at', ascending: false);

    return response
        .map<Conversation>((json) => Conversation.fromJson(json))
        .toList();
  }

  /// Create conversation
  Future<Conversation> createConversation(Conversation conversation) async {
    final response = await SupabaseService.from(_conversationsTable)
        .insert(conversation.toJson())
        .select()
        .single();

    return Conversation.fromJson(response);
  }

  /// Update conversation
  Future<Conversation> updateConversation(Conversation conversation) async {
    final response = await SupabaseService.from(_conversationsTable)
        .update(conversation.toJson())
        .eq('id', conversation.id)
        .select()
        .single();

    return Conversation.fromJson(response);
  }

  /// Delete conversation
  Future<void> deleteConversation(String conversationId) async {
    // Delete all messages in the conversation
    await SupabaseService.from(_messagesTable)
        .delete()
        .eq('conversation_id', conversationId);

    // Delete the conversation
    await SupabaseService.from(_conversationsTable)
        .delete()
        .eq('id', conversationId);
  }

  /// Get messages by conversation ID with pagination
  Future<PaginatedMessages> getMessagesByConversationId(
    String conversationId, {
    int pageSize = defaultPageSize,
    String? cursor,
    bool loadNewer = false,
  }) async {
    var query = SupabaseService.from(_messagesTable)
        .select()
        .eq('conversation_id', conversationId);

    // Apply cursor-based pagination
    if (cursor != null) {
      if (loadNewer) {
        // Load newer messages (created after the cursor)
        query = query.gt('created_at', cursor);
        query = query.order('created_at', ascending: true);
      } else {
        // Load older messages (created before the cursor)
        query = query.lt('created_at', cursor);
        query = query.order('created_at', ascending: false);
      }
    } else {
      // Initial load, get the most recent messages
      query = query.order('created_at', ascending: false);
    }

    // Limit the number of messages
    query = query.limit(pageSize + 1); // +1 to check if there are more messages

    final response = await query;

    final messages =
        response.map<Message>((json) => Message.fromJson(json)).toList();

    // Check if there are more messages
    final hasMore = messages.length > pageSize;
    if (hasMore) {
      messages.removeLast(); // Remove the extra message
    }

    // If loading newer messages, reverse the list to maintain chronological order
    if (loadNewer && cursor != null) {
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    // Get the new cursor (timestamp of the oldest/newest message)
    String? nextCursor;
    if (messages.isNotEmpty) {
      nextCursor = loadNewer
          ? messages.last.createdAt.toIso8601String()
          : messages.first.createdAt.toIso8601String();
    }

    return PaginatedMessages(
      messages: messages,
      nextCursor: nextCursor,
      hasMore: hasMore,
    );
  }

  /// Get message by ID
  Future<Message?> getMessageById(String messageId) async {
    final response = await SupabaseService.from(_messagesTable)
        .select()
        .eq('id', messageId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Message.fromJson(response);
  }

  /// Create message
  Future<Message> createMessage(Message message) async {
    // Create the message
    final response = await SupabaseService.from(_messagesTable)
        .insert(message.toJson())
        .select()
        .single();

    // Update the conversation's last message and updated_at
    final conversation = await getConversationById(message.conversationId);
    if (conversation != null) {
      final now = DateTime.now();
      await updateConversation(
        conversation.copyWith(
          lastMessage: () => response['id'],
          lastMessageText: () => message.text,
          lastMessageTimestamp: now,
          updatedAt: now,
        ),
      );
    }

    return Message.fromJson(response);
  }

  /// Update message
  Future<Message> updateMessage(Message message) async {
    final response = await SupabaseService.from(_messagesTable)
        .update(message.toJson())
        .eq('id', message.id)
        .select()
        .single();

    return Message.fromJson(response);
  }

  /// Delete message
  Future<void> deleteMessage(String messageId) async {
    await SupabaseService.from(_messagesTable).delete().eq('id', messageId);
  }

  /// Mark message as read
  Future<void> markMessageAsRead(String messageId) async {
    await SupabaseService.from(_messagesTable)
        .update({'is_read': true}).eq('id', messageId);
  }

  /// Mark all messages as read
  Future<void> markAllMessagesAsRead(
      String conversationId, String userId) async {
    await SupabaseService.from(_messagesTable)
        .update({'is_read': true})
        .eq('conversation_id', conversationId)
        .neq('sender_id', userId);
  }

  /// Get unread message count
  Future<int> getUnreadMessageCount(String userId) async {
    final conversations = await getConversationsByUserId(userId);

    int count = 0;
    for (final conversation in conversations) {
      final response = await SupabaseService.from(_messagesTable)
          .select('id')
          .eq('conversation_id', conversation.id)
          .neq('sender_id', userId)
          .eq('is_read', false);

      count += response.length as int;
    }

    return count;
  }

  /// Upload message photo
  Future<String> uploadMessagePhoto({
    required String conversationId,
    required String filePath,
    required String fileName,
  }) async {
    final response = await SupabaseService.fromBucket(_storageBucket)
        .upload('$conversationId/$fileName', filePath);

    return SupabaseService.fromBucket(_storageBucket).getPublicUrl(response);
  }

  /// Delete message photo
  Future<void> deleteMessagePhoto({
    required String conversationId,
    required String fileName,
  }) async {
    await SupabaseService.fromBucket(_storageBucket)
        .remove(['$conversationId/$fileName']);
  }

  /// Get conversation stream
  Stream<List<Conversation>> getConversationStream(String userId) {
    return SupabaseService.client
        .from(_conversationsTable)
        .stream(primaryKey: ['id'])
        .eq('first_user_id', userId)
        .order('updated_at')
        .map((events) => events
            .map<Conversation>((event) => Conversation.fromJson(event))
            .toList());
  }

  /// Get message stream
  Stream<List<Message>> getMessageStream(String conversationId) {
    return SupabaseService.client
        .from(_messagesTable)
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((events) =>
            events.map<Message>((event) => Message.fromJson(event)).toList());
  }

  /// Subscribe to conversation changes
  RealtimeChannel subscribeToConversationChanges(
    String userId,
    void Function(Map<String, dynamic> payload) callback,
  ) {
    return SupabaseService.subscribeToTable(
      _conversationsTable,
      filter: {'user1_id': 'eq.$userId', 'user2_id': 'eq.$userId'},
      callback: callback,
    );
  }

  /// Unsubscribe from conversation changes
  Future<void> unsubscribeFromConversationChanges(
      RealtimeChannel channel) async {
    await SupabaseService.unsubscribeFromTable(channel);
  }

  /// Subscribe to message changes
  RealtimeChannel subscribeToMessageChanges(
    String conversationId,
    void Function(Map<String, dynamic> payload) callback,
  ) {
    return SupabaseService.subscribeToTable(
      _messagesTable,
      filter: {'conversation_id': 'eq.$conversationId'},
      callback: callback,
    );
  }

  /// Unsubscribe from message changes
  Future<void> unsubscribeFromMessageChanges(RealtimeChannel channel) async {
    await SupabaseService.unsubscribeFromTable(channel);
  }

  /// Create or get conversation
  Future<Conversation> createOrGetConversation({
    required String matchId,
    required String user1Id,
    required String user2Id,
  }) async {
    // Check if conversation already exists
    final existingConversation = await getConversationByMatchId(matchId);
    if (existingConversation != null) {
      return existingConversation;
    }

    // Create new conversation
    final now = DateTime.now();
    return await createConversation(
      Conversation(
        id: now.millisecondsSinceEpoch.toString(),
        firstUserId: user1Id,
        secondUserId: user2Id,
        lastMessage: null,
        lastMessageText: null,
        lastMessageTimestamp: null,
        firstUserUnreadCount: 0,
        secondUserUnreadCount: 0,
        firstUserMuted: false,
        secondUserMuted: false,
        firstUserArchived: false,
        secondUserArchived: false,
        firstUserDeleted: false,
        secondUserDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// Send message
  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    String? imageUrl,
  }) async {
    // Get the conversation to determine the receiver ID
    final conversation = await getConversationById(conversationId);
    if (conversation == null) {
      throw Exception('Conversation not found');
    }

    final receiverId = conversation.firstUserId == senderId
        ? conversation.secondUserId
        : conversation.firstUserId;

    final now = DateTime.now();
    return await createMessage(
      Message(
        id: now.millisecondsSinceEpoch.toString(),
        conversationId: conversationId,
        senderId: senderId,
        receiverId: receiverId,
        text: text,
        type: imageUrl != null ? MessageType.image : MessageType.text,
        status: MessageStatus.sent,
        mediaUrl: imageUrl,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}

/// Paginated messages
class PaginatedMessages {
  /// Messages
  final List<Message> messages;

  /// Next cursor
  final String? nextCursor;

  /// Has more
  final bool hasMore;

  /// Creates a new [PaginatedMessages] instance
  const PaginatedMessages({
    required this.messages,
    this.nextCursor,
    required this.hasMore,
  });
}
