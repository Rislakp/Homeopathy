/// Model representing a single question with its options and correct answer.
class QuestionModel {
  final String? id;
  final String questionText;
  final Map<String, String> options;
  final String correctOption;

  const QuestionModel({
    this.id,
    required this.questionText,
    required this.options,
    required this.correctOption,
  });

  /// Helper getters for standard A, B, C, D options
  String get optionA => options['A'] ?? '';
  String get optionB => options['B'] ?? '';
  String get optionC => options['C'] ?? '';
  String get optionD => options['D'] ?? '';

  /// Factory constructor to parse a [QuestionModel] from JSON map.
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    Map<String, String> parsedOptions = {};
    if (json['options'] is Map) {
      final Map<dynamic, dynamic> rawOptions = json['options'] as Map<dynamic, dynamic>;
      parsedOptions = rawOptions.map(
        (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
      );
    }

    return QuestionModel(
      id: json['_id'] as String? ?? json['id'] as String?,
      questionText: json['questionText'] as String? ?? '',
      options: parsedOptions,
      correctOption: json['correctOption'] as String? ?? '',
    );
  }

  /// Converts the question model instance back to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'questionText': questionText,
      'options': options,
      'correctOption': correctOption,
    };
  }
}

/// Model representing the complete detailed information of a Grand Mock exam.
class ExamDetailModel {
  final String id;
  final String title;
  final double marksPerQuestion;
  final int durationMinutes;
  final int totalQuestions;
  final List<QuestionModel> questions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  const ExamDetailModel({
    required this.id,
    required this.title,
    required this.marksPerQuestion,
    required this.durationMinutes,
    required this.totalQuestions,
    required this.questions,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Computed total maximum marks for the exam
  double get totalMarks => marksPerQuestion * (totalQuestions > 0 ? totalQuestions : questions.length);

  /// Factory constructor to parse an [ExamDetailModel] from JSON map.
  factory ExamDetailModel.fromJson(Map<String, dynamic> json) {
    List<QuestionModel> parsedQuestions = [];
    if (json['questions'] is List) {
      parsedQuestions = (json['questions'] as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map((item) => QuestionModel.fromJson(item))
          .toList();
    }

    return ExamDetailModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      marksPerQuestion: (json['marksPerQuestion'] as num?)?.toDouble() ?? 0.0,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? parsedQuestions.length,
      questions: parsedQuestions,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      v: (json['__v'] as num?)?.toInt(),
    );
  }

  /// Converts the exam detail model instance back to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'marksPerQuestion': marksPerQuestion,
      'durationMinutes': durationMinutes,
      'totalQuestions': totalQuestions,
      'questions': questions.map((q) => q.toJson()).toList(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
    };
  }
}
