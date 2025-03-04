import 'package:flutter/foundation.dart';

import '../models/compatibility_questionnaire.dart';
import '../providers/auth_provider.dart';
import '../services/service_registry.dart';

/// Questionnaire provider
class QuestionnaireProvider extends ChangeNotifier {
  /// Auth provider
  final AuthProvider _authProvider;

  /// Questions
  List<QuestionnaireQuestion> _questions = [];

  /// User answers
  List<QuestionnaireAnswer> _userAnswers = [];

  /// Is loading
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Creates a new [QuestionnaireProvider] instance
  QuestionnaireProvider({
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
      await _loadQuestions();
      await _loadUserAnswers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load questions
  Future<void> _loadQuestions() async {
    _questions = await ServiceRegistry.questionnaireService.getAllQuestions();
  }

  /// Load user answers
  Future<void> _loadUserAnswers() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    final userId = _authProvider.currentUser!.id;
    _userAnswers =
        await ServiceRegistry.questionnaireService.getUserAnswers(userId);
  }

  /// Update auth provider
  void updateAuthProvider({required AuthProvider authProvider}) {
    if (_authProvider.currentUser?.id != authProvider.currentUser?.id) {
      _init();
    }
  }

  /// Get questions
  List<QuestionnaireQuestion> get questions => _questions;

  /// Get user answers
  List<QuestionnaireAnswer> get userAnswers => _userAnswers;

  /// Is loading
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Get questions by category
  List<QuestionnaireQuestion> getQuestionsByCategory(
      QuestionnaireCategory category) {
    return _questions.where((q) => q.category == category).toList();
  }

  /// Get user answer for question
  QuestionnaireAnswer? getUserAnswerForQuestion(String questionId) {
    try {
      return _userAnswers.firstWhere(
        (a) => a.questionId == questionId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get completion percentage
  double getCompletionPercentage() {
    if (_questions.isEmpty) {
      return 0.0;
    }

    return _userAnswers.length / _questions.length;
  }

  /// Get completion percentage by category
  double getCompletionPercentageByCategory(QuestionnaireCategory category) {
    final categoryQuestions = getQuestionsByCategory(category);
    if (categoryQuestions.isEmpty) {
      return 0.0;
    }

    final categoryAnswers = _userAnswers
        .where((a) => categoryQuestions.any((q) => q.id == a.questionId))
        .toList();

    return categoryAnswers.length / categoryQuestions.length;
  }

  /// Save answer
  Future<void> saveAnswer({
    required String questionId,
    required AnswerOption answer,
  }) async {
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;

      final savedAnswer =
          await ServiceRegistry.questionnaireService.saveUserAnswer(
        userId: userId,
        questionId: questionId,
        answer: answer,
      );

      // Update or add answer in list
      final index = _userAnswers.indexWhere((a) => a.questionId == questionId);
      if (index != -1) {
        _userAnswers[index] = savedAnswer;
      } else {
        _userAnswers.add(savedAnswer);
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete answer
  Future<void> deleteAnswer(String questionId) async {
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;

      await ServiceRegistry.questionnaireService
          .deleteUserAnswer(userId, questionId);

      // Remove answer from list
      _userAnswers.removeWhere((a) => a.questionId == questionId);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete all answers
  Future<void> deleteAllAnswers() async {
    if (_authProvider.currentUser == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;

      await ServiceRegistry.questionnaireService.deleteAllUserAnswers(userId);

      // Clear answers list
      _userAnswers.clear();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Calculate compatibility with user
  Future<QuestionnaireResult> calculateCompatibilityWithUser(
      String otherUserId) async {
    if (_authProvider.currentUser == null) {
      throw Exception('User not authenticated');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;

      final result = await ServiceRegistry.questionnaireService
          .calculateQuestionnaireCompatibility(
        userId,
        otherUserId,
      );

      _errorMessage = null;
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get compatibility result with user
  Future<QuestionnaireResult?> getCompatibilityResultWithUser(
      String otherUserId) async {
    if (_authProvider.currentUser == null) {
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _authProvider.currentUser!.id;

      final result =
          await ServiceRegistry.questionnaireService.getQuestionnaireResult(
        userId,
        otherUserId,
      );

      _errorMessage = null;
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh questions
  Future<void> refreshQuestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadQuestions();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh user answers
  Future<void> refreshUserAnswers() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadUserAnswers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get compatibility questions
  Future<List<QuestionnaireQuestion>> getCompatibilityQuestions() async {
    if (_questions.isEmpty) {
      await refreshQuestions();
    }
    return _questions;
  }

  /// Submit compatibility questionnaire
  Future<void> submitCompatibilityQuestionnaire(
      Map<String, int> questionAnswers) async {
    if (_authProvider.currentUser == null) {
      throw Exception('User not authenticated');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Convert answer indices to AnswerOption enum values
      for (final entry in questionAnswers.entries) {
        final questionId = entry.key;
        final answerIndex = entry.value;

        // Convert index to AnswerOption
        final answerOption = AnswerOption.values[answerIndex];

        // Save the answer
        await saveAnswer(
          questionId: questionId,
          answer: answerOption,
        );
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
