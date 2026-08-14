/// Model representing a single sanitized question (without sensitive answer key data)
/// provided to students during an active exam session.
class SanitizedQuestionModel {
  final String id;
  final String questionText;
  final Map<String, String> options;

  const SanitizedQuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
  });

  /// Factory constructor to parse a [SanitizedQuestionModel] from JSON.
  factory SanitizedQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    final Map<String, String> parsedOptions = {};

    if (rawOptions is Map) {
      rawOptions.forEach((key, value) {
        if (key != null && value != null) {
          parsedOptions[key.toString()] = value.toString();
        }
      });
    }

    final String parsedId = json['_id'] as String? ??
        json['id'] as String? ??
        json['questionId'] as String? ??
        '';

    return SanitizedQuestionModel(
      id: parsedId,
      questionText: json['questionText'] as String? ?? json['question'] as String? ?? '',
      options: parsedOptions,
    );
  }

  /// Converts the model instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questionText': questionText,
      'options': options,
    };
  }

  @override
  String toString() {
    return 'SanitizedQuestionModel(id: $id, questionText: $questionText, optionsCount: ${options.length})';
  }
}

/// Model representing an active exam session containing sanitized metadata and questions.
class ActiveExamModel {
  final String id;
  final String title;
  final double marksPerQuestion;
  final int durationMinutes;
  final int totalQuestions;
  final List<SanitizedQuestionModel> questions;

  const ActiveExamModel({
    required this.id,
    required this.title,
    required this.marksPerQuestion,
    required this.durationMinutes,
    required this.totalQuestions,
    required this.questions,
  });

  /// Factory constructor to parse an [ActiveExamModel] from JSON.
  factory ActiveExamModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> questionList = json['questions'] as List<dynamic>? ?? [];

    return ActiveExamModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      marksPerQuestion: (json['marksPerQuestion'] as num?)?.toDouble() ?? 0.0,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? questionList.length,
      questions: questionList
          .map((item) =>
              SanitizedQuestionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts the model instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'marksPerQuestion': marksPerQuestion,
      'durationMinutes': durationMinutes,
      'totalQuestions': totalQuestions,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ActiveExamModel(id: $id, title: $title, durationMinutes: $durationMinutes, questionsCount: ${questions.length})';
  }
}
