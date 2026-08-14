/// Models representing student exam results retrieved from GET `/api/student/results`.
class StudentResult {
  final String id;
  final String studentId;
  final ExamResultInfo exam;
  final int score;
  final int totalMarks;
  final int totalAttempted;
  final int totalCorrect;
  final int totalWrong;
  final String status;
  final List<StudentAnswer> answers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StudentResult({
    required this.id,
    required this.studentId,
    required this.exam,
    required this.score,
    required this.totalMarks,
    required this.totalAttempted,
    required this.totalCorrect,
    required this.totalWrong,
    required this.status,
    required this.answers,
    this.createdAt,
    this.updatedAt,
  });

  /// Calculates the percentage of total score safely.
  double get percentage =>
      totalMarks > 0 ? ((score / totalMarks) * 100).clamp(0.0, 100.0) : 0.0;

  factory StudentResult.fromJson(Map<String, dynamic> json) {
    // Handle exam field (can be populated Map or plain string ID)
    ExamResultInfo examInfo;
    if (json['examId'] is Map<String, dynamic>) {
      examInfo = ExamResultInfo.fromJson(json['examId'] as Map<String, dynamic>);
    } else if (json['exam'] is Map<String, dynamic>) {
      examInfo = ExamResultInfo.fromJson(json['exam'] as Map<String, dynamic>);
    } else if (json['examId'] != null) {
      examInfo = ExamResultInfo(
        id: json['examId'].toString(),
        title: json['examTitle']?.toString() ?? 'Grand Mock Test Result',
        marksPerQuestion: 0,
        durationMinutes: 0,
        totalQuestions: 0,
      );
    } else {
      examInfo = const ExamResultInfo(
        id: '',
        title: 'Grand Mock Test Result',
        marksPerQuestion: 0,
        durationMinutes: 0,
        totalQuestions: 0,
      );
    }

    // Parse answers array safely
    List<StudentAnswer> parsedAnswers = [];
    if (json['answers'] is List) {
      parsedAnswers = (json['answers'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => StudentAnswer.fromJson(item))
          .toList();
    }

    DateTime? parsedCreatedAt;
    if (json['createdAt'] != null) {
      parsedCreatedAt = DateTime.tryParse(json['createdAt'].toString());
    }

    DateTime? parsedUpdatedAt;
    if (json['updatedAt'] != null) {
      parsedUpdatedAt = DateTime.tryParse(json['updatedAt'].toString());
    }

    return StudentResult(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      exam: examInfo,
      score: (json['score'] as num?)?.toInt() ??
          (json['totalScore'] as num?)?.toInt() ??
          0,
      totalMarks: (json['totalMarks'] as num?)?.toInt() ??
          (json['maxMarks'] as num?)?.toInt() ??
          0,
      totalAttempted: (json['totalAttempted'] as num?)?.toInt() ??
          (json['attempted'] as num?)?.toInt() ??
          0,
      totalCorrect: (json['totalCorrect'] as num?)?.toInt() ??
          (json['correct'] as num?)?.toInt() ??
          0,
      totalWrong: (json['totalWrong'] as num?)?.toInt() ??
          (json['wrong'] as num?)?.toInt() ??
          0,
      status: json['status']?.toString() ?? 'Completed',
      answers: parsedAnswers,
      createdAt: parsedCreatedAt,
      updatedAt: parsedUpdatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studentId': studentId,
      'examId': exam.toJson(),
      'score': score,
      'totalMarks': totalMarks,
      'totalAttempted': totalAttempted,
      'totalCorrect': totalCorrect,
      'totalWrong': totalWrong,
      'status': status,
      'answers': answers.map((a) => a.toJson()).toList(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

/// Information about the exam attached to a result.
class ExamResultInfo {
  final String id;
  final String title;
  final int marksPerQuestion;
  final int durationMinutes;
  final int totalQuestions;

  const ExamResultInfo({
    required this.id,
    required this.title,
    required this.marksPerQuestion,
    required this.durationMinutes,
    required this.totalQuestions,
  });

  factory ExamResultInfo.fromJson(Map<String, dynamic> json) {
    return ExamResultInfo(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ??
          json['name']?.toString() ??
          'Grand Mock Test Result',
      marksPerQuestion: (json['marksPerQuestion'] as num?)?.toInt() ?? 0,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'marksPerQuestion': marksPerQuestion,
      'durationMinutes': durationMinutes,
      'totalQuestions': totalQuestions,
    };
  }
}

/// Answer detail for a specific question in a student result.
class StudentAnswer {
  final String questionId;
  final String selectedOption;
  final bool isCorrect;

  const StudentAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
  });

  factory StudentAnswer.fromJson(Map<String, dynamic> json) {
    return StudentAnswer(
      questionId: json['questionId']?.toString() ?? '',
      selectedOption: json['selectedOption']?.toString() ?? '',
      isCorrect: json['isCorrect'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedOption': selectedOption,
      'isCorrect': isCorrect,
    };
  }
}
