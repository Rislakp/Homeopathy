import 'package:flutter/material.dart';
import 'package:homeopathy/models/student_exam_model.dart';

/// Reusable Exam Card widget for the Student Portal Grand Mock Test screen.
class StudentExamCard extends StatelessWidget {
  final StudentExamModel exam;
  final VoidCallback? onActionPressed;

  const StudentExamCard({
    super.key,
    required this.exam,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isAttempted = exam.isAttempted;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // -----------------------------------------------------------
            // 1. Header Row: Title & Difficulty/Pattern Badge
            // -----------------------------------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    exam.title.isNotEmpty ? exam.title : 'Grand Mock Test',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildPatternBadge(context),
              ],
            ),
            const SizedBox(height: 4),

            // -----------------------------------------------------------
            // 2. Subtitle: Medical Entrance Pattern
            // -----------------------------------------------------------
            Text(
              'Medical Entrance Pattern',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // -----------------------------------------------------------
            // 3. Stats Row: Questions, Marks, Duration
            // -----------------------------------------------------------
            _buildStatsRow(context),
            const SizedBox(height: 16),

            // -----------------------------------------------------------
            // 4. Previous Score Container (Conditional: Attempted & score exists)
            // -----------------------------------------------------------
            if (isAttempted && exam.previousScore != null) ...[
              _buildPreviousScoreContainer(context),
              const SizedBox(height: 16),
            ],

            const Divider(height: 1),
            const SizedBox(height: 14),

            // -----------------------------------------------------------
            // 5. Action Row: Status Badge & Primary Action Button
            // -----------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStatusBadge(context, isAttempted),
                _buildActionButton(context, isAttempted),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a small header badge.
  Widget _buildPatternBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        'Grand Mock',
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }

  /// Builds the stats row with 3 muted icons and labels.
  Widget _buildStatsRow(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mutedColor = colorScheme.onSurfaceVariant;

    return Wrap(
      spacing: 14,
      runSpacing: 8,
      children: [
        _buildStatItem(
          icon: Icons.description_outlined,
          label: '${exam.totalQuestions} Questions',
          color: mutedColor,
          theme: theme,
        ),
        _buildStatItem(
          icon: Icons.workspace_premium_outlined,
          label: '${exam.totalMarks} Marks',
          color: mutedColor,
          theme: theme,
        ),
        _buildStatItem(
          icon: Icons.access_time_rounded,
          label: '${exam.durationMinutes} Minutes',
          color: mutedColor,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Color color,
    required ThemeData theme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Builds the full-width previous score banner showing score / totalMarks.
  Widget _buildPreviousScoreContainer(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Previous Score',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            '${exam.previousScore} / ${exam.totalMarks}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the status badge (Attempted vs Not Started).
  Widget _buildStatusBadge(BuildContext context, bool isAttempted) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String label = isAttempted ? 'Attempted' : 'Not Started';

    final Color bgColor = isAttempted
        ? colorScheme.primaryContainer.withValues(alpha: 0.5)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    final Color textColor = isAttempted
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    final Color borderColor = isAttempted
        ? colorScheme.primary.withValues(alpha: 0.25)
        : colorScheme.outlineVariant;

    final IconData icon = isAttempted
        ? Icons.check_circle_outline_rounded
        : Icons.radio_button_unchecked_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the primary action button ("Retake / Continue >" or "Start Test >").
  Widget _buildActionButton(BuildContext context, bool isAttempted) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String buttonText =
        isAttempted ? 'Retake / Continue >' : 'Start Test >';

    return ElevatedButton(
      onPressed: onActionPressed ??
          () {
            debugPrint('Exam selected: ${exam.id} (${exam.title})');
          },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        textStyle: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Text(buttonText),
    );
  }
}
