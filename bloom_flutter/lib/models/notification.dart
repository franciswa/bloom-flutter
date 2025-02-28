import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

/// Notification type enum
enum NotificationType {
  /// New match
  newMatch,

  /// New message
  newMessage,

  /// New like
  newLike,

  /// Match expired
  matchExpired,

  /// Profile view
  profileView,

  /// Compatibility update
  compatibilityUpdate,

  /// Date suggestion
  dateSuggestion,

  /// Date reminder
  dateReminder,

  /// System
  system,
}

/// Notification model
@JsonSerializable()
class AppNotification extends Equatable {
  /// Notification ID
  final String id;

  /// User ID
  final String userId;

  /// Title
  final String title;

  /// Body
  final String body;

  /// Type
  final NotificationType type;

  /// Related ID
  final String? relatedId;

  /// Image URL
  final String? imageUrl;

  /// Action URL
  final String? actionUrl;

  /// Is read
  final bool isRead;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Creates a new [AppNotification] instance
  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.relatedId,
    this.imageUrl,
    this.actionUrl,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new [AppNotification] instance from JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

  /// Converts this [AppNotification] instance to JSON
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  /// Creates a copy of this [AppNotification] instance with the given fields replaced
  AppNotification copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    String? Function()? relatedId,
    String? Function()? imageUrl,
    String? Function()? actionUrl,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      relatedId: relatedId != null ? relatedId() : this.relatedId,
      imageUrl: imageUrl != null ? imageUrl() : this.imageUrl,
      actionUrl: actionUrl != null ? actionUrl() : this.actionUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty notification
  static final empty = AppNotification(
    id: '',
    userId: '',
    title: '',
    body: '',
    type: NotificationType.system,
    relatedId: null,
    imageUrl: null,
    actionUrl: null,
    isRead: false,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == AppNotification.empty;

  /// Is not empty
  bool get isNotEmpty => this != AppNotification.empty;

  /// Get notification type name
  static String getNotificationTypeName(NotificationType type) {
    switch (type) {
      case NotificationType.newMatch:
        return 'New Match';
      case NotificationType.newMessage:
        return 'New Message';
      case NotificationType.newLike:
        return 'New Like';
      case NotificationType.matchExpired:
        return 'Match Expired';
      case NotificationType.profileView:
        return 'Profile View';
      case NotificationType.compatibilityUpdate:
        return 'Compatibility Update';
      case NotificationType.dateSuggestion:
        return 'Date Suggestion';
      case NotificationType.dateReminder:
        return 'Date Reminder';
      case NotificationType.system:
        return 'System';
    }
  }

  /// Get notification icon
  static String getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newMatch:
        return 'assets/icons/match.svg';
      case NotificationType.newMessage:
        return 'assets/icons/message.svg';
      case NotificationType.newLike:
        return 'assets/icons/like.svg';
      case NotificationType.matchExpired:
        return 'assets/icons/expired.svg';
      case NotificationType.profileView:
        return 'assets/icons/profile_view.svg';
      case NotificationType.compatibilityUpdate:
        return 'assets/icons/compatibility.svg';
      case NotificationType.dateSuggestion:
        return 'assets/icons/date.svg';
      case NotificationType.dateReminder:
        return 'assets/icons/reminder.svg';
      case NotificationType.system:
        return 'assets/icons/system.svg';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        type,
        relatedId,
        imageUrl,
        actionUrl,
        isRead,
        createdAt,
        updatedAt,
      ];
}

/// Notification settings model
@JsonSerializable()
class NotificationSettings extends Equatable {
  /// User ID
  final String userId;

  /// Push enabled
  final bool pushEnabled;

  /// Email enabled
  final bool emailEnabled;

  /// In-app enabled
  final bool inAppEnabled;

  /// New match enabled
  final bool newMatchEnabled;

  /// New message enabled
  final bool newMessageEnabled;

  /// New like enabled
  final bool newLikeEnabled;

  /// Match expired enabled
  final bool matchExpiredEnabled;

  /// Profile view enabled
  final bool profileViewEnabled;

  /// Compatibility update enabled
  final bool compatibilityUpdateEnabled;

  /// Date suggestion enabled
  final bool dateSuggestionEnabled;

  /// Date reminder enabled
  final bool dateReminderEnabled;

  /// System enabled
  final bool systemEnabled;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Creates a new [NotificationSettings] instance
  const NotificationSettings({
    required this.userId,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.inAppEnabled,
    required this.newMatchEnabled,
    required this.newMessageEnabled,
    required this.newLikeEnabled,
    required this.matchExpiredEnabled,
    required this.profileViewEnabled,
    required this.compatibilityUpdateEnabled,
    required this.dateSuggestionEnabled,
    required this.dateReminderEnabled,
    required this.systemEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new [NotificationSettings] instance from JSON
  factory NotificationSettings.fromJson(Map<String, dynamic> json) => _$NotificationSettingsFromJson(json);

  /// Converts this [NotificationSettings] instance to JSON
  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);

  /// Creates a copy of this [NotificationSettings] instance with the given fields replaced
  NotificationSettings copyWith({
    String? userId,
    bool? pushEnabled,
    bool? emailEnabled,
    bool? inAppEnabled,
    bool? newMatchEnabled,
    bool? newMessageEnabled,
    bool? newLikeEnabled,
    bool? matchExpiredEnabled,
    bool? profileViewEnabled,
    bool? compatibilityUpdateEnabled,
    bool? dateSuggestionEnabled,
    bool? dateReminderEnabled,
    bool? systemEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationSettings(
      userId: userId ?? this.userId,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      inAppEnabled: inAppEnabled ?? this.inAppEnabled,
      newMatchEnabled: newMatchEnabled ?? this.newMatchEnabled,
      newMessageEnabled: newMessageEnabled ?? this.newMessageEnabled,
      newLikeEnabled: newLikeEnabled ?? this.newLikeEnabled,
      matchExpiredEnabled: matchExpiredEnabled ?? this.matchExpiredEnabled,
      profileViewEnabled: profileViewEnabled ?? this.profileViewEnabled,
      compatibilityUpdateEnabled: compatibilityUpdateEnabled ?? this.compatibilityUpdateEnabled,
      dateSuggestionEnabled: dateSuggestionEnabled ?? this.dateSuggestionEnabled,
      dateReminderEnabled: dateReminderEnabled ?? this.dateReminderEnabled,
      systemEnabled: systemEnabled ?? this.systemEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Default notification settings
  static NotificationSettings defaultSettings(String userId) {
    final now = DateTime.now();
    return NotificationSettings(
      userId: userId,
      pushEnabled: true,
      emailEnabled: true,
      inAppEnabled: true,
      newMatchEnabled: true,
      newMessageEnabled: true,
      newLikeEnabled: true,
      matchExpiredEnabled: true,
      profileViewEnabled: true,
      compatibilityUpdateEnabled: true,
      dateSuggestionEnabled: true,
      dateReminderEnabled: true,
      systemEnabled: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty notification settings
  static final empty = NotificationSettings(
    userId: '',
    pushEnabled: false,
    emailEnabled: false,
    inAppEnabled: false,
    newMatchEnabled: false,
    newMessageEnabled: false,
    newLikeEnabled: false,
    matchExpiredEnabled: false,
    profileViewEnabled: false,
    compatibilityUpdateEnabled: false,
    dateSuggestionEnabled: false,
    dateReminderEnabled: false,
    systemEnabled: false,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == NotificationSettings.empty;

  /// Is not empty
  bool get isNotEmpty => this != NotificationSettings.empty;

  /// Is notification type enabled
  bool isNotificationTypeEnabled(NotificationType type) {
    switch (type) {
      case NotificationType.newMatch:
        return newMatchEnabled;
      case NotificationType.newMessage:
        return newMessageEnabled;
      case NotificationType.newLike:
        return newLikeEnabled;
      case NotificationType.matchExpired:
        return matchExpiredEnabled;
      case NotificationType.profileView:
        return profileViewEnabled;
      case NotificationType.compatibilityUpdate:
        return compatibilityUpdateEnabled;
      case NotificationType.dateSuggestion:
        return dateSuggestionEnabled;
      case NotificationType.dateReminder:
        return dateReminderEnabled;
      case NotificationType.system:
        return systemEnabled;
    }
  }

  @override
  List<Object?> get props => [
        userId,
        pushEnabled,
        emailEnabled,
        inAppEnabled,
        newMatchEnabled,
        newMessageEnabled,
        newLikeEnabled,
        matchExpiredEnabled,
        profileViewEnabled,
        compatibilityUpdateEnabled,
        dateSuggestionEnabled,
        dateReminderEnabled,
        systemEnabled,
        createdAt,
        updatedAt,
      ];
}
