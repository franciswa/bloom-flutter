import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

/// Message status enum
enum MessageStatus {
  /// Sending
  sending,

  /// Sent
  sent,

  /// Delivered
  delivered,

  /// Read
  read,

  /// Failed
  failed,
}

/// Message type enum
enum MessageType {
  /// Text
  text,

  /// Image
  image,

  /// Location
  location,

  /// Date suggestion
  dateSuggestion,

  /// Chart
  chart,

  /// System
  system,
}

/// Message model
@JsonSerializable()
class Message extends Equatable {
  /// Message ID
  final String id;

  /// Conversation ID
  final String conversationId;

  /// Sender ID
  final String senderId;

  /// Receiver ID
  final String receiverId;

  /// Message text
  final String text;

  /// Message type
  final MessageType type;

  /// Message status
  final MessageStatus status;

  /// Media URL
  final String? mediaUrl;

  /// Media thumbnail URL
  final String? mediaThumbnailUrl;

  /// Media width
  final int? mediaWidth;

  /// Media height
  final int? mediaHeight;

  /// Location latitude
  final double? locationLatitude;

  /// Location longitude
  final double? locationLongitude;

  /// Location name
  final String? locationName;

  /// Date suggestion ID
  final String? dateSuggestionId;

  /// Chart ID
  final String? chartId;

  /// Is deleted
  final bool isDeleted;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Creates a new [Message] instance
  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.status,
    this.mediaUrl,
    this.mediaThumbnailUrl,
    this.mediaWidth,
    this.mediaHeight,
    this.locationLatitude,
    this.locationLongitude,
    this.locationName,
    this.dateSuggestionId,
    this.chartId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new [Message] instance from JSON
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  /// Converts this [Message] instance to JSON
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  /// Creates a copy of this [Message] instance with the given fields replaced
  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? receiverId,
    String? text,
    MessageType? type,
    MessageStatus? status,
    String? Function()? mediaUrl,
    String? Function()? mediaThumbnailUrl,
    int? Function()? mediaWidth,
    int? Function()? mediaHeight,
    double? Function()? locationLatitude,
    double? Function()? locationLongitude,
    String? Function()? locationName,
    String? Function()? dateSuggestionId,
    String? Function()? chartId,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      type: type ?? this.type,
      status: status ?? this.status,
      mediaUrl: mediaUrl != null ? mediaUrl() : this.mediaUrl,
      mediaThumbnailUrl: mediaThumbnailUrl != null ? mediaThumbnailUrl() : this.mediaThumbnailUrl,
      mediaWidth: mediaWidth != null ? mediaWidth() : this.mediaWidth,
      mediaHeight: mediaHeight != null ? mediaHeight() : this.mediaHeight,
      locationLatitude: locationLatitude != null ? locationLatitude() : this.locationLatitude,
      locationLongitude: locationLongitude != null ? locationLongitude() : this.locationLongitude,
      locationName: locationName != null ? locationName() : this.locationName,
      dateSuggestionId: dateSuggestionId != null ? dateSuggestionId() : this.dateSuggestionId,
      chartId: chartId != null ? chartId() : this.chartId,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty message
  static final empty = Message(
    id: '',
    conversationId: '',
    senderId: '',
    receiverId: '',
    text: '',
    type: MessageType.text,
    status: MessageStatus.sending,
    mediaUrl: null,
    mediaThumbnailUrl: null,
    mediaWidth: null,
    mediaHeight: null,
    locationLatitude: null,
    locationLongitude: null,
    locationName: null,
    dateSuggestionId: null,
    chartId: null,
    isDeleted: false,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == Message.empty;

  /// Is not empty
  bool get isNotEmpty => this != Message.empty;

  /// Is text message
  bool get isTextMessage => type == MessageType.text;

  /// Is image message
  bool get isImageMessage => type == MessageType.image;

  /// Is location message
  bool get isLocationMessage => type == MessageType.location;

  /// Is date suggestion message
  bool get isDateSuggestionMessage => type == MessageType.dateSuggestion;

  /// Is chart message
  bool get isChartMessage => type == MessageType.chart;

  /// Is system message
  bool get isSystemMessage => type == MessageType.system;

  /// Is sent by user
  bool isFromUser(String userId) => senderId == userId;

  /// Get message status name
  static String getMessageStatusName(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return 'Sending';
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.delivered:
        return 'Delivered';
      case MessageStatus.read:
        return 'Read';
      case MessageStatus.failed:
        return 'Failed';
    }
  }

  /// Get message type name
  static String getMessageTypeName(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 'Text';
      case MessageType.image:
        return 'Image';
      case MessageType.location:
        return 'Location';
      case MessageType.dateSuggestion:
        return 'Date Suggestion';
      case MessageType.chart:
        return 'Chart';
      case MessageType.system:
        return 'System';
    }
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        receiverId,
        text,
        type,
        status,
        mediaUrl,
        mediaThumbnailUrl,
        mediaWidth,
        mediaHeight,
        locationLatitude,
        locationLongitude,
        locationName,
        dateSuggestionId,
        chartId,
        isDeleted,
        createdAt,
        updatedAt,
      ];
}

/// Conversation model
@JsonSerializable()
class Conversation extends Equatable {
  /// Conversation ID
  final String id;

  /// First user ID
  final String firstUserId;

  /// Second user ID
  final String secondUserId;

  /// Last message
  final Message? lastMessage;

  /// Unread count for first user
  final int firstUserUnreadCount;

  /// Unread count for second user
  final int secondUserUnreadCount;

  /// First user muted
  final bool firstUserMuted;

  /// Second user muted
  final bool secondUserMuted;

  /// First user archived
  final bool firstUserArchived;

  /// Second user archived
  final bool secondUserArchived;

  /// First user deleted
  final bool firstUserDeleted;

  /// Second user deleted
  final bool secondUserDeleted;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Creates a new [Conversation] instance
  const Conversation({
    required this.id,
    required this.firstUserId,
    required this.secondUserId,
    this.lastMessage,
    required this.firstUserUnreadCount,
    required this.secondUserUnreadCount,
    required this.firstUserMuted,
    required this.secondUserMuted,
    required this.firstUserArchived,
    required this.secondUserArchived,
    required this.firstUserDeleted,
    required this.secondUserDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new [Conversation] instance from JSON
  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

  /// Converts this [Conversation] instance to JSON
  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  /// Creates a copy of this [Conversation] instance with the given fields replaced
  Conversation copyWith({
    String? id,
    String? firstUserId,
    String? secondUserId,
    Message? Function()? lastMessage,
    int? firstUserUnreadCount,
    int? secondUserUnreadCount,
    bool? firstUserMuted,
    bool? secondUserMuted,
    bool? firstUserArchived,
    bool? secondUserArchived,
    bool? firstUserDeleted,
    bool? secondUserDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      firstUserId: firstUserId ?? this.firstUserId,
      secondUserId: secondUserId ?? this.secondUserId,
      lastMessage: lastMessage != null ? lastMessage() : this.lastMessage,
      firstUserUnreadCount: firstUserUnreadCount ?? this.firstUserUnreadCount,
      secondUserUnreadCount: secondUserUnreadCount ?? this.secondUserUnreadCount,
      firstUserMuted: firstUserMuted ?? this.firstUserMuted,
      secondUserMuted: secondUserMuted ?? this.secondUserMuted,
      firstUserArchived: firstUserArchived ?? this.firstUserArchived,
      secondUserArchived: secondUserArchived ?? this.secondUserArchived,
      firstUserDeleted: firstUserDeleted ?? this.firstUserDeleted,
      secondUserDeleted: secondUserDeleted ?? this.secondUserDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty conversation
  static final empty = Conversation(
    id: '',
    firstUserId: '',
    secondUserId: '',
    lastMessage: null,
    firstUserUnreadCount: 0,
    secondUserUnreadCount: 0,
    firstUserMuted: false,
    secondUserMuted: false,
    firstUserArchived: false,
    secondUserArchived: false,
    firstUserDeleted: false,
    secondUserDeleted: false,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == Conversation.empty;

  /// Is not empty
  bool get isNotEmpty => this != Conversation.empty;

  /// Get other user ID
  String getOtherUserId(String userId) {
    return userId == firstUserId ? secondUserId : firstUserId;
  }

  /// Get unread count
  int getUnreadCount(String userId) {
    return userId == firstUserId ? firstUserUnreadCount : secondUserUnreadCount;
  }

  /// Is muted
  bool isMuted(String userId) {
    return userId == firstUserId ? firstUserMuted : secondUserMuted;
  }

  /// Is archived
  bool isArchived(String userId) {
    return userId == firstUserId ? firstUserArchived : secondUserArchived;
  }

  /// Is deleted
  bool isDeleted(String userId) {
    return userId == firstUserId ? firstUserDeleted : secondUserDeleted;
  }

  @override
  List<Object?> get props => [
        id,
        firstUserId,
        secondUserId,
        lastMessage,
        firstUserUnreadCount,
        secondUserUnreadCount,
        firstUserMuted,
        secondUserMuted,
        firstUserArchived,
        secondUserArchived,
        firstUserDeleted,
        secondUserDeleted,
        createdAt,
        updatedAt,
      ];
}
