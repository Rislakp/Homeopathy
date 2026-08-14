
/// Model representing the summary details of a Grand Mock exam.
class ExamSummaryModel {
  final String id;
  final String title;
  final double marksPerQuestion;
  final int durationMinutes;
  final int totalQuestions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  const ExamSummaryModel({
    required this.id,
    required this.title,
    required this.marksPerQuestion,
    required this.durationMinutes,
    required this.totalQuestions,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Factory constructor to create an [ExamSummaryModel] from JSON map.
  factory ExamSummaryModel.fromJson(Map<String, dynamic> json) {
    return ExamSummaryModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      marksPerQuestion: (json['marksPerQuestion'] as num?)?.toDouble() ?? 0.0,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      v: (json['__v'] as num?)?.toInt(),
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
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
    };
  }

  @override
  String toString() {
    return 'ExamSummaryModel(id: $id, title: $title, marksPerQuestion: $marksPerQuestion, durationMinutes: $durationMinutes, totalQuestions: $totalQuestions, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }
}
