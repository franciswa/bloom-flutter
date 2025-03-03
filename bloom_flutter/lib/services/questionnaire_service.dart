import '../config/app_config.dart';
import '../models/compatibility_questionnaire.dart';
import 'supabase_service.dart';
import 'auth_service.dart' show isDemoMode;

/// Questionnaire service
class QuestionnaireService {
  /// Questions table name
  static const String _questionsTable =
      AppConfig.supabaseQuestionnaireQuestionsTable;

  /// Answers table name
  static const String _answersTable =
      AppConfig.supabaseQuestionnaireAnswersTable;

  /// Results table name
  static const String _resultsTable =
      AppConfig.supabaseQuestionnaireResultsTable;

  /// Demo questions for testing
  final List<QuestionnaireQuestion> _demoQuestions = [
    // Personal Values Category
    QuestionnaireQuestion(
      id: 'q1',
      text: 'I believe honesty is the most important value in a relationship.',
      category: QuestionnaireCategory.personalValues,
      weight: 5,
    ),
    QuestionnaireQuestion(
      id: 'q6',
      text: 'I believe in maintaining some independence in a relationship.',
      category: QuestionnaireCategory.personalValues,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q11',
      text: 'I prefer traditional and defined roles in relationships.',
      category: QuestionnaireCategory.personalValues,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q12',
      text: 'I value independence and personal space in relationships.',
      category: QuestionnaireCategory.personalValues,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q13',
      text:
          'I believe a successful relationship means both parties get good value from it.',
      category: QuestionnaireCategory.personalValues,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q14',
      text:
          'I believe a successful relationship means deep emotional connection and growth.',
      category: QuestionnaireCategory.personalValues,
      weight: 5,
    ),
    QuestionnaireQuestion(
      id: 'q15',
      text: 'I believe humor is an essential part of a relationship.',
      category: QuestionnaireCategory.personalValues,
      weight: 3,
    ),

    // Lifestyle Category
    QuestionnaireQuestion(
      id: 'q2',
      text: 'I enjoy spending time outdoors and in nature.',
      category: QuestionnaireCategory.lifestyle,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q7',
      text: 'I enjoy trying new restaurants and foods.',
      category: QuestionnaireCategory.lifestyle,
      weight: 2,
    ),
    QuestionnaireQuestion(
      id: 'q10',
      text: 'I enjoy socializing and meeting new people.',
      category: QuestionnaireCategory.lifestyle,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q16',
      text:
          'My ideal lifestyle involves regular excitement and new experiences.',
      category: QuestionnaireCategory.lifestyle,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q17',
      text: 'I prefer a stable routine with occasional variety.',
      category: QuestionnaireCategory.lifestyle,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q18',
      text:
          'I typically spend my free time working on personal development or career.',
      category: QuestionnaireCategory.lifestyle,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q19',
      text: 'I prefer quiet predictability and security in my lifestyle.',
      category: QuestionnaireCategory.lifestyle,
      weight: 3,
    ),

    // Communication Category
    QuestionnaireQuestion(
      id: 'q3',
      text: 'I prefer to talk through conflicts rather than avoid them.',
      category: QuestionnaireCategory.communication,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q8',
      text: 'I am comfortable expressing my emotions openly.',
      category: QuestionnaireCategory.communication,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q20',
      text: 'My communication style is direct and straightforward.',
      category: QuestionnaireCategory.communication,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q21',
      text: 'I address issues directly and immediately when conflicts arise.',
      category: QuestionnaireCategory.communication,
      weight: 5,
    ),
    QuestionnaireQuestion(
      id: 'q22',
      text: 'I prefer diplomatic and considerate communication.',
      category: QuestionnaireCategory.communication,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q23',
      text: 'I view relationship problems as opportunities for growth.',
      category: QuestionnaireCategory.communication,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q24',
      text: 'I tend to avoid confrontation whenever possible.',
      category: QuestionnaireCategory.communication,
      weight: 3,
    ),

    // Intimacy Category
    QuestionnaireQuestion(
      id: 'q4',
      text: 'Physical touch is important to me in a relationship.',
      category: QuestionnaireCategory.intimacy,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q25',
      text: 'I primarily express care through physical affection and intimacy.',
      category: QuestionnaireCategory.intimacy,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q26',
      text:
          'I prioritize strong attraction and sexual chemistry in relationships.',
      category: QuestionnaireCategory.intimacy,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q27',
      text: 'I express care through emotional support and listening.',
      category: QuestionnaireCategory.intimacy,
      weight: 5,
    ),
    QuestionnaireQuestion(
      id: 'q28',
      text: 'I show care through practical support and resources.',
      category: QuestionnaireCategory.intimacy,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q29',
      text: 'I express care through gifts and acts of service.',
      category: QuestionnaireCategory.intimacy,
      weight: 3,
    ),

    // Future Goals Category
    QuestionnaireQuestion(
      id: 'q5',
      text: 'I want to have children in the future.',
      category: QuestionnaireCategory.futureGoals,
      weight: 5,
    ),
    QuestionnaireQuestion(
      id: 'q9',
      text: 'I believe in maintaining a healthy work-life balance.',
      category: QuestionnaireCategory.futureGoals,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q30',
      text: 'I have clear goals and timelines for my future.',
      category: QuestionnaireCategory.futureGoals,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q31',
      text: 'I have general ideas about my future but stay flexible.',
      category: QuestionnaireCategory.futureGoals,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q32',
      text: 'I prefer to live in the present rather than plan for the future.',
      category: QuestionnaireCategory.futureGoals,
      weight: 3,
    ),
    QuestionnaireQuestion(
      id: 'q33',
      text:
          'My approach to commitment is very selective and carefully considered.',
      category: QuestionnaireCategory.futureGoals,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q34',
      text: 'I am eager to find lasting connection and commitment.',
      category: QuestionnaireCategory.futureGoals,
      weight: 4,
    ),
    QuestionnaireQuestion(
      id: 'q35',
      text: 'I prefer keeping my options open rather than committing early.',
      category: QuestionnaireCategory.futureGoals,
      weight: 3,
    ),
  ];

  /// Get all questions
  Future<List<QuestionnaireQuestion>> getAllQuestions() async {
    // Return demo questions if in demo mode
    if (isDemoMode) {
      return _demoQuestions;
    }

    final response = await SupabaseService.from(_questionsTable)
        .select()
        .order('category')
        .order('id');

    return response
        .map<QuestionnaireQuestion>(
            (json) => QuestionnaireQuestion.fromJson(json))
        .toList();
  }

  /// Get questions by category
  Future<List<QuestionnaireQuestion>> getQuestionsByCategory(
      QuestionnaireCategory category) async {
    // Return demo questions if in demo mode
    if (isDemoMode) {
      return _demoQuestions.where((q) => q.category == category).toList();
    }

    final response = await SupabaseService.from(_questionsTable)
        .select()
        .eq('category', category.toString().split('.').last)
        .order('id');

    return response
        .map<QuestionnaireQuestion>(
            (json) => QuestionnaireQuestion.fromJson(json))
        .toList();
  }

  /// Get question by ID
  Future<QuestionnaireQuestion?> getQuestionById(String questionId) async {
    // Return demo question if in demo mode
    if (isDemoMode) {
      try {
        return _demoQuestions.firstWhere((q) => q.id == questionId);
      } catch (e) {
        return null;
      }
    }

    final response = await SupabaseService.from(_questionsTable)
        .select()
        .eq('id', questionId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return QuestionnaireQuestion.fromJson(response);
  }

  /// Demo user answers
  final Map<String, List<QuestionnaireAnswer>> _demoUserAnswers = {};

  /// Get user answers
  Future<List<QuestionnaireAnswer>> getUserAnswers(String userId) async {
    // Return demo answers if in demo mode
    if (isDemoMode) {
      return _demoUserAnswers[userId] ?? [];
    }

    final response = await SupabaseService.from(_answersTable)
        .select()
        .eq('user_id', userId)
        .order('question_id');

    return response
        .map<QuestionnaireAnswer>((json) => QuestionnaireAnswer.fromJson(json))
        .toList();
  }

  /// Get user answer for question
  Future<QuestionnaireAnswer?> getUserAnswerForQuestion(
      String userId, String questionId) async {
    // Return demo answer if in demo mode
    if (isDemoMode) {
      final userAnswers = _demoUserAnswers[userId] ?? [];
      try {
        return userAnswers.firstWhere((a) => a.questionId == questionId);
      } catch (e) {
        return null;
      }
    }

    final response = await SupabaseService.from(_answersTable)
        .select()
        .eq('user_id', userId)
        .eq('question_id', questionId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return QuestionnaireAnswer.fromJson(response);
  }

  /// Save user answer
  Future<QuestionnaireAnswer> saveUserAnswer({
    required String userId,
    required String questionId,
    required AnswerOption answer,
  }) async {
    final now = DateTime.now();

    // Handle demo mode
    if (isDemoMode) {
      // Initialize user answers list if it doesn't exist
      _demoUserAnswers[userId] ??= [];

      // Check if answer already exists
      final existingIndex = _demoUserAnswers[userId]!
          .indexWhere((a) => a.questionId == questionId);

      if (existingIndex != -1) {
        // Update existing answer
        final updatedAnswer = _demoUserAnswers[userId]![existingIndex].copyWith(
          answer: answer,
          updatedAt: now,
        );

        _demoUserAnswers[userId]![existingIndex] = updatedAnswer;
        return updatedAnswer;
      } else {
        // Create new answer
        final newAnswer = QuestionnaireAnswer(
          userId: userId,
          questionId: questionId,
          answer: answer,
          createdAt: now,
          updatedAt: now,
        );

        _demoUserAnswers[userId]!.add(newAnswer);
        return newAnswer;
      }
    }

    // Check if answer already exists
    final existingAnswer = await getUserAnswerForQuestion(userId, questionId);

    if (existingAnswer != null) {
      // Update existing answer
      final updatedAnswer = existingAnswer.copyWith(
        answer: answer,
        updatedAt: now,
      );

      final response = await SupabaseService.from(_answersTable)
          .update(updatedAnswer.toJson())
          .eq('user_id', userId)
          .eq('question_id', questionId)
          .select()
          .single();

      return QuestionnaireAnswer.fromJson(response);
    } else {
      // Create new answer
      final newAnswer = QuestionnaireAnswer(
        userId: userId,
        questionId: questionId,
        answer: answer,
        createdAt: now,
        updatedAt: now,
      );

      final response = await SupabaseService.from(_answersTable)
          .insert(newAnswer.toJson())
          .select()
          .single();

      return QuestionnaireAnswer.fromJson(response);
    }
  }

  /// Delete user answer
  Future<void> deleteUserAnswer(String userId, String questionId) async {
    // Handle demo mode
    if (isDemoMode) {
      if (_demoUserAnswers.containsKey(userId)) {
        _demoUserAnswers[userId]!
            .removeWhere((a) => a.questionId == questionId);
      }
      return;
    }

    await SupabaseService.from(_answersTable)
        .delete()
        .eq('user_id', userId)
        .eq('question_id', questionId);
  }

  /// Delete all user answers
  Future<void> deleteAllUserAnswers(String userId) async {
    // Handle demo mode
    if (isDemoMode) {
      _demoUserAnswers[userId] = [];
      return;
    }

    await SupabaseService.from(_answersTable).delete().eq('user_id', userId);
  }

  /// Demo questionnaire results
  final Map<String, QuestionnaireResult> _demoResults = {};

  /// Get questionnaire result
  Future<QuestionnaireResult?> getQuestionnaireResult(
      String user1Id, String user2Id) async {
    // Handle demo mode
    if (isDemoMode) {
      // Check for result with user1Id and user2Id
      final separator = '_';
      final resultKey1 = user1Id + separator + user2Id;
      if (_demoResults.containsKey(resultKey1)) {
        return _demoResults[resultKey1];
      }

      // Check for result with user2Id and user1Id
      final resultKey2 = user2Id + separator + user1Id;
      if (_demoResults.containsKey(resultKey2)) {
        return _demoResults[resultKey2];
      }

      return null;
    }

    // Try to find result with user1Id and user2Id
    final response1 = await SupabaseService.from(_resultsTable)
        .select()
        .eq('user1_id', user1Id)
        .eq('user2_id', user2Id)
        .maybeSingle();

    if (response1 != null) {
      return QuestionnaireResult.fromJson(response1);
    }

    // Try to find result with user2Id and user1Id
    final response2 = await SupabaseService.from(_resultsTable)
        .select()
        .eq('user1_id', user2Id)
        .eq('user2_id', user1Id)
        .maybeSingle();

    if (response2 != null) {
      return QuestionnaireResult.fromJson(response2);
    }

    return null;
  }

  /// Calculate questionnaire compatibility
  Future<QuestionnaireResult> calculateQuestionnaireCompatibility(
      String user1Id, String user2Id) async {
    // Get all questions
    final questions = await getAllQuestions();

    // Get user answers
    final user1Answers = await getUserAnswers(user1Id);
    final user2Answers = await getUserAnswers(user2Id);

    // Calculate category scores
    final categoryScores = <QuestionnaireCategory, int>{};
    final categoryTotals = <QuestionnaireCategory, int>{};

    // Initialize category scores and totals
    for (final category in QuestionnaireCategory.values) {
      categoryScores[category] = 0;
      categoryTotals[category] = 0;
    }

    // Calculate scores for each question
    for (final question in questions) {
      final user1Answer = user1Answers.firstWhere(
        (a) => a.questionId == question.id,
        orElse: () => QuestionnaireAnswer(
          questionId: question.id,
          userId: user1Id,
          answer: AnswerOption.neutral,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final user2Answer = user2Answers.firstWhere(
        (a) => a.questionId == question.id,
        orElse: () => QuestionnaireAnswer(
          questionId: question.id,
          userId: user2Id,
          answer: AnswerOption.neutral,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Calculate compatibility score for this question
      final score =
          _calculateAnswerCompatibility(user1Answer.answer, user2Answer.answer);

      // Add to category score and total
      categoryScores[question.category] =
          (categoryScores[question.category] ?? 0) + (score * question.weight);
      categoryTotals[question.category] =
          (categoryTotals[question.category] ?? 0) +
              (5 * question.weight); // 5 is max score
    }

    // Calculate final category scores (0-100)
    final finalCategoryScores = <QuestionnaireCategory, int>{};

    for (final category in QuestionnaireCategory.values) {
      final score = categoryScores[category] ?? 0;
      final total = categoryTotals[category] ?? 1; // Avoid division by zero

      finalCategoryScores[category] = ((score / total) * 100).round();
    }

    // Calculate overall score (average of category scores)
    int overallScore = 0;
    int totalCategories = 0;

    for (final category in QuestionnaireCategory.values) {
      final score = finalCategoryScores[category] ?? 0;

      // Only include categories with questions
      if (categoryTotals[category]! > 0) {
        overallScore += score;
        totalCategories++;
      }
    }

    overallScore =
        totalCategories > 0 ? (overallScore / totalCategories).round() : 0;

    // Create result
    final now = DateTime.now();
    final result = QuestionnaireResult(
      user1Id: user1Id,
      user2Id: user2Id,
      overallScore: overallScore,
      categoryScores: finalCategoryScores,
      createdAt: now,
      updatedAt: now,
    );

    // Save result
    await saveQuestionnaireResult(result);

    return result;
  }

  /// Save questionnaire result
  Future<QuestionnaireResult> saveQuestionnaireResult(
      QuestionnaireResult result) async {
    // Handle demo mode
    if (isDemoMode) {
      final separator = '_';
      final resultKey = '${result.user1Id}${separator}${result.user2Id}';
      _demoResults[resultKey] = result;
      return result;
    }

    // Check if result already exists
    final existingResult =
        await getQuestionnaireResult(result.user1Id, result.user2Id);

    if (existingResult != null) {
      // Update existing result
      final updatedResult = existingResult.copyWith(
        overallScore: result.overallScore,
        categoryScores: result.categoryScores,
        updatedAt: DateTime.now(),
      );

      final response = await SupabaseService.from(_resultsTable)
          .update(updatedResult.toJson())
          .eq('user1_id', existingResult.user1Id)
          .eq('user2_id', existingResult.user2Id)
          .select()
          .single();

      return QuestionnaireResult.fromJson(response);
    } else {
      // Create new result
      final response = await SupabaseService.from(_resultsTable)
          .insert(result.toJson())
          .select()
          .single();

      return QuestionnaireResult.fromJson(response);
    }
  }

  /// Delete questionnaire result
  Future<void> deleteQuestionnaireResult(String user1Id, String user2Id) async {
    // Handle demo mode
    if (isDemoMode) {
      final separator = '_';
      final resultKey1 = user1Id + separator + user2Id;
      final resultKey2 = user2Id + separator + user1Id;
      _demoResults.remove(resultKey1);
      _demoResults.remove(resultKey2);
      return;
    }

    // Try to delete result with user1Id and user2Id
    await SupabaseService.from(_resultsTable)
        .delete()
        .eq('user1_id', user1Id)
        .eq('user2_id', user2Id);

    // Try to delete result with user2Id and user1Id
    await SupabaseService.from(_resultsTable)
        .delete()
        .eq('user1_id', user2Id)
        .eq('user2_id', user1Id);
  }

  /// Calculate answer compatibility
  int _calculateAnswerCompatibility(
      AnswerOption answer1, AnswerOption answer2) {
    // Convert enum to numeric value (0-4)
    final value1 = answer1.index;
    final value2 = answer2.index;

    // Calculate absolute difference (0-4)
    final difference = (value1 - value2).abs();

    // Convert to compatibility score (5 is max compatibility, 1 is min)
    return 5 - difference;
  }
}
