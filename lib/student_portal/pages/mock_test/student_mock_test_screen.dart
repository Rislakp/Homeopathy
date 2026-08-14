import 'package:flutter/material.dart';
import 'package:homeopathy/models/active_exam_model.dart';
import 'package:homeopathy/models/student_exam_model.dart';
import 'package:homeopathy/services/student_exam_service.dart';
import 'package:homeopathy/student_portal/pages/mock_test/active_exam_screen.dart';
import 'package:homeopathy/student_portal/widgets/dashboard/appbar.dart';
import 'package:homeopathy/student_portal/widgets/mock_test/student_exam_card.dart';

/// Screen displaying all available Grand Mock exams for students.
class StudentMockTestScreen extends StatefulWidget {
  const StudentMockTestScreen({super.key});

  @override
  State<StudentMockTestScreen> createState() => _StudentMockTestScreenState();
}

class _StudentMockTestScreenState extends State<StudentMockTestScreen> {
  final StudentExamService _examService = StudentExamService();
  late Future<List<StudentExamModel>> _examsFuture;

  @override
  void initState() {
    super.initState();
    _fetchExams();
  }

  /// Initiates or refreshes the API call to fetch available mock tests.
  void _fetchExams() {
    setState(() {
      _examsFuture = _examService.getAvailableExams();
    });
  }

  /// Handles starting an active exam session by fetching questions and navigating.
  Future<void> _handleStartExam(StudentExamModel exam) async {
    // Show a modal loading indicator while fetching questions
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final ActiveExamModel activeExam =
          await _examService.startExam(exam.id);

      if (!mounted) return;

      // Close loading dialog
      Navigator.of(context).pop();

      // Navigate to ActiveExamScreen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ActiveExamScreen(activeExam: activeExam),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // Close loading dialog
      Navigator.of(context).pop();

      final String errorMessage =
          e.toString().replaceAll('Exception: ', '').trim();

      // Display SnackBar with Theme error background
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double screenWidth = MediaQuery.of(context).size.width;

    final bool isMobile = screenWidth < 640;
    final bool isTablet = screenWidth >= 640 && screenWidth < 1024;
    final double horizontalPadding = isMobile ? 16.0 : (isTablet ? 24.0 : 40.0);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isMobile ? 24.0 : 36.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------------------------------------------------
                  // 1. PAGE HEADER (Title, Subtitle & Section Header Row)
                  // ---------------------------------------------------------
                  _buildPageHeader(context),
                  const SizedBox(height: 28),

                  // ---------------------------------------------------------
                  // 2. FUTURE BUILDER (Loading, Error, Empty, Data States)
                  // ---------------------------------------------------------
                  FutureBuilder<List<StudentExamModel>>(
                    future: _examsFuture,
                    builder: (context, snapshot) {
                      // Loading State
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 80),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          ),
                        );
                      }

                      // Error State
                      if (snapshot.hasError) {
                        final String errorMessage = snapshot.error
                                ?.toString()
                                .replaceAll('Exception: ', '') ??
                            'Failed to load mock tests. Please try again.';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  size: 52,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Unable to Load Exams',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    errorMessage,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                FilledButton.icon(
                                  onPressed: _fetchExams,
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

                      final List<StudentExamModel> exams = snapshot.data ?? [];

                      // Empty State
                      if (exams.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.quiz_outlined,
                                  size: 52,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No mock tests available at the moment.',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Please check back later for new test announcements.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                IconButton.filledTonal(
                                  onPressed: _fetchExams,
                                  icon: const Icon(Icons.refresh_rounded),
                                  tooltip: 'Refresh',
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

                      // Data State: Responsive Grid
                      return _buildResponsiveGrid(context, exams);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the page header with Title, Subtitle, and Section Header Row.
  Widget _buildPageHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title: "Grand Mock Test"
        Text(
          'Grand Mock Test',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Full-length, timed simulations of the medical entrance exam — attempt, review and track your progress.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // Section Header Row: "AVAILABLE TESTS" & "Result History"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'AVAILABLE TESTS',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.refresh_rounded, size: 20, color: colorScheme.primary),
                  tooltip: 'Refresh Tests',
                  onPressed: _fetchExams,
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: () {
                    debugPrint('Result History clicked');
                  },
                  icon: Icon(
                    Icons.history_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  label: Text(
                    'Result History',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
      ],
    );
  }

  /// Builds a responsive grid of StudentExamCard widgets.
  Widget _buildResponsiveGrid(
    BuildContext context,
    List<StudentExamModel> exams,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 640) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 980) {
          crossAxisCount = 2;
        }

        const double spacing = 20.0;
        final double totalSpacing = spacing * (crossAxisCount - 1);
        final double itemWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: exams.map((exam) {
            return SizedBox(
              width: itemWidth,
              child: StudentExamCard(
                exam: exam,
                onActionPressed: () => _handleStartExam(exam),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
