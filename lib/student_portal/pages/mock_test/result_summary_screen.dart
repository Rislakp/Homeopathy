import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/models/test_result_model.dart';
import 'package:homeopathy/student_portal/models/student_result_model.dart';
import 'package:homeopathy/student_portal/provider/student_result_provider.dart';

/// Screen displaying the dynamically fetched exam result summary for the authenticated student.
class ResultSummaryScreen extends StatefulWidget {
  final String? examId;
  final String? resultId;
  final TestResultModel? result;
  final int? totalExamMarks;

  const ResultSummaryScreen({
    super.key,
    this.examId,
    this.resultId,
    this.result,
    this.totalExamMarks,
  });

  @override
  State<ResultSummaryScreen> createState() => _ResultSummaryScreenState();
}

class _ResultSummaryScreenState extends State<ResultSummaryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch live student results from GET /api/student/results upon opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StudentResultProvider>().fetchStudentResults();
      }
    });
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final local = dt.toLocal();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[local.month - 1];
    final day = local.day;
    final year = local.year;
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final ampm = local.hour >= 12 ? 'PM' : 'AM';
    return '$day $month $year, $hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      appBar: AppBar(
        title: const Text(
          'Exam Result Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Prevent physical back button
      ),
      body: Consumer<StudentResultProvider>(
        builder: (context, provider, child) {
          // ------------------------------------------------------------------
          // 1. LOADING STATE
          // ------------------------------------------------------------------
          if (provider.isLoading && provider.results.isEmpty && widget.result == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ------------------------------------------------------------------
          // 2. ERROR STATE
          // ------------------------------------------------------------------
          if (provider.errorMessage != null &&
              provider.results.isEmpty &&
              widget.result == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        provider.fetchStudentResults();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Back to Dashboard'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ------------------------------------------------------------------
          // 3. RESOLVE MATCHING RESULT DATA
          // ------------------------------------------------------------------
          StudentResult? activeResult;
          if (provider.results.isNotEmpty) {
            final targetId = widget.examId ?? widget.resultId ?? widget.result?.examId;
            activeResult = provider.getResultByExamId(targetId);
          }

          // Fallback to widget.result if API results list is empty
          if (activeResult == null && widget.result != null) {
            final fallback = widget.result!;
            activeResult = StudentResult(
              id: fallback.resultId ?? '',
              studentId: '',
              exam: ExamResultInfo(
                id: fallback.examId ?? '',
                title: fallback.examTitle ?? 'Grand Mock Test Result',
                marksPerQuestion: 0,
                durationMinutes: 0,
                totalQuestions: fallback.totalAttempted,
              ),
              score: fallback.score.toInt(),
              totalMarks: widget.totalExamMarks ?? fallback.totalMarks,
              totalAttempted: fallback.totalAttempted,
              totalCorrect: fallback.totalCorrect,
              totalWrong: fallback.totalWrong,
              status: fallback.status,
              answers: const [],
              createdAt: DateTime.now(),
            );
          }

          // ------------------------------------------------------------------
          // 4. EMPTY RESULT STATE
          // ------------------------------------------------------------------
          if (activeResult == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No exam results found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Back to Dashboard'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ------------------------------------------------------------------
          // 5. SUCCESS STATE WITH DYNAMIC DATA
          // ------------------------------------------------------------------
          final String examTitle = activeResult.exam.title.isNotEmpty
              ? activeResult.exam.title
              : 'Grand Mock Test Result';

          final int totalMarks = activeResult.totalMarks > 0
              ? activeResult.totalMarks
              : (widget.totalExamMarks ?? 0);

          // --- Negative Marking Calculation ---
          final int correctAnswers = activeResult.totalCorrect;
          final int wrongAnswers = activeResult.totalWrong;
          // Use exam's marksPerQuestion if available, else fall back to 1
          final int marksPerQuestion =
              activeResult.exam.marksPerQuestion > 0
                  ? activeResult.exam.marksPerQuestion
                  : 1;
          const int negativePenaltyPerWrongAnswer = 1;

          final int earnedMarks = correctAnswers * marksPerQuestion;
          final int totalNegativeMarks =
              wrongAnswers * negativePenaltyPerWrongAnswer;
          int finalScore = earnedMarks - totalNegativeMarks;
          if (finalScore < 0) finalScore = 0;
          // --- End Negative Marking Calculation ---

          final double percentage = totalMarks > 0
              ? ((finalScore / totalMarks) * 100).clamp(0.0, 100.0)
              : 0.0;

          final bool isCompleted =
              activeResult.status.toLowerCase() == 'completed' ||
              activeResult.status.toLowerCase() == 'submitted';

          final String dateStr = _formatDate(activeResult.createdAt);

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: percentage >= 50
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        percentage >= 50
                            ? Icons.check_circle_outline_rounded
                            : Icons.info_outline_rounded,
                        color: percentage >= 50
                            ? Colors.green.shade600
                            : Colors.red.shade400,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dynamic Exam Title
                    Text(
                      examTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Dynamic Status
                    Text(
                      activeResult.status,
                      style: TextStyle(
                        color: isCompleted ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    if (dateStr.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        dateStr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // Dynamic Main Score Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$finalScore / $totalMarks',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total Score (${percentage.toStringAsFixed(1)}%)',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (totalNegativeMarks > 0) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Penalty: -$totalNegativeMarks marks applied',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dynamic Stats Row (Attempted, Correct, Wrong, Penalty)
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatBox(
                            context: context,
                            icon: Icons.playlist_add_check_rounded,
                            label: 'Attempted',
                            value: activeResult.totalAttempted.toString(),
                            bgColor: Colors.blue.shade50,
                            iconColor: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatBox(
                            context: context,
                            icon: Icons.check_circle_outline_rounded,
                            label: 'Correct',
                            value: activeResult.totalCorrect.toString(),
                            bgColor: Colors.green.shade50,
                            iconColor: Colors.green.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatBox(
                            context: context,
                            icon: Icons.highlight_off_rounded,
                            label: 'Wrong',
                            value: activeResult.totalWrong.toString(),
                            bgColor: Colors.red.shade50,
                            iconColor: Colors.red.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatBox(
                            context: context,
                            icon: Icons.remove_circle_outline_rounded,
                            label: 'Penalty',
                            value: '-$totalNegativeMarks',
                            bgColor: Colors.orange.shade50,
                            iconColor: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),

                    // Dynamic Question Breakdown (if available)
                    if (activeResult.answers.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Question Breakdown',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activeResult.answers.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, color: colorScheme.outlineVariant),
                          itemBuilder: (context, idx) {
                            final ans = activeResult!.answers[idx];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Question ${idx + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Selected: ${ans.selectedOption}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ans.isCorrect
                                              ? Colors.green.shade50
                                              : Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          ans.isCorrect ? 'Correct' : 'Wrong',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: ans.isCorrect
                                                ? Colors.green.shade700
                                                : Colors.red.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Back to Dashboard Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () {
                          // Pop all routes until the main dashboard is reached
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        icon: const Icon(Icons.home_rounded, size: 20),
                        label: const Text('Back to Dashboard'),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Helper method to build the 3 statistic boxes
  Widget _buildStatBox({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: iconColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: iconColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}