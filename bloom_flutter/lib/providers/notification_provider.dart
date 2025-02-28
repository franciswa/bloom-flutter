import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/notification.dart';
import '../providers/auth_provider.dart';
import '../services/service_registry.dart';

/// Notification provider
class NotificationProvider extends ChangeNotifier {
  /// Auth provider
  final AuthProvider _authProvider;

  /// Notifications
  List<AppNotification> _notifications = [];

  /// Unread notifications
  List<AppNotification> _unreadNotifications = [];

  /// Notification settings
  NotificationSettings? _notificationSettings;

  /// Is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Notification channel
  RealtimeChannel? _notificationChannel;

  /// Creates a new [NotificationProvider] instance
  NotificationProvider({
    required AuthProvider authProvider,
  }) : _authProvider = authProvider {
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
      await _loadNotifications();
      await _loadNotificationSettings();
      await _subscribeToNotificationChanges();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load notifications
  Future<void> _loadNotifications() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;
    _notifications = await ServiceRegistry.notificationService.getNotificationsByUserId(userId);
    _unreadNotifications = await ServiceRegistry.notificationService.getUnreadNotificationsByUserId(userId);
  }

  /// Load notification settings
  Future<void> _loadNotificationSettings() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;
    _notificationSettings = await ServiceRegistry.notificationService.getNotificationSettings(userId);

    // Create default settings if none exist
    if (_notificationSettings == null) {
      _notificationSettings = NotificationSettings(
        userId: userId,
        matchesEnabled: true,
        messagesEnabled: true,
        likesEnabled: true,
        compatibilityEnabled: true,
        systemEnabled: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ServiceRegistry.notificationService.createNotificationSettings(_notificationSettings!);
    }
  }

  /// Subscribe to notification changes
  Future<void> _subscribeToNotificationChanges() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;

    // Unsubscribe from previous channel if exists
    if (_notificationChannel != null) {
      await ServiceRegistry.notificationService.unsubscribeFromNotificationChanges(_notificationChannel!);
    }

    // Subscribe to notification changes
    _notificationChannel = ServiceRegistry.notificationService.subscribeToNotificationChanges(
      userId,
      (payload) async {
        await _loadNotifications();
        notifyListeners();
      },
    );
  }

  /// Update auth provider
  void updateAuthProvider({required AuthProvider authProvider}) {
    if (_authProvider.currentUser?.id != authProvider.currentUser?.id) {
      _init();
    }
  }

  /// Get notifications
  List<AppNotification> get notifications => _notifications;

  /// Get unread notifications
  List<AppNotification> get unreadNotifications => _unreadNotifications;

  /// Get notification settings
  NotificationSettings? get notificationSettings => _notificationSettings;

  /// Is loading
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Get unread notification count
  int get unreadNotificationCount => _unreadNotifications.length;

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.notificationService.markNotificationAsRead(notificationId);

      // Update notification in notifications list
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }

      // Remove from unread notifications
      _unreadNotifications.removeWhere((n) => n.id == notificationId);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark all notifications as read
  Future<void> markAllNotificationsAsRead() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;
      await ServiceRegistry.notificationService.markAllNotificationsAsRead(userId);

      // Update all notifications in notifications list
      for (var i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
        }
      }

      // Clear unread notifications
      _unreadNotifications = [];

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ServiceRegistry.notificationService.deleteNotification(notificationId);

      // Remove notification from notifications list
      _notifications.removeWhere((n) => n.id == notificationId);

      // Remove from unread notifications
      _unreadNotifications.removeWhere((n) => n.id == notificationId);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update notification settings
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notificationSettings = await ServiceRegistry.notificationService.updateNotificationSettings(settings);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update matches enabled
  Future<void> updateMatchesEnabled(bool enabled) async {
    if (_notificationSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final settings = _notificationSettings!.copyWith(
        matchesEnabled: enabled,
        updatedAt: DateTime.now(),
      );

      _notificationSettings = await ServiceRegistry.notificationService.updateNotificationSettings(settings);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update messages enabled
  Future<void> updateMessagesEnabled(bool enabled) async {
    if (_notificationSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final settings = _notificationSettings!.copyWith(
        messagesEnabled: enabled,
        updatedAt: DateTime.now(),
      );

      _notificationSettings = await ServiceRegistry.notificationService.updateNotificationSettings(settings);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update likes enabled
  Future<void> updateLikesEnabled(bool enabled) async {
    if (_notificationSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final settings = _notificationSettings!.copyWith(
        likesEnabled: enabled,
        updatedAt: DateTime.now(),
      );

      _notificationSettings = await ServiceRegistry.notificationService.updateNotificationSettings(settings);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update compatibility enabled
  Future<void> updateCompatibilityEnabled(bool enabled) async {
    if (_notificationSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final settings = _notificationSettings!.copyWith(
        compatibilityEnabled: enabled,
        updatedAt: DateTime.now(),
      );

      _notificationSettings = await ServiceRegistry.notificationService.updateNotificationSettings(settings);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update system enabled
  Future<void> updateSystemEnabled(bool enabled) async {
    if (_notificationSettings == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final settings = _notificationSettings!.copyWith(
        systemEnabled: enabled,
        updatedAt: DateTime.now(),
      );

      _notificationSettings = await ServiceRegistry.notificationService.updateNotificationSettings(settings);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh notifications
  Future<void> refreshNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadNotifications();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh notification settings
  Future<void> refreshNotificationSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadNotificationSettings();
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
    if (_notificationChannel != null) {
      ServiceRegistry.notificationService.unsubscribeFromNotificationChanges(_notificationChannel!);
    }
    super.dispose();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
