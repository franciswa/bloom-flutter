import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/compatibility_questionnaire.dart';
import 'supabase_service.dart';

/// Questionnaire service
class QuestionnaireService {
  /// Questions table name
  static const String _questionsTable = AppConfig.supabaseQuestionnaireQuestionsTable;
  
  /// Answers table name
  static const String _answersTable = AppConfig.supabaseQuestionnaireAnswersTable;
  
  /// Results table name
  static const String _resultsTable = AppConfig.supabaseQuestionnaireResultsTable;

  /// Get all questions
  Future<List<QuestionnaireQuestion>> getAllQuestions() async {
    final response = await SupabaseService.from(_questionsTable)
        .select()
        .order('category')
        .order('id');

    return response.map<QuestionnaireQuestion>((json) => QuestionnaireQuestion.fromJson(json)).toList();
  }

  /// Get questions by category
  Future<List<QuestionnaireQuestion>> getQuestionsByCategory(QuestionnaireCategory category) async {
    final response = await SupabaseService.from(_questionsTable)
        .select()
        .eq('category', category.toString().split('.').last)
        .order('id');

    return response.map<QuestionnaireQuestion>((json) => QuestionnaireQuestion.fromJson(json)).toList();
  }

  /// Get question by ID
  Future<QuestionnaireQuestion?> getQuestionById(String questionId) async {
    final response = await SupabaseService.from(_questionsTable)
        .select()
        .eq('id', questionId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return QuestionnaireQuestion.fromJson(response);
  }

  /// Get user answers
  Future<List<QuestionnaireAnswer>> getUserAnswers(String userId) async {
    final response = await SupabaseService.from(_answersTable)
        .select()
        .eq('user_id', userId)
        .order('question_id');

    return response.map<QuestionnaireAnswer>((json) => QuestionnaireAnswer.fromJson(json)).toList();
  }

  /// Get user answer for question
  Future<QuestionnaireAnswer?> getUserAnswerForQuestion(String userId, String questionId) async {
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
    await SupabaseService.from(_answersTable)
        .delete()
        .eq('user_id', userId)
        .eq('question_id', questionId);
  }

  /// Delete all user answers
  Future<void> deleteAllUserAnswers(String userId) async {
    await SupabaseService.from(_answersTable)
        .delete()
        .eq('user_id', userId);
  }

  /// Get questionnaire result
  Future<QuestionnaireResult?> getQuestionnaireResult(String user1Id, String user2Id) async {
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
  Future<QuestionnaireResult> calculateQuestionnaireCompatibility(String user1Id, String user2Id) async {
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
      final score = _calculateAnswerCompatibility(user1Answer.answer, user2Answer.answer);
      
      // Add to category score and total
      categoryScores[question.category] = (categoryScores[question.category] ?? 0) + (score * question.weight);
      categoryTotals[question.category] = (categoryTotals[question.category] ?? 0) + (5 * question.weight); // 5 is max score
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
    
    overallScore = totalCategories > 0 ? (overallScore / totalCategories).round() : 0;
    
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
  Future<QuestionnaireResult> saveQuestionnaireResult(QuestionnaireResult result) async {
    // Check if result already exists
    final existingResult = await getQuestionnaireResult(result.user1Id, result.user2Id);
    
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
  int _calculateAnswerCompatibility(AnswerOption answer1, AnswerOption answer2) {
    // Convert enum to numeric value (0-4)
    final value1 = answer1.index;
    final value2 = answer2.index;
    
    // Calculate absolute difference (0-4)
    final difference = (value1 - value2).abs();
    
    // Convert to compatibility score (5 is max compatibility, 1 is min)
    return 5 - difference;
  }
}
