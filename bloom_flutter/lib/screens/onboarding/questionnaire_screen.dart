import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';
import '../../models/compatibility_questionnaire.dart' as compatibility;
import '../../providers/questionnaire_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_indicator.dart';

/// Questionnaire screen
class QuestionnaireScreen extends StatefulWidget {
  /// Creates a new [QuestionnaireScreen] instance
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int _currentQuestionIndex = 0;
  final List<int> _answers = [];
  bool _isLoading = false;
  List<compatibility.QuestionnaireQuestion>? _questions;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final questionnaireProvider = Provider.of<QuestionnaireProvider>(
        context, 
        listen: false,
      );
      
      final questions = await questionnaireProvider.getCompatibilityQuestions();
      
      setState(() {
        _questions = questions;
        _answers.clear();
        _answers.addAll(List.filled(questions.length, -1));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading questions: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _answers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < (_questions?.length ?? 0) - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitQuestionnaire();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _submitQuestionnaire() async {
    if (_questions == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final questionnaireProvider = Provider.of<QuestionnaireProvider>(
        context, 
        listen: false,
      );
      
      // Create a map of question IDs to answer indices
      final Map<String, int> questionAnswers = {};
      for (int i = 0; i < _questions!.length; i++) {
        questionAnswers[_questions![i].id] = _answers[i];
      }
      
      await questionnaireProvider.submitCompatibilityQuestionnaire(
        questionAnswers,
      );
      
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to home screen
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting questionnaire: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: LoadingIndicator(),
        ),
      );
    }

    if (_questions == null || _questions!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Compatibility Questionnaire'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No questions available'),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Retry',
                onPressed: _loadQuestions,
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = _questions![_currentQuestionIndex];
    final currentAnswer = _answers[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == _questions!.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compatibility Questionnaire'),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions!.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          
          // Question counter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions!.length}',
              style: TextStyles.subtitle2,
            ),
          ),
          
          // Question
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentQuestion.text,
                    style: TextStyles.headline3,
                  ),
                  const SizedBox(height: 32),
                  
                  // Answers
                  ...List.generate(
                    5, // 5 standard options from AnswerOption enum
                    (index) => _buildAnswerOption(
                      _getAnswerOptionText(index),
                      index,
                      currentAnswer == index,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                if (_currentQuestionIndex > 0)
                  CustomButton(
                    text: 'Back',
                    type: ButtonType.outline,
                    onPressed: _previousQuestion,
                  )
                else
                  const SizedBox(width: 80),
                
                // Next/Submit button
                CustomButton(
                  text: isLastQuestion ? 'Submit' : 'Next',
                  onPressed: currentAnswer != -1 ? _nextQuestion : null,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAnswerOptionText(int index) {
    switch (index) {
      case 0:
        return 'Strongly Disagree';
      case 1:
        return 'Disagree';
      case 2:
        return 'Neutral';
      case 3:
        return 'Agree';
      case 4:
        return 'Strongly Agree';
      default:
        return '';
    }
  }

  Widget _buildAnswerOption(String option, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[400]!,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option,
                style: TextStyles.body1.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
