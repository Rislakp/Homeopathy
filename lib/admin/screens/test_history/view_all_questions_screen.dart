import 'package:flutter/material.dart';
import 'package:homeopathy/models/exam_detail_model.dart';
import 'package:homeopathy/services/exam_service.dart';

/// Screen to display full details and MCQs for a specific Grand Mock exam.
class ViewAllQuestionsScreen extends StatefulWidget {
  final String examId;

  const ViewAllQuestionsScreen({
    super.key,
    required this.examId,
  });

  @override
  State<ViewAllQuestionsScreen> createState() => _ViewAllQuestionsScreenState();
}

class _ViewAllQuestionsScreenState extends State<ViewAllQuestionsScreen> {
  final ExamService _examService = ExamService();
  late Future<ExamDetailModel> _examDetailsFuture;

  @override
  void initState() {
    super.initState();
    _loadExamDetails();
  }

  /// Initiates or refreshes the API call to fetch exam details.
  void _loadExamDetails() {
    setState(() {
      _examDetailsFuture = _examService.getExamDetailsById(widget.examId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Exam Questions',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: colorScheme.primary,
            ),
            tooltip: 'Refresh',
            onPressed: _loadExamDetails,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<ExamDetailModel>(
        future: _examDetailsFuture,
        builder: (context, snapshot) {
          // -------------------------------------------------------------
          // 1. Loading State
          // -------------------------------------------------------------
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            );
          }

          // -------------------------------------------------------------
          // 2. Error State
          // -------------------------------------------------------------
          if (snapshot.hasError) {
            final String errorMessage = snapshot.error
                    ?.toString()
                    .replaceAll('Exception: ', '') ??
                'An unexpected error occurred while fetching exam details.';

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 56,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to Load Exam Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _loadExamDetails,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Retry'),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final exam = snapshot.data;
          if (exam == null) {
            return Center(
              child: Text(
                'No exam details available.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          // -------------------------------------------------------------
          // 3. Success State: Header & Questions List
          // -------------------------------------------------------------
          return RefreshIndicator(
            onRefresh: () async => _loadExamDetails(),
            color: colorScheme.primary,
            backgroundColor: colorScheme.surface,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Header Container with Exam Metadata
                _buildHeader(context, exam),
                const SizedBox(height: 24),

                // Questions Section Header
                Row(
                  children: [
                    Text(
                      'Questions (${exam.questions.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Questions List or Empty Questions State
                if (exam.questions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.help_outline_rounded,
                            size: 48,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No questions found in this exam.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exam.questions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final question = exam.questions[index];
                      return _buildQuestionCard(
                        context,
                        question: question,
                        questionIndex: index + 1,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the summary header card showing title, duration, marks, and questions count.
  Widget _buildHeader(BuildContext context, ExamDetailModel exam) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double totalMarks = exam.marksPerQuestion *
        (exam.totalQuestions > 0 ? exam.totalQuestions : exam.questions.length);

    final String marksString = totalMarks % 1 == 0
        ? totalMarks.toInt().toString()
        : totalMarks.toStringAsFixed(1);

    final String marksPerQuestionString = exam.marksPerQuestion % 1 == 0
        ? exam.marksPerQuestion.toInt().toString()
        : exam.marksPerQuestion.toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exam Title
          Text(
            exam.title.isNotEmpty ? exam.title : 'Grand Mock Exam',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),

          // Metadata Chips Row
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // Total Questions Chip
              _buildMetaBadge(
                context,
                icon: Icons.quiz_outlined,
                label: 'Questions: ${exam.totalQuestions > 0 ? exam.totalQuestions : exam.questions.length}',
                backgroundColor: colorScheme.primaryContainer,
                textColor: colorScheme.onPrimaryContainer,
              ),

              // Duration Chip
              if (exam.durationMinutes > 0)
                _buildMetaBadge(
                  context,
                  icon: Icons.timer_outlined,
                  label: 'Duration: ${exam.durationMinutes}m',
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  textColor: colorScheme.onSurfaceVariant,
                ),

              // Marks per Question Chip
              if (exam.marksPerQuestion > 0)
                _buildMetaBadge(
                  context,
                  icon: Icons.score_outlined,
                  label: '$marksPerQuestionString marks/Q',
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  textColor: colorScheme.onSurfaceVariant,
                ),

              // Total Marks Chip
              if (totalMarks > 0)
                _buildMetaBadge(
                  context,
                  icon: Icons.emoji_events_outlined,
                  label: 'Total Marks: $marksString',
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  textColor: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a pill-shaped badge for summary metrics.
  Widget _buildMetaBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the question card with its question text and formatted list of 4 options.
  Widget _buildQuestionCard(
    BuildContext context, {
    required QuestionModel question,
    required int questionIndex,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Standard options list to guarantee order A, B, C, D
    const optionKeys = ['A', 'B', 'C', 'D'];

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Number Badge & Question Text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Q$questionIndex',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Vertical list of Options (A, B, C, D)
            ...optionKeys.map((key) {
              final optionText = question.options[key] ?? '';
              final bool isCorrect =
                  key.toUpperCase() == question.correctOption.toUpperCase();

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildOptionTile(
                  context,
                  optionKey: key,
                  optionText: optionText,
                  isCorrect: isCorrect,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Builds an individual option item with visual highlight for the correct answer.
  Widget _buildOptionTile(
    BuildContext context, {
    required String optionKey,
    required String optionText,
    required bool isCorrect,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color backgroundColor = isCorrect
        ? colorScheme.primaryContainer
        : colorScheme.surface;

    final Color borderColor = isCorrect
        ? colorScheme.primary
        : colorScheme.outlineVariant;

    final Color textColor = isCorrect
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;

    final Color badgeBg = isCorrect
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    final Color badgeText = isCorrect
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isCorrect ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Option Key Circle (e.g. A, B, C, D)
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeBg,
              shape: BoxShape.circle,
            ),
            child: Text(
              optionKey,
              style: theme.textTheme.labelMedium?.copyWith(
                color: badgeText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Option Text
          Expanded(
            child: Text(
              optionText.isNotEmpty ? optionText : '—',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),

          // Correct Answer Checkmark Indicator
          if (isCorrect) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.check_circle_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }
}
