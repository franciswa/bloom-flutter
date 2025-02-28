import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'compatibility.dart';

part 'match.g.dart';

/// Match action enum
enum MatchAction {
  /// None
  none,

  /// Like
  like,

  /// Dislike
  dislike,
}

/// Match status enum
enum MatchStatus {
  /// Pending
  pending,

  /// Matched
  matched,

  /// Rejected
  rejected,

  /// Expired
  expired,

  /// Unmatched
  unmatched,

  /// Blocked
  blocked,

  /// Reported
  reported,
}

/// Match model
@JsonSerializable()
class Match extends Equatable {
  /// Match ID
  final String id;

  /// First user ID
  final String firstUserId;

  /// Second user ID
  final String secondUserId;

  /// User 1 ID (alias for firstUserId)
  String get user1Id => firstUserId;

  /// User 2 ID (alias for secondUserId)
  String get user2Id => secondUserId;

  /// Compatibility score
  final int compatibilityScore;

  /// Compatibility level
  final CompatibilityLevel compatibilityLevel;

  /// Status
  final MatchStatus status;

  /// First user action
  final MatchAction firstUserAction;

  /// Second user action
  final MatchAction secondUserAction;

  /// User 1 action (alias for firstUserAction)
  MatchAction get user1Action => firstUserAction;

  /// User 2 action (alias for secondUserAction)
  MatchAction get user2Action => secondUserAction;

  /// First user liked
  final bool firstUserLiked;

  /// Second user liked
  final bool secondUserLiked;

  /// First user seen
  final bool firstUserSeen;

  /// Second user seen
  final bool secondUserSeen;

  /// Report reason
  final String? reportReason;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Expires at
  final DateTime expiresAt;

  /// Creates a new [Match] instance
  const Match({
    required this.id,
    required this.firstUserId,
    required this.secondUserId,
    required this.compatibilityScore,
    required this.compatibilityLevel,
    required this.status,
    this.firstUserAction = MatchAction.none,
    this.secondUserAction = MatchAction.none,
    required this.firstUserLiked,
    required this.secondUserLiked,
    required this.firstUserSeen,
    required this.secondUserSeen,
    this.reportReason,
    required this.createdAt,
    required this.updatedAt,
    required this.expiresAt,
  });

  /// Creates a new [Match] instance from JSON
  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  /// Converts this [Match] instance to JSON
  Map<String, dynamic> toJson() => _$MatchToJson(this);

  /// Creates a copy of this [Match] instance with the given fields replaced
  Match copyWith({
    String? id,
    String? firstUserId,
    String? secondUserId,
    int? compatibilityScore,
    CompatibilityLevel? compatibilityLevel,
    MatchStatus? status,
    MatchAction? firstUserAction,
    MatchAction? secondUserAction,
    MatchAction? user1Action,
    MatchAction? user2Action,
    bool? firstUserLiked,
    bool? secondUserLiked,
    bool? firstUserSeen,
    bool? secondUserSeen,
    String? Function()? reportReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
  }) {
    return Match(
      id: id ?? this.id,
      firstUserId: firstUserId ?? this.firstUserId,
      secondUserId: secondUserId ?? this.secondUserId,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      compatibilityLevel: compatibilityLevel ?? this.compatibilityLevel,
      status: status ?? this.status,
      firstUserAction: user1Action ?? firstUserAction ?? this.firstUserAction,
      secondUserAction:
          user2Action ?? secondUserAction ?? this.secondUserAction,
      firstUserLiked: firstUserLiked ?? this.firstUserLiked,
      secondUserLiked: secondUserLiked ?? this.secondUserLiked,
      firstUserSeen: firstUserSeen ?? this.firstUserSeen,
      secondUserSeen: secondUserSeen ?? this.secondUserSeen,
      reportReason: reportReason != null ? reportReason() : this.reportReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty match
  static final empty = Match(
    id: '',
    firstUserId: '',
    secondUserId: '',
    compatibilityScore: 0,
    compatibilityLevel: CompatibilityLevel.moderate,
    status: MatchStatus.pending,
    firstUserAction: MatchAction.none,
    secondUserAction: MatchAction.none,
    firstUserLiked: false,
    secondUserLiked: false,
    firstUserSeen: false,
    secondUserSeen: false,
    reportReason: null,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
    expiresAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == Match.empty;

  /// Is not empty
  bool get isNotEmpty => this != Match.empty;

  /// Is mutual match
  bool get isMutualMatch => firstUserLiked && secondUserLiked;

  /// Is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Get other user ID
  String getOtherUserId(String userId) {
    return userId == firstUserId ? secondUserId : firstUserId;
  }

  /// Get user liked
  bool getUserLiked(String userId) {
    return userId == firstUserId ? firstUserLiked : secondUserLiked;
  }

  /// Get user seen
  bool getUserSeen(String userId) {
    return userId == firstUserId ? firstUserSeen : secondUserSeen;
  }

  /// Get match status name
  static String getMatchStatusName(MatchStatus status) {
    switch (status) {
      case MatchStatus.pending:
        return 'Pending';
      case MatchStatus.matched:
        return 'Matched';
      case MatchStatus.rejected:
        return 'Rejected';
      case MatchStatus.expired:
        return 'Expired';
      case MatchStatus.unmatched:
        return 'Unmatched';
      case MatchStatus.blocked:
        return 'Blocked';
      case MatchStatus.reported:
        return 'Reported';
    }
  }

  @override
  List<Object?> get props => [
        id,
        firstUserId,
        secondUserId,
        compatibilityScore,
        compatibilityLevel,
        status,
        firstUserAction,
        secondUserAction,
        firstUserLiked,
        secondUserLiked,
        firstUserSeen,
        secondUserSeen,
        reportReason,
        createdAt,
        updatedAt,
        expiresAt,
      ];
}
