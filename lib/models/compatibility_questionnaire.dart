import 'package:flutter/foundation.dart';

/// Compatibility questionnaire category
enum QuestionnaireCategory {
  /// Values
  personalValues,
  
  /// Lifestyle
  lifestyle,
  
  /// Communication
  communication,
  
  /// Intimacy
  intimacy,
  
  /// Future goals
  futureGoals,
}

/// Compatibility questionnaire question
class QuestionnaireQuestion {
  /// Question ID
  final String id;
  
  /// Question text
  final String text;
  
  /// Question category
  final QuestionnaireCategory category;
  
  /// Question weight (1-5)
  final int weight;
  
  /// Creates a new [QuestionnaireQuestion] instance
  const QuestionnaireQuestion({
    required this.id,
    required this.text,
    required this.category,
    required this.weight,
  });
  
  /// Creates a [QuestionnaireQuestion] from JSON
  factory QuestionnaireQuestion.fromJson(Map<String, dynamic> json) {
    return QuestionnaireQuestion(
      id: json['id'] as String,
      text: json['text'] as String,
      category: QuestionnaireCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
      ),
      weight: json['weight'] as int,
    );
  }
  
  /// Converts [QuestionnaireQuestion] to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category.toString().split('.').last,
      'weight': weight,
    };
  }
  
  /// Creates a copy of [QuestionnaireQuestion] with specified attributes
  QuestionnaireQuestion copyWith({
    String? id,
    String? text,
    QuestionnaireCategory? category,
    int? weight,
  }) {
    return QuestionnaireQuestion(
      id: id ?? this.id,
      text: text ?? this.text,
      category: category ?? this.category,
      weight: weight ?? this.weight,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is QuestionnaireQuestion &&
        other.id == id &&
        other.text == text &&
        other.category == category &&
        other.weight == weight;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^ text.hashCode ^ category.hashCode ^ weight.hashCode;
  }
}

/// Questionnaire answer option
enum AnswerOption {
  /// Strongly disagree
  stronglyDisagree,
  
  /// Disagree
  disagree,
  
  /// Neutral
  neutral,
  
  /// Agree
  agree,
  
  /// Strongly agree
  stronglyAgree,
}

/// Compatibility questionnaire answer
class QuestionnaireAnswer {
  /// Question ID
  final String questionId;
  
  /// User ID
  final String userId;
  
  /// Answer option
  final AnswerOption answer;
  
  /// Created at
  final DateTime createdAt;
  
  /// Updated at
  final DateTime updatedAt;
  
  /// Creates a new [QuestionnaireAnswer] instance
  const QuestionnaireAnswer({
    required this.questionId,
    required this.userId,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Creates a [QuestionnaireAnswer] from JSON
  factory QuestionnaireAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionnaireAnswer(
      questionId: json['question_id'] as String,
      userId: json['user_id'] as String,
      answer: AnswerOption.values.firstWhere(
        (e) => e.toString().split('.').last == json['answer'],
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  
  /// Converts [QuestionnaireAnswer] to JSON
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'user_id': userId,
      'answer': answer.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  /// Creates a copy of [QuestionnaireAnswer] with specified attributes
  QuestionnaireAnswer copyWith({
    String? questionId,
    String? userId,
    AnswerOption? answer,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuestionnaireAnswer(
      questionId: questionId ?? this.questionId,
      userId: userId ?? this.userId,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is QuestionnaireAnswer &&
        other.questionId == questionId &&
        other.userId == userId &&
        other.answer == answer &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }
  
  @override
  int get hashCode {
    return questionId.hashCode ^
        userId.hashCode ^
        answer.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

/// Compatibility questionnaire result
class QuestionnaireResult {
  /// User 1 ID
  final String user1Id;
  
  /// User 2 ID
  final String user2Id;
  
  /// Overall score (0-100)
  final int overallScore;
  
  /// Category scores
  final Map<QuestionnaireCategory, int> categoryScores;
  
  /// Created at
  final DateTime createdAt;
  
  /// Updated at
  final DateTime updatedAt;
  
  /// Creates a new [QuestionnaireResult] instance
  const QuestionnaireResult({
    required this.user1Id,
    required this.user2Id,
    required this.overallScore,
    required this.categoryScores,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Creates a [QuestionnaireResult] from JSON
  factory QuestionnaireResult.fromJson(Map<String, dynamic> json) {
    final categoryScoresJson = json['category_scores'] as Map<String, dynamic>;
    final categoryScores = <QuestionnaireCategory, int>{};
    
    categoryScoresJson.forEach((key, value) {
      final category = QuestionnaireCategory.values.firstWhere(
        (e) => e.toString().split('.').last == key,
      );
      categoryScores[category] = value as int;
    });
    
    return QuestionnaireResult(
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      overallScore: json['overall_score'] as int,
      categoryScores: categoryScores,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  
  /// Converts [QuestionnaireResult] to JSON
  Map<String, dynamic> toJson() {
    final categoryScoresJson = <String, dynamic>{};
    
    categoryScores.forEach((key, value) {
      categoryScoresJson[key.toString().split('.').last] = value;
    });
    
    return {
      'user1_id': user1Id,
      'user2_id': user2Id,
      'overall_score': overallScore,
      'category_scores': categoryScoresJson,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  /// Creates a copy of [QuestionnaireResult] with specified attributes
  QuestionnaireResult copyWith({
    String? user1Id,
    String? user2Id,
    int? overallScore,
    Map<QuestionnaireCategory, int>? categoryScores,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuestionnaireResult(
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      overallScore: overallScore ?? this.overallScore,
      categoryScores: categoryScores ?? this.categoryScores,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is QuestionnaireResult &&
        other.user1Id == user1Id &&
        other.user2Id == user2Id &&
        other.overallScore == overallScore &&
        mapEquals(other.categoryScores, categoryScores) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }
  
  @override
  int get hashCode {
    return user1Id.hashCode ^
        user2Id.hashCode ^
        overallScore.hashCode ^
        categoryScores.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
