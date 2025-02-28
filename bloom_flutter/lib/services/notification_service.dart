import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/notification.dart';
import 'supabase_service.dart';

/// Notification service
class NotificationService {
  /// Table name
  static const String _tableName = AppConfig.supabaseNotificationsTable;

  /// Settings table name
  static const String _settingsTable =
      AppConfig.supabaseNotificationSettingsTable;

  /// Get notification by ID
  Future<AppNotification?> getNotificationById(String notificationId) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .eq('id', notificationId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return AppNotification.fromJson(response);
  }

  /// Get notifications by user ID
  Future<List<AppNotification>> getNotificationsByUserId(
    String userId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1);

    return response
        .map<AppNotification>((json) => AppNotification.fromJson(json))
        .toList();
  }

  /// Get unread notifications by user ID
  Future<List<AppNotification>> getUnreadNotificationsByUserId(
      String userId) async {
    final response = await SupabaseService.from(_tableName)
        .select()
        .eq('user_id', userId)
        .eq('is_read', false)
        .order('created_at', ascending: false);

    return response
        .map<AppNotification>((json) => AppNotification.fromJson(json))
        .toList();
  }

  /// Create notification
  Future<AppNotification> createNotification(
      AppNotification notification) async {
    // Check if user has notifications enabled for this type
    final settings = await getNotificationSettings(notification.userId);
    if (settings != null) {
      if (!_isNotificationTypeEnabled(settings, notification.type)) {
        throw Exception('Notifications of this type are disabled');
      }
    }

    final response = await SupabaseService.from(_tableName)
        .insert(notification.toJson())
        .select()
        .single();

    return AppNotification.fromJson(response);
  }

  /// Update notification
  Future<AppNotification> updateNotification(
      AppNotification notification) async {
    final response = await SupabaseService.from(_tableName)
        .update(notification.toJson())
        .eq('id', notification.id)
        .select()
        .single();

    return AppNotification.fromJson(response);
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await SupabaseService.from(_tableName).delete().eq('id', notificationId);
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    await SupabaseService.from(_tableName)
        .update({'is_read': true}).eq('id', notificationId);
  }

  /// Mark all notifications as read
  Future<void> markAllNotificationsAsRead(String userId) async {
    await SupabaseService.from(_tableName)
        .update({'is_read': true}).eq('user_id', userId);
  }

  /// Get unread notification count
  Future<int> getUnreadNotificationCount(String userId) async {
    final response = await SupabaseService.from(_tableName)
        .select('id')
        .eq('user_id', userId)
        .eq('is_read', false);

    return response.length;
  }

  /// Get notification settings
  Future<NotificationSettings?> getNotificationSettings(String userId) async {
    final response = await SupabaseService.from(_settingsTable)
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return NotificationSettings.fromJson(response);
  }

  /// Create notification settings
  Future<NotificationSettings> createNotificationSettings(
      NotificationSettings settings) async {
    final response = await SupabaseService.from(_settingsTable)
        .insert(settings.toJson())
        .select()
        .single();

    return NotificationSettings.fromJson(response);
  }

  /// Update notification settings
  Future<NotificationSettings> updateNotificationSettings(
      NotificationSettings settings) async {
    final response = await SupabaseService.from(_settingsTable)
        .update(settings.toJson())
        .eq('user_id', settings.userId)
        .select()
        .single();

    return NotificationSettings.fromJson(response);
  }

  /// Delete notification settings
  Future<void> deleteNotificationSettings(String userId) async {
    await SupabaseService.from(_settingsTable).delete().eq('user_id', userId);
  }

  /// Create or update notification settings
  Future<NotificationSettings> createOrUpdateNotificationSettings(
      NotificationSettings settings) async {
    final existingSettings = await getNotificationSettings(settings.userId);

    if (existingSettings != null) {
      return await updateNotificationSettings(settings);
    } else {
      return await createNotificationSettings(settings);
    }
  }

  /// Get notification stream
  Stream<List<AppNotification>> getNotificationStream(String userId) {
    return SupabaseService.client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at')
        .map((events) => events
            .map<AppNotification>((event) => AppNotification.fromJson(event))
            .toList());
  }

  /// Subscribe to notification changes
  RealtimeChannel subscribeToNotificationChanges(
    String userId,
    void Function(Map<String, dynamic> payload) callback,
  ) {
    return SupabaseService.subscribeToTable(
      _tableName,
      filter: {'user_id': 'eq.$userId'},
      callback: callback,
    );
  }

  /// Unsubscribe from notification changes
  Future<void> unsubscribeFromNotificationChanges(
      RealtimeChannel channel) async {
    await SupabaseService.unsubscribeFromTable(channel);
  }

  /// Create match notification
  Future<AppNotification> createMatchNotification({
    required String userId,
    required String matchId,
    required String matchedUserId,
    required String matchedUserName,
  }) async {
    return await createNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        type: NotificationType.newMatch,
        title: 'New Match',
        body: 'You matched with $matchedUserName!',
        relatedId: matchId,
        isRead: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Create message notification
  Future<AppNotification> createMessageNotification({
    required String userId,
    required String conversationId,
    required String senderId,
    required String senderName,
    required String messageText,
  }) async {
    return await createNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        type: NotificationType.newMessage,
        title: 'New Message',
        body: '$senderName: $messageText',
        relatedId: conversationId,
        isRead: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Create like notification
  Future<AppNotification> createLikeNotification({
    required String userId,
    required String likerId,
    required String likerName,
  }) async {
    return await createNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        type: NotificationType.newLike,
        title: 'New Like',
        body: '$likerName liked your profile!',
        relatedId: likerId,
        isRead: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Create compatibility notification
  Future<AppNotification> createCompatibilityNotification({
    required String userId,
    required String compatibilityId,
    required String otherUserId,
    required String otherUserName,
    required int compatibilityScore,
  }) async {
    return await createNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        type: NotificationType.compatibilityUpdate,
        title: 'High Compatibility',
        body:
            'You have $compatibilityScore% compatibility with $otherUserName!',
        relatedId: compatibilityId,
        isRead: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Create system notification
  Future<AppNotification> createSystemNotification({
    required String userId,
    required String title,
    required String body,
    String? relatedId,
  }) async {
    return await createNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        type: NotificationType.system,
        title: title,
        body: body,
        relatedId: relatedId,
        isRead: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Check if notification type is enabled
  bool _isNotificationTypeEnabled(
      NotificationSettings settings, NotificationType type) {
    switch (type) {
      case NotificationType.newMatch:
        return settings.newMatchEnabled;
      case NotificationType.newMessage:
        return settings.newMessageEnabled;
      case NotificationType.newLike:
        return settings.newLikeEnabled;
      case NotificationType.matchExpired:
        return settings.matchExpiredEnabled;
      case NotificationType.profileView:
        return settings.profileViewEnabled;
      case NotificationType.compatibilityUpdate:
        return settings.compatibilityUpdateEnabled;
      case NotificationType.dateSuggestion:
        return settings.dateSuggestionEnabled;
      case NotificationType.dateReminder:
        return settings.dateReminderEnabled;
      case NotificationType.system:
        return settings.systemEnabled;
    }
  }
}
