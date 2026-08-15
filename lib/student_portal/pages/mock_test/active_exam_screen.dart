import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homeopathy/models/active_exam_model.dart';
import 'package:homeopathy/models/test_result_model.dart';
import 'package:homeopathy/services/student_exam_service.dart';
import 'package:homeopathy/student_portal/pages/mock_test/result_summary_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Screen where students attempt an active exam, view questions, track remaining time,
/// navigate questions, and submit responses for evaluation.
class ActiveExamScreen extends StatefulWidget {
  final ActiveExamModel activeExam;

  const ActiveExamScreen({
    super.key,
    required this.activeExam,
  });

  @override
  State<ActiveExamScreen> createState() => _ActiveExamScreenState();
}

class _ActiveExamScreenState extends State<ActiveExamScreen> with WidgetsBindingObserver {
  final StudentExamService _examService = StudentExamService();

  // --------------------------------------------------------------------------
  // State Variables
  // --------------------------------------------------------------------------
  int _currentIndex = 0;
  final Map<int, String> _selectedAnswers = {};
  final Set<int> _skippedQuestions = {};
  final Set<int> _visitedQuestions = {0};

  // Timer is managed by _ExamTimerWidget to avoid full-screen setState every second.
  final GlobalKey<_ExamTimerWidgetState> _timerKey = GlobalKey();
  late int _initialDurationSeconds;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final int durationMin = widget.activeExam.durationMinutes > 0
        ? widget.activeExam.durationMinutes
        : 60;
    // Duration stored once; _ExamTimerWidget manages its own countdown.
    _initialDurationSeconds = durationMin * 60;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _ExamTimerWidget disposes its own Timer in its own dispose().
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // Timer Management
  // --------------------------------------------------------------------------
  // _startTimer() and _formatTime() moved into _ExamTimerWidget below.

  // --------------------------------------------------------------------------
  // Navigation & Selection Logic
  // --------------------------------------------------------------------------
  void _selectOption(int questionIndex, String optionKey) {
    setState(() {
      _selectedAnswers[questionIndex] = optionKey;
      _skippedQuestions.remove(questionIndex);
    });
  }

  void _clearSelection(int questionIndex) {
    setState(() {
      _selectedAnswers.remove(questionIndex);
    });
  }

  void _navigateToQuestion(int targetIndex) {
    if (targetIndex < 0 ||
        targetIndex >= widget.activeExam.questions.length) {
      return;
    }
    setState(() {
      _currentIndex = targetIndex;
      _visitedQuestions.add(targetIndex);
    });
  }

  void _handleNextQuestion() {
    final int totalQuestions = widget.activeExam.questions.length;
    if (totalQuestions == 0) return;

    if (!_selectedAnswers.containsKey(_currentIndex)) {
      _skippedQuestions.add(_currentIndex);
    }

    if (_currentIndex < totalQuestions - 1) {
      _navigateToQuestion(_currentIndex + 1);
    }
  }

  void _handlePreviousQuestion() {
    if (_currentIndex > 0) {
      _navigateToQuestion(_currentIndex - 1);
    }
  }

  // --------------------------------------------------------------------------
  // Exam Submission Handler
  // --------------------------------------------------------------------------
  Future<void> _submitExam({bool autoSubmitted = false}) async {
    if (_isSubmitting) return;

    if (!autoSubmitted) {
      _showSubmissionConfirmationDialog();
      return;
    }

    _confirmAndSubmit(autoSubmitted: autoSubmitted);
  }

  Future<void> _confirmAndSubmit({bool autoSubmitted = false}) async {
    if (!mounted) return;

    // ── 1. Read the student's JWT up-front ────────────────────────────────────
    //    We do this before showing the dialog so that a missing token is caught
    //    immediately rather than leaving the loading spinner open.
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    if (authToken == null || authToken.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Session expired. Please log in again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    _timerKey.currentState?.cancel();

    if (!mounted) return;

    // useRootNavigator: true ensures the dialog is pushed onto — and later
    // popped from — the root navigator, so rootNavigator: true on the pop
    // targets the exact same level regardless of nested navigators.
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  autoSubmitted
                      ? 'Time expired! Submitting exam...'
                      : 'Submitting your responses...',
                ),
              ),
            ],
          ),
        ),
      ),
    );

    TestResultModel? result;
    String? errorMessage;

    try {
      // ── 3. Build submission payload ─────────────────────────────────────────
      final Map<String, String> submissionAnswers = {};
      for (int i = 0; i < widget.activeExam.questions.length; i++) {
        if (_selectedAnswers.containsKey(i)) {
          final q = widget.activeExam.questions[i];
          final String key = q.id.trim().isNotEmpty ? q.id.trim() : '$i';
          submissionAnswers[key] = _selectedAnswers[i]!;
        }
      }

      // ── 4. POST with JWT in Authorization header ────────────────────────────
      //    submitExam() reads the token from SharedPreferences internally, but
      //    passing it here as a named parameter ensures this screen's freshly-
      //    read token is used, so the backend never rejects the request.
      result = await _examService.submitExam(
        widget.activeExam.id,
        submissionAnswers,
        token: authToken,
      );
    } catch (e) {
      result = null;
      errorMessage = e.toString().replaceAll('Exception: ', '').trim();
      debugPrint('_confirmAndSubmit error: $e');
    } finally {
      // ── 5. Pop dialog EXACTLY ONCE via the root navigator ───────────────────
      //    rootNavigator: true mirrors the useRootNavigator: true used in
      //    showDialog, so we always hit the correct navigator level.
      //    This runs before any navigation or setState below.
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _isSubmitting = false;
        });
      }
    }

    // ── 6. Navigate or show error (after dialog is closed) ───────────────────
    if (!mounted) return;

    if (result != null) {
      final int calculatedTotalMarks = (widget.activeExam.marksPerQuestion *
              widget.activeExam.totalQuestions)
          .round();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResultSummaryScreen(
            examId: widget.activeExam.id,
            result: result!,
            totalExamMarks: result.totalMarks > 0
                ? result.totalMarks
                : calculatedTotalMarks,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage ??
                'Submission failed. Please check your connection and try again.',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSubmissionConfirmationDialog() {
    final int answered = _selectedAnswers.length;
    final int total = widget.activeExam.questions.length;
    final int remaining = total - answered;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Submit Exam?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to submit your answers?'),
              const SizedBox(height: 12),
              Text('• Answered: $answered / $total'),
              Text('• Remaining: $remaining'),
              Text('• Skipped: ${_skippedQuestions.length}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _confirmAndSubmit(autoSubmitted: false);
              },
              child: const Text('Confirm Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Exit Exam?'),
          content: const Text(
            'Are you sure you want to leave? Your progress will be lost and the exam will end.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
                Navigator.of(context).pop(); 
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // UI Build Methods
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktopOrTablet = screenWidth >= 850;

    final List<dynamic> questions = widget.activeExam.questions;
    final int totalQuestions = questions.length;

    if (totalQuestions == 0) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.activeExam.title)),
        body: const Center(child: Text('No questions found for this exam.')),
      );
    }

    final currentQuestion = questions[_currentIndex];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitConfirmationDialog();
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildProgressBanner(context, totalQuestions),
              Expanded(
                child: isDesktopOrTablet
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: _buildQuestionSection(
                              context,
                              currentQuestion,
                              totalQuestions,
                            ),
                          ),
                          const VerticalDivider(width: 1),
                          Expanded(
                            flex: 3,
                            child: _buildNavigatorPalette(
                              context,
                              totalQuestions,
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildQuestionSection(
                              context,
                              currentQuestion,
                              totalQuestions,
                            ),
                            const Divider(height: 1),
                            _buildNavigatorPalette(
                              context,
                              totalQuestions,
                              isMobile: true,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.activeExam.title.isNotEmpty
                  ? widget.activeExam.title
                  : 'Grand Mock Test',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          // Isolated widget: its every-second setState only repaints the clock,
          // not the question text, options, or navigator palette.
          _ExamTimerWidget(
            key: _timerKey,
            initialSeconds: _initialDurationSeconds,
            onExpired: () => _submitExam(autoSubmitted: true),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBanner(BuildContext context, int totalQuestions) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final int answeredCount = _selectedAnswers.length;
    final int skippedCount = _skippedQuestions.length;
    final int remainingCount = totalQuestions - answeredCount;
    final double progressRatio =
        totalQuestions > 0 ? (_currentIndex + 1) / totalQuestions : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentIndex + 1} / $totalQuestions',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Wrap(
                spacing: 12,
                children: [
                  _buildStatBadge(
                    context,
                    label: 'Answered: $answeredCount',
                    color: colorScheme.primary,
                  ),
                  _buildStatBadge(
                    context,
                    label: 'Skipped: $skippedCount',
                    color: Colors.orange.shade800,
                  ),
                  _buildStatBadge(
                    context,
                    label: 'Remaining: $remainingCount',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressRatio,
            backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.4),
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(
    BuildContext context, {
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildQuestionSection(
    BuildContext context,
    dynamic question,
    int totalQuestions,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final String? selectedOption = _selectedAnswers[_currentIndex];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q${_currentIndex + 1}. ${question.questionText}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          ...question.options.entries.map((entry) {
            final String key = entry.key;
            final String optionValue = entry.value;
            final bool isSelected = selectedOption == key;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () => _selectOption(_currentIndex, key),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primaryContainer.withValues(alpha: 0.4)
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                        ),
                        child: Center(
                          child: Text(
                            key,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          optionValue,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed:
                    _currentIndex > 0 ? _handlePreviousQuestion : null,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Previous'),
              ),
              if (selectedOption != null)
                TextButton(
                  onPressed: () => _clearSelection(_currentIndex),
                  child: Text(
                    'Clear Selection',
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              FilledButton.icon(
                onPressed: _currentIndex < totalQuestions - 1
                    ? _handleNextQuestion
                    : _showSubmissionConfirmationDialog,
                icon: Icon(
                  _currentIndex < totalQuestions - 1
                      ? Icons.arrow_forward_rounded
                      : Icons.check_circle_rounded,
                  size: 18,
                ),
                label: Text(
                  _currentIndex < totalQuestions - 1 ? 'Next' : 'Submit Exam',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigatorPalette(
    BuildContext context,
    int totalQuestions, {
    bool isMobile = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question Navigator',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              _buildLegendItem(context, color: colorScheme.primary, label: 'Answered'),
              _buildLegendItem(context, color: Colors.orange.shade800, label: 'Skipped'),
              _buildLegendItem(context, color: colorScheme.surfaceContainerHighest, label: 'Not Visited'),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: isMobile
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.1,
            ),
            itemCount: totalQuestions,
            itemBuilder: (context, index) {
              final bool isAnswered =
                  _selectedAnswers.containsKey(index) && _selectedAnswers[index] != null;
              final bool isSkipped = _skippedQuestions.contains(index);
              final bool isActive = index == _currentIndex;

              Color bgColor = colorScheme.surfaceContainerHighest;
              Color textColor = colorScheme.onSurfaceVariant;

              if (isAnswered) {
                bgColor = colorScheme.primary;
                textColor = colorScheme.onPrimary;
              } else if (isSkipped) {
                bgColor = Colors.orange.shade100;
                textColor = Colors.orange.shade900;
              }

              return InkWell(
                onTap: () => _navigateToQuestion(index),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive
                          ? colorScheme.primary
                          : (isAnswered
                              ? colorScheme.primary
                              : colorScheme.outlineVariant),
                      width: isActive ? 2.5 : 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight:
                            isActive || isAnswered ? FontWeight.bold : FontWeight.normal,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton.icon(
              onPressed: _showSubmissionConfirmationDialog,
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Submit Exam'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ISOLATED TIMER WIDGET
// Extracted from _ActiveExamScreenState so that its Timer.periodic setState()
// only rebuilds the small clock display — NOT the entire exam screen.
//
// Before this change: setState() fired every second on _ActiveExamScreenState,
// causing a full rebuild of the question text, all 4 option AnimatedContainers,
// and the GridView navigator palette on every tick.
//
// After this change: the parent screen only rebuilds on real user actions
// (question navigation, answer selection, submission).
// =============================================================================
class _ExamTimerWidget extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback onExpired;

  const _ExamTimerWidget({
    super.key,
    required this.initialSeconds,
    required this.onExpired,
  });

  @override
  _ExamTimerWidgetState createState() => _ExamTimerWidgetState();
}

class _ExamTimerWidgetState extends State<_ExamTimerWidget> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Called by the parent (via GlobalKey) when the student manually submits,
  /// preventing onExpired from firing after the exam is already submitted.
  void cancel() {
    _timer?.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          // Only this tiny widget repaints — not the question or palette.
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        _timer?.cancel();
        widget.onExpired();
      }
    });
  }

  String _formatTime(int totalSeconds) {
    if (totalSeconds <= 0) return '00:00';
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      final String hoursStr = hours.toString().padLeft(2, '0');
      return '$hoursStr:$minutesStr:$secondsStr';
    }
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isTimerLow = _remainingSeconds <= 300;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isTimerLow
            ? colorScheme.errorContainer
            : colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isTimerLow
              ? colorScheme.error
              : colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.alarm_rounded,
            size: 18,
            color: isTimerLow ? colorScheme.error : colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TIME REMAINING',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: isTimerLow ? colorScheme.error : colorScheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                _formatTime(_remainingSeconds),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isTimerLow ? colorScheme.error : colorScheme.primary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}