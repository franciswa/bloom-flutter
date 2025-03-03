import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/compatibility_questionnaire.dart';
import '../../providers/questionnaire_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

/// Questionnaire answers widget
class QuestionnaireAnswersWidget extends StatefulWidget {
  /// On edit callback
  final VoidCallback? onEdit;

  /// Creates a new [QuestionnaireAnswersWidget] instance
  const QuestionnaireAnswersWidget({
    super.key,
    this.onEdit,
  });

  @override
  State<QuestionnaireAnswersWidget> createState() =>
      _QuestionnaireAnswersWidgetState();
}

class _QuestionnaireAnswersWidgetState extends State<QuestionnaireAnswersWidget>
    with SingleTickerProviderStateMixin {
  /// Selected category
  QuestionnaireCategory? _selectedCategory;

  /// Tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: QuestionnaireCategory.values.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedCategory =
              QuestionnaireCategory.values[_tabController.index];
        });
      }
    });

    // Set initial selected category
    _selectedCategory = QuestionnaireCategory.values.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionnaireProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Questionnaire Answers',
                    style: TextStyles.headline5,
                  ),
                  if (widget.onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: widget.onEdit,
                    ),
                ],
              ),
            ),

            // Category tabs
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: QuestionnaireCategory.values.map((category) {
                final categoryQuestions =
                    provider.getQuestionsByCategory(category);
                final categoryAnswers = provider.userAnswers
                    .where((a) =>
                        categoryQuestions.any((q) => q.id == a.questionId))
                    .toList();

                final completionPercentage = categoryQuestions.isEmpty
                    ? 0.0
                    : categoryAnswers.length / categoryQuestions.length;

                return Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getCategoryName(category),
                        style: TextStyle(
                          color: _selectedCategory == category
                              ? AppColors.primary
                              : Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: completionPercentage,
                        backgroundColor: Colors.grey[800],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _selectedCategory == category
                              ? AppColors.primary
                              : Colors.grey[600]!,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            // Questions and answers
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: QuestionnaireCategory.values.map((category) {
                  final categoryQuestions =
                      provider.getQuestionsByCategory(category);

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: categoryQuestions.length,
                    itemBuilder: (context, index) {
                      final question = categoryQuestions[index];
                      final answer =
                          provider.getUserAnswerForQuestion(question.id);

                      return _buildQuestionAnswerItem(question, answer);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build question answer item
  Widget _buildQuestionAnswerItem(
      QuestionnaireQuestion question, QuestionnaireAnswer? answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question
            Text(
              question.text,
              style: TextStyles.subtitle1.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Answer
            if (answer != null)
              _buildAnswerOption(answer.answer)
            else
              Text(
                'Not answered yet',
                style: TextStyles.body2.copyWith(
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build answer option
  Widget _buildAnswerOption(AnswerOption option) {
    final color = _getAnswerColor(option);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.5),
        ),
      ),
      child: Text(
        _getAnswerOptionName(option),
        style: TextStyles.body2.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Get category name
  String _getCategoryName(QuestionnaireCategory category) {
    switch (category) {
      case QuestionnaireCategory.personalValues:
        return 'Personal Values';
      case QuestionnaireCategory.lifestyle:
        return 'Lifestyle';
      case QuestionnaireCategory.communication:
        return 'Communication';
      case QuestionnaireCategory.intimacy:
        return 'Intimacy';
      case QuestionnaireCategory.futureGoals:
        return 'Future Goals';
    }
  }

  /// Get answer option name
  String _getAnswerOptionName(AnswerOption option) {
    switch (option) {
      case AnswerOption.stronglyDisagree:
        return 'Strongly Disagree';
      case AnswerOption.disagree:
        return 'Disagree';
      case AnswerOption.neutral:
        return 'Neutral';
      case AnswerOption.agree:
        return 'Agree';
      case AnswerOption.stronglyAgree:
        return 'Strongly Agree';
    }
  }

  /// Get answer color
  Color _getAnswerColor(AnswerOption option) {
    switch (option) {
      case AnswerOption.stronglyDisagree:
        return Colors.red;
      case AnswerOption.disagree:
        return Colors.orange;
      case AnswerOption.neutral:
        return Colors.yellow;
      case AnswerOption.agree:
        return Colors.lightGreen;
      case AnswerOption.stronglyAgree:
        return Colors.green;
    }
  }
}
