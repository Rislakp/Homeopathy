import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/student_model.dart';
import 'student_row.dart';

/// Modal dialog that displays a student's attended exam performance and scores.
class ViewStudentScoresDialog extends StatelessWidget {
  final StudentModel student;

  const ViewStudentScoresDialog({
    super.key,
    required this.student,
  });

  /// Helper to show this dialog with appropriate responsive sizing
  static Future<void> show(BuildContext context, StudentModel student) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ViewStudentScoresDialog(student: student),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = StudentRow.getAvatarBgColor(student.name);
    final exams = student.attendedExams;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 10,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: avatarColor.withOpacity(0.12),
                  child: Text(
                    student.avatarText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: avatarColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${student.name} - Exam Scores',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF111827),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        student.course.isNotEmpty
                            ? student.course
                            : student.email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF9CA3AF), size: 22),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close',
                  splashRadius: 20,
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 16),

            // Performance Summary Bar (if exams exist or stats available)
            if (exams.isNotEmpty || student.stats.totalExamsAttended > 0)
              _buildStatsSummaryBar(isSmallScreen),

            if (exams.isNotEmpty || student.stats.totalExamsAttended > 0)
              const SizedBox(height: 16),

            // Body: Exam List or Empty State
            Flexible(
              child: exams.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: exams.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final exam = exams[index];
                        return _buildExamCard(exam, isSmallScreen);
                      },
                    ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 16),

            // Footer / Close Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 10, 5, 100),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Summary banner showing totals & averages
  Widget _buildStatsSummaryBar(bool isSmallScreen) {
    final totalExams = student.attendedExams.isNotEmpty
        ? student.attendedExams.length
        : student.stats.totalExamsAttended;
    
    final passedCount = student.attendedExams.isNotEmpty
        ? student.attendedExams.where((e) => e.status.toLowerCase() == 'passed').length
        : student.stats.passedExams;

    final avgPercentage = student.attendedExams.isNotEmpty
        ? (student.attendedExams.map((e) => e.percentage).reduce((a, b) => a + b) / totalExams)
        : student.stats.averageScore;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Exams', '$totalExams', const Color(0xFF3B82F6)),
          Container(width: 1, height: 28, color: const Color(0xFFE5E7EB)),
          _buildStatItem('Passed', '$passedCount', const Color(0xFF10B981)),
          Container(width: 1, height: 28, color: const Color(0xFFE5E7EB)),
          _buildStatItem(
            'Avg Score',
            '${avgPercentage.toStringAsFixed(0)}%',
            avgPercentage >= 50 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  /// Individual Exam performance card
  Widget _buildExamCard(ExamScore exam, bool isSmallScreen) {
    final isPassed = exam.status.toLowerCase() == 'passed';
    final statusColor = isPassed ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final statusBgColor = isPassed ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2);
    final pctProgress = (exam.percentage / 100).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title + Status Chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    if (exam.submittedAt != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 12, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy • hh:mm a').format(exam.submittedAt!.toLocal()),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      exam.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Score and Percentage Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Score: ',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: exam.score % 1 == 0 ? '${exam.score.toInt()}' : '${exam.score}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    TextSpan(
                      text: ' / ${exam.totalMarks % 1 == 0 ? exam.totalMarks.toInt() : exam.totalMarks}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${exam.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isPassed ? const Color(0xFF047857) : const Color(0xFFB91C1C),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Visual Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pctProgress,
              minHeight: 6,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),

          // Detailed counters if available
          if (exam.totalAttempted > 0 || exam.totalCorrect > 0 || exam.totalWrong > 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (exam.totalAttempted > 0)
                  _buildSubMetric('Attempted', '${exam.totalAttempted}', const Color(0xFF4B5563)),
                if (exam.totalCorrect > 0) ...[
                  const SizedBox(width: 12),
                  _buildSubMetric('Correct', '${exam.totalCorrect}', const Color(0xFF10B981)),
                ],
                if (exam.totalWrong > 0) ...[
                  const SizedBox(width: 12),
                  _buildSubMetric('Wrong', '${exam.totalWrong}', const Color(0xFFEF4444)),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubMetric(String label, String value, Color color) {
    return Text(
      '$label: $value',
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  /// Empty state when student has not attended any exams yet
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_late_outlined,
              size: 36,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No exams attended yet.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'This student has not submitted any exam or test attempts.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
