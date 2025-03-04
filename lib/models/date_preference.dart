import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'astrology.dart';
import 'profile.dart';

part 'date_preference.g.dart';

/// Date type enum
enum DateType {
  /// Dining
  dining,

  /// Coffee
  coffee,

  /// Drinks
  drinks,

  /// Outdoors
  outdoors,

  /// Entertainment
  entertainment,

  /// Cultural
  cultural,

  /// Sports
  sports,

  /// Other
  other,
}

/// Activity type enum
enum ActivityType {
  /// Dining
  dining,

  /// Coffee
  coffee,

  /// Drinks
  drinks,

  /// Outdoors
  outdoors,

  /// Entertainment
  entertainment,

  /// Cultural
  cultural,

  /// Sports
  sports,

  /// Other
  other,
}

/// Date suggestion status enum
enum DateSuggestionStatus {
  /// Pending
  pending,

  /// Accepted
  accepted,

  /// Rejected
  rejected,

  /// Scheduled
  scheduled,

  /// Completed
  completed,

  /// Cancelled
  cancelled,
}

/// Budget level enum
enum BudgetLevel {
  /// Free
  free,

  /// Low
  low,

  /// Medium
  medium,

  /// High
  high,
}

/// Date preference model
@JsonSerializable()
class DatePreference extends Equatable {
  /// User ID
  final String userId;

  /// Preferred activity types
  final List<ActivityType> preferredActivityTypes;

  /// Preferred types
  final List<DateType> preferredTypes;

  /// Preferred locations
  final List<String> preferredLocations;

  /// Preferred activities
  final List<String> preferredActivities;

  /// Preferred budget level
  final BudgetLevel preferredBudgetLevel;

  /// Preferred distance (in kilometers)
  final double preferredDistance;

  /// Preferred age min
  final int? preferredAgeMin;

  /// Preferred age max
  final int? preferredAgeMax;

  /// Preferred gender
  final Gender? preferredGender;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Creates a new [DatePreference] instance
  const DatePreference({
    required this.userId,
    required this.preferredActivityTypes,
    required this.preferredTypes,
    required this.preferredLocations,
    required this.preferredActivities,
    required this.preferredBudgetLevel,
    required this.preferredDistance,
    this.preferredAgeMin,
    this.preferredAgeMax,
    this.preferredGender,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new [DatePreference] instance from JSON
  factory DatePreference.fromJson(Map<String, dynamic> json) =>
      _$DatePreferenceFromJson(json);

  /// Converts this [DatePreference] instance to JSON
  Map<String, dynamic> toJson() => _$DatePreferenceToJson(this);

  /// Creates a copy of this [DatePreference] instance with the given fields replaced
  DatePreference copyWith({
    String? userId,
    List<ActivityType>? preferredActivityTypes,
    List<DateType>? preferredTypes,
    List<String>? preferredLocations,
    List<String>? preferredActivities,
    BudgetLevel? preferredBudgetLevel,
    double? preferredDistance,
    int? Function()? preferredAgeMin,
    int? Function()? preferredAgeMax,
    Gender? Function()? preferredGender,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DatePreference(
      userId: userId ?? this.userId,
      preferredActivityTypes:
          preferredActivityTypes ?? this.preferredActivityTypes,
      preferredTypes: preferredTypes ?? this.preferredTypes,
      preferredLocations: preferredLocations ?? this.preferredLocations,
      preferredActivities: preferredActivities ?? this.preferredActivities,
      preferredBudgetLevel: preferredBudgetLevel ?? this.preferredBudgetLevel,
      preferredDistance: preferredDistance ?? this.preferredDistance,
      preferredAgeMin:
          preferredAgeMin != null ? preferredAgeMin() : this.preferredAgeMin,
      preferredAgeMax:
          preferredAgeMax != null ? preferredAgeMax() : this.preferredAgeMax,
      preferredGender:
          preferredGender != null ? preferredGender() : this.preferredGender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Default date preference
  static DatePreference defaultPreference(String userId) {
    final now = DateTime.now();
    return DatePreference(
      userId: userId,
      preferredActivityTypes: const [
        ActivityType.dining,
        ActivityType.coffee,
        ActivityType.drinks,
      ],
      preferredTypes: const [
        DateType.dining,
        DateType.coffee,
        DateType.drinks,
      ],
      preferredLocations: const [
        'Restaurant',
        'Cafe',
        'Bar',
      ],
      preferredActivities: const [
        'Dining',
        'Coffee',
        'Drinks',
      ],
      preferredBudgetLevel: BudgetLevel.medium,
      preferredDistance: 10.0,
      preferredAgeMin: null,
      preferredAgeMax: null,
      preferredGender: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty date preference
  static final empty = DatePreference(
    userId: '',
    preferredActivityTypes: const [],
    preferredTypes: const [],
    preferredLocations: const [],
    preferredActivities: const [],
    preferredBudgetLevel: BudgetLevel.medium,
    preferredDistance: 10.0,
    preferredAgeMin: null,
    preferredAgeMax: null,
    preferredGender: null,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == DatePreference.empty;

  /// Is not empty
  bool get isNotEmpty => this != DatePreference.empty;

  /// Get activity type name
  static String getActivityTypeName(ActivityType type) {
    switch (type) {
      case ActivityType.dining:
        return 'Dining';
      case ActivityType.coffee:
        return 'Coffee';
      case ActivityType.drinks:
        return 'Drinks';
      case ActivityType.outdoors:
        return 'Outdoors';
      case ActivityType.entertainment:
        return 'Entertainment';
      case ActivityType.cultural:
        return 'Cultural';
      case ActivityType.sports:
        return 'Sports';
      case ActivityType.other:
        return 'Other';
    }
  }

  /// Get activity type icon
  static String getActivityTypeIcon(ActivityType type) {
    switch (type) {
      case ActivityType.dining:
        return 'assets/icons/dining.svg';
      case ActivityType.coffee:
        return 'assets/icons/coffee.svg';
      case ActivityType.drinks:
        return 'assets/icons/drinks.svg';
      case ActivityType.outdoors:
        return 'assets/icons/outdoors.svg';
      case ActivityType.entertainment:
        return 'assets/icons/entertainment.svg';
      case ActivityType.cultural:
        return 'assets/icons/cultural.svg';
      case ActivityType.sports:
        return 'assets/icons/sports.svg';
      case ActivityType.other:
        return 'assets/icons/other.svg';
    }
  }

  /// Get budget level name
  static String getBudgetLevelName(BudgetLevel level) {
    switch (level) {
      case BudgetLevel.free:
        return 'Free';
      case BudgetLevel.low:
        return 'Low';
      case BudgetLevel.medium:
        return 'Medium';
      case BudgetLevel.high:
        return 'High';
    }
  }

  /// Get budget level icon
  static String getBudgetLevelIcon(BudgetLevel level) {
    switch (level) {
      case BudgetLevel.free:
        return 'assets/icons/free.svg';
      case BudgetLevel.low:
        return 'assets/icons/low_budget.svg';
      case BudgetLevel.medium:
        return 'assets/icons/medium_budget.svg';
      case BudgetLevel.high:
        return 'assets/icons/high_budget.svg';
    }
  }

  @override
  List<Object?> get props => [
        userId,
        preferredActivityTypes,
        preferredTypes,
        preferredLocations,
        preferredActivities,
        preferredBudgetLevel,
        preferredDistance,
        preferredAgeMin,
        preferredAgeMax,
        preferredGender,
        createdAt,
        updatedAt,
      ];
}

/// Date suggestion model
@JsonSerializable()
class DateSuggestion extends Equatable {
  /// Date suggestion ID
  final String id;

  /// User ID
  final String userId;

  /// Match ID
  final String matchId;

  /// Matched user ID
  final String matchedUserId;

  /// Type
  final DateType type;

  /// Title
  final String title;

  /// Description
  final String description;

  /// Location
  final String location;

  /// Activity
  final String activity;

  /// Zodiac sign
  final ZodiacSign? zodiacSign;

  /// Element
  final Element? element;

  /// Image URL
  final String? imageUrl;

  /// Status
  final DateSuggestionStatus status;

  /// Scheduled date
  final DateTime? scheduledDate;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Creates a new [DateSuggestion] instance
  const DateSuggestion({
    required this.id,
    required this.userId,
    required this.matchId,
    required this.matchedUserId,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    required this.activity,
    this.zodiacSign,
    this.element,
    this.imageUrl,
    required this.status,
    this.scheduledDate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new [DateSuggestion] instance from JSON
  factory DateSuggestion.fromJson(Map<String, dynamic> json) =>
      _$DateSuggestionFromJson(json);

  /// Converts this [DateSuggestion] instance to JSON
  Map<String, dynamic> toJson() => _$DateSuggestionToJson(this);

  /// Creates a copy of this [DateSuggestion] instance with the given fields replaced
  DateSuggestion copyWith({
    String? id,
    String? userId,
    String? matchId,
    String? matchedUserId,
    DateType? type,
    String? title,
    String? description,
    String? location,
    String? activity,
    ZodiacSign? Function()? zodiacSign,
    Element? Function()? element,
    String? Function()? imageUrl,
    DateSuggestionStatus? status,
    DateTime? Function()? scheduledDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DateSuggestion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      matchId: matchId ?? this.matchId,
      matchedUserId: matchedUserId ?? this.matchedUserId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      activity: activity ?? this.activity,
      zodiacSign: zodiacSign != null ? zodiacSign() : this.zodiacSign,
      element: element != null ? element() : this.element,
      imageUrl: imageUrl != null ? imageUrl() : this.imageUrl,
      status: status ?? this.status,
      scheduledDate:
          scheduledDate != null ? scheduledDate() : this.scheduledDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty date suggestion
  static final empty = DateSuggestion(
    id: '',
    userId: '',
    matchId: '',
    matchedUserId: '',
    type: DateType.dining,
    title: '',
    description: '',
    location: '',
    activity: '',
    zodiacSign: null,
    element: null,
    imageUrl: null,
    status: DateSuggestionStatus.pending,
    scheduledDate: null,
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == DateSuggestion.empty;

  /// Is not empty
  bool get isNotEmpty => this != DateSuggestion.empty;

  /// Is pending
  bool get isPending => status == DateSuggestionStatus.pending;

  /// Is accepted
  bool get isAccepted => status == DateSuggestionStatus.accepted;

  /// Is rejected
  bool get isRejected => status == DateSuggestionStatus.rejected;

  /// Is scheduled
  bool get isScheduled => status == DateSuggestionStatus.scheduled;

  /// Is completed
  bool get isCompleted => status == DateSuggestionStatus.completed;

  /// Is cancelled
  bool get isCancelled => status == DateSuggestionStatus.cancelled;

  /// Get status name
  String get statusName {
    switch (status) {
      case DateSuggestionStatus.pending:
        return 'Pending';
      case DateSuggestionStatus.accepted:
        return 'Accepted';
      case DateSuggestionStatus.rejected:
        return 'Rejected';
      case DateSuggestionStatus.scheduled:
        return 'Scheduled';
      case DateSuggestionStatus.completed:
        return 'Completed';
      case DateSuggestionStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        matchId,
        matchedUserId,
        type,
        title,
        description,
        location,
        activity,
        zodiacSign,
        element,
        imageUrl,
        status,
        scheduledDate,
        createdAt,
        updatedAt,
      ];
}
