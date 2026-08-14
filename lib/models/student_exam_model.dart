/// Model representing a mock exam item for the Student Portal.
class StudentExamModel {
  final String id;
  final String title;
  final double marksPerQuestion;
  final int durationMinutes;
  final int totalQuestions;
  final String status;
  final int? previousScore;
  final int totalMarks;
  final DateTime? lastAttemptedAt;
  final String? resultId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StudentExamModel({
    required this.id,
    required this.title,
    required this.marksPerQuestion,
    required this.durationMinutes,
    required this.totalQuestions,
    required this.status,
    this.previousScore,
    required this.totalMarks,
    this.lastAttemptedAt,
    this.resultId,
    this.createdAt,
    this.updatedAt,
  });

  /// Helper getter to check if the student has attempted the exam.
  bool get isAttempted =>
      status.toLowerCase() == 'attempted' || previousScore != null;

  /// Factory constructor to parse a [StudentExamModel] from JSON map.
  factory StudentExamModel.fromJson(Map<String, dynamic> json) {
    final double marksPerQ =
        (json['marksPerQuestion'] as num?)?.toDouble() ?? 0.0;
    final int totalQ = (json['totalQuestions'] as num?)?.toInt() ?? 0;
    final int calculatedTotalMarks = (marksPerQ * totalQ).round();

    return StudentExamModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      marksPerQuestion: marksPerQ,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      totalQuestions: totalQ,
      status: json['status'] as String? ?? 'Not Started',
      previousScore: (json['previousScore'] as num?)?.toInt(),
      totalMarks: (json['totalMarks'] as num?)?.toInt() ?? calculatedTotalMarks,
      lastAttemptedAt: json['lastAttemptedAt'] != null
          ? DateTime.tryParse(json['lastAttemptedAt'].toString())
          : null,
      resultId: json['resultId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  /// Converts the model instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'marksPerQuestion': marksPerQuestion,
      'durationMinutes': durationMinutes,
      'totalQuestions': totalQuestions,
      'status': status,
      'previousScore': previousScore,
      'totalMarks': totalMarks,
      if (lastAttemptedAt != null)
        'lastAttemptedAt': lastAttemptedAt!.toIso8601String(),
      if (resultId != null) 'resultId': resultId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'StudentExamModel(id: $id, title: $title, status: $status, previousScore: $previousScore, totalMarks: $totalMarks)';
  }
}
