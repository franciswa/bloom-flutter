import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'chart.dart';

part 'compatibility.g.dart';

/// Compatibility level enum
enum CompatibilityLevel {
  /// Very low
  veryLow,

  /// Low
  low,

  /// Moderate
  moderate,

  /// High
  high,

  /// Very high
  veryHigh,
}

/// Compatibility aspect model
@JsonSerializable()
class CompatibilityAspect extends Equatable {
  /// Aspect
  final Aspect aspect;

  /// First user planet
  final Planet firstUserPlanet;

  /// Second user planet
  final Planet secondUserPlanet;

  /// Orb
  final double orb;

  /// Score
  final int score;

  /// Description
  final String description;

  /// Creates a new [CompatibilityAspect] instance
  const CompatibilityAspect({
    required this.aspect,
    required this.firstUserPlanet,
    required this.secondUserPlanet,
    required this.orb,
    required this.score,
    required this.description,
  });

  /// Creates a new [CompatibilityAspect] instance from JSON
  factory CompatibilityAspect.fromJson(Map<String, dynamic> json) => _$CompatibilityAspectFromJson(json);

  /// Converts this [CompatibilityAspect] instance to JSON
  Map<String, dynamic> toJson() => _$CompatibilityAspectToJson(this);

  @override
  List<Object?> get props => [aspect, firstUserPlanet, secondUserPlanet, orb, score, description];
}

/// Compatibility category model
@JsonSerializable()
class CompatibilityCategory extends Equatable {
  /// Name
  final String name;

  /// Score
  final int score;

  /// Level
  final CompatibilityLevel level;

  /// Description
  final String description;

  /// Creates a new [CompatibilityCategory] instance
  const CompatibilityCategory({
    required this.name,
    required this.score,
    required this.level,
    required this.description,
  });

  /// Creates a new [CompatibilityCategory] instance from JSON
  factory CompatibilityCategory.fromJson(Map<String, dynamic> json) => _$CompatibilityCategoryFromJson(json);

  /// Converts this [CompatibilityCategory] instance to JSON
  Map<String, dynamic> toJson() => _$CompatibilityCategoryToJson(this);

  @override
  List<Object?> get props => [name, score, level, description];
}

/// Compatibility model
@JsonSerializable()
class Compatibility extends Equatable {
  /// First user ID
  final String firstUserId;

  /// Second user ID
  final String secondUserId;

  /// Overall score
  final int overallScore;

  /// Astrological score (0-100)
  final int astrologicalScore;

  /// Questionnaire score (0-100)
  final int questionnaireScore;

  /// Overall level
  final CompatibilityLevel overallLevel;

  /// Overall description
  final String overallDescription;

  /// Detailed report
  final String? report;

  /// Categories
  final List<CompatibilityCategory> categories;

  /// Aspects
  final List<CompatibilityAspect> aspects;

  /// Created at
  final DateTime createdAt;

  /// Updated at
  final DateTime updatedAt;

  /// Creates a new [Compatibility] instance
  const Compatibility({
    required this.firstUserId,
    required this.secondUserId,
    required this.overallScore,
    this.astrologicalScore = 0,
    this.questionnaireScore = 0,
    required this.overallLevel,
    required this.overallDescription,
    this.report,
    required this.categories,
    required this.aspects,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new [Compatibility] instance from JSON
  factory Compatibility.fromJson(Map<String, dynamic> json) => _$CompatibilityFromJson(json);

  /// Converts this [Compatibility] instance to JSON
  Map<String, dynamic> toJson() => _$CompatibilityToJson(this);

  /// Creates a copy of this [Compatibility] instance with the given fields replaced
  Compatibility copyWith({
    String? firstUserId,
    String? secondUserId,
    int? overallScore,
    int? astrologicalScore,
    int? questionnaireScore,
    CompatibilityLevel? overallLevel,
    String? overallDescription,
    String? report,
    List<CompatibilityCategory>? categories,
    List<CompatibilityAspect>? aspects,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Compatibility(
      firstUserId: firstUserId ?? this.firstUserId,
      secondUserId: secondUserId ?? this.secondUserId,
      overallScore: overallScore ?? this.overallScore,
      astrologicalScore: astrologicalScore ?? this.astrologicalScore,
      questionnaireScore: questionnaireScore ?? this.questionnaireScore,
      overallLevel: overallLevel ?? this.overallLevel,
      overallDescription: overallDescription ?? this.overallDescription,
      report: report ?? this.report,
      categories: categories ?? this.categories,
      aspects: aspects ?? this.aspects,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Empty date time
  static final _emptyDateTime = DateTime.utc(1970);

  /// Empty compatibility
  static final empty = Compatibility(
    firstUserId: '',
    secondUserId: '',
    overallScore: 0,
    astrologicalScore: 0,
    questionnaireScore: 0,
    overallLevel: CompatibilityLevel.moderate,
    overallDescription: '',
    report: null,
    categories: [],
    aspects: [],
    createdAt: _emptyDateTime,
    updatedAt: _emptyDateTime,
  );

  /// Is empty
  bool get isEmpty => this == Compatibility.empty;

  /// Is not empty
  bool get isNotEmpty => this != Compatibility.empty;

  /// Get compatibility level color
  static String getCompatibilityLevelColor(CompatibilityLevel level) {
    switch (level) {
      case CompatibilityLevel.veryLow:
        return '#F44336'; // Red
      case CompatibilityLevel.low:
        return '#FF9800'; // Orange
      case CompatibilityLevel.moderate:
        return '#FFC107'; // Amber
      case CompatibilityLevel.high:
        return '#4CAF50'; // Green
      case CompatibilityLevel.veryHigh:
        return '#2196F3'; // Blue
    }
  }

  /// Get compatibility level name
  static String getCompatibilityLevelName(CompatibilityLevel level) {
    switch (level) {
      case CompatibilityLevel.veryLow:
        return 'Very Low';
      case CompatibilityLevel.low:
        return 'Low';
      case CompatibilityLevel.moderate:
        return 'Moderate';
      case CompatibilityLevel.high:
        return 'High';
      case CompatibilityLevel.veryHigh:
        return 'Very High';
    }
  }

  /// Get compatibility level from score
  static CompatibilityLevel getCompatibilityLevelFromScore(int score) {
    if (score < 20) {
      return CompatibilityLevel.veryLow;
    } else if (score < 40) {
      return CompatibilityLevel.low;
    } else if (score < 60) {
      return CompatibilityLevel.moderate;
    } else if (score < 80) {
      return CompatibilityLevel.high;
    } else {
      return CompatibilityLevel.veryHigh;
    }
  }

  @override
  List<Object?> get props => [
        firstUserId,
        secondUserId,
        overallScore,
        astrologicalScore,
        questionnaireScore,
        overallLevel,
        overallDescription,
        report,
        categories,
        aspects,
        createdAt,
        updatedAt,
      ];
}
