/// Difficulty levels for mock exams.
enum ExamDifficulty {
  high('High'),
  medium('Medium'),
  easy('Easy');

  final String label;
  const ExamDifficulty(this.label);
}

/// Status of the exam attempt for a student.
enum ExamStatus {
  attempted('Attempted'),
  notStarted('Not Started');

  final String label;
  const ExamStatus(this.label);
}

/// Mock model representing a Grand Mock Exam for the Student Portal.
class StudentMockExamModel {
  final String id;
  final String title;
  final String pattern;
  final ExamDifficulty difficulty;
  final int totalQuestions;
  final int totalMarks;
  final int durationMinutes;
  final int? previousScore;
  final ExamStatus status;

  const StudentMockExamModel({
    required this.id,
    required this.title,
    this.pattern = 'Medical Entrance Pattern',
    required this.difficulty,
    required this.totalQuestions,
    required this.totalMarks,
    required this.durationMinutes,
    this.previousScore,
    required this.status,
  });

  /// Convenience getter to check if the student has attempted this test.
  bool get isAttempted => status == ExamStatus.attempted;
}
