import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/test_history/view_all_questions_screen.dart';
import 'package:homeopathy/models/exam_summary_model.dart';
import 'package:homeopathy/services/exam_service.dart';

/// Screen to display the history and list of all created Grand Mock exams.
class TestHistoryScreen extends StatefulWidget {
  const TestHistoryScreen({super.key});

  @override
  State<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends State<TestHistoryScreen> {
  final ExamService _examService = ExamService();
  late Future<List<ExamSummaryModel>> _examsFuture;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  /// Initiates or refreshes the API call to fetch mock exams.
  void _loadExams() {
    setState(() {
      _examsFuture = _examService.getGrandMockExams();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Test History',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colorScheme.primary),
            tooltip: 'Refresh',
            onPressed: _loadExams,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<ExamSummaryModel>>(
        future: _examsFuture,
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
                'An unexpected error occurred while loading tests.';

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
                      'Failed to Load Tests',
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
                    const SizedBox(height: 16),
                    IconButton.filledTonal(
                      onPressed: _loadExams,
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Retry',
                      style: IconButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        backgroundColor: colorScheme.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final List<ExamSummaryModel> exams = snapshot.data ?? [];

          // -------------------------------------------------------------
          // 3. Empty State
          // -------------------------------------------------------------
          if (exams.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 56,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tests found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'There are no Grand Mock exams created yet.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    IconButton.filledTonal(
                      onPressed: _loadExams,
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Retry',
                      style: IconButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        backgroundColor: colorScheme.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // -------------------------------------------------------------
          // 4. Success State: List of Exam Cards
          // -------------------------------------------------------------
          return RefreshIndicator(
            onRefresh: () async => _loadExams(),
            color: colorScheme.primary,
            backgroundColor: colorScheme.surface,
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: exams.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final exam = exams[index];
                return _buildExamCard(context, exam);
              },
            ),
          );
        },
      ),
    );
  }

  /// Builds a sleek modern Card for an individual exam summary item.
  Widget _buildExamCard(BuildContext context, ExamSummaryModel exam) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            // Top Row: Exam Title and Action Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    exam.title.isNotEmpty ? exam.title : 'Untitled Exam',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // Prints the exam _id to the console
                    debugPrint('Selected Exam ID: ${exam.id}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewAllQuestionsScreen(examId: exam.id),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.visibility_outlined,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  label: Text(
                    'View',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Bottom Row: Total Questions Rounded Chip & Metadata
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Rounded container / chip showing Total Questions
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 15,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Total Questions: ${exam.totalQuestions}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Additional details: Duration Chip
                if (exam.durationMinutes > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${exam.durationMinutes} mins',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Additional details: Marks per Question Chip
                if (exam.marksPerQuestion > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.grade_outlined,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${exam.marksPerQuestion} marks/Q',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
