class TestQuestionModel {
  final String id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer; // Stored as 'A', 'B', 'C', or 'D'
  final String? explanation;
  final String? subject;
  final DateTime? createdAt;

  const TestQuestionModel({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    this.explanation,
    this.subject,
    this.createdAt,
  });

  /// Get list of options in order A, B, C, D
  List<String> get options => [optionA, optionB, optionC, optionD];

  /// Get 0-based index of the correct answer (0 for A, 1 for B, 2 for C, 3 for D)
  int get correctIndex {
    switch (correctAnswer.trim().toUpperCase()) {
      case 'A':
      case '0':
        return 0;
      case 'B':
      case '1':
        return 1;
      case 'C':
      case '2':
        return 2;
      case 'D':
      case '3':
        return 3;
      default:
        return 0;
    }
  }

  /// Get correct answer text
  String get correctAnswerText {
    final idx = correctIndex;
    if (idx >= 0 && idx < options.length) {
      return options[idx];
    }
    return optionA;
  }

  /// Factory constructor to flexibly parse from backend responses
  factory TestQuestionModel.fromJson(Map<String, dynamic> json) {
    // 1. Parse ID
    final String id = (json['id'] ?? json['_id'] ?? '').toString();

    // 2. Parse Question text
    final String question = (json['question'] ??
            json['questionText'] ??
            json['title'] ??
            '')
        .toString()
        .trim();

    // 3. Parse Options
    String optA = '';
    String optB = '';
    String optC = '';
    String optD = '';

    if (json.containsKey('optionA') || json.containsKey('option_a')) {
      optA = (json['optionA'] ?? json['option_a'] ?? '').toString().trim();
      optB = (json['optionB'] ?? json['option_b'] ?? '').toString().trim();
      optC = (json['optionC'] ?? json['option_c'] ?? '').toString().trim();
      optD = (json['optionD'] ?? json['option_d'] ?? '').toString().trim();
    } else if (json['options'] is Map) {
      final optsMap = json['options'] as Map<String, dynamic>;
      optA = (optsMap['A'] ?? optsMap['a'] ?? optsMap['1'] ?? '').toString().trim();
      optB = (optsMap['B'] ?? optsMap['b'] ?? optsMap['2'] ?? '').toString().trim();
      optC = (optsMap['C'] ?? optsMap['c'] ?? optsMap['3'] ?? '').toString().trim();
      optD = (optsMap['D'] ?? optsMap['d'] ?? optsMap['4'] ?? '').toString().trim();
    } else if (json['options'] is List) {
      final list = json['options'] as List;
      if (list.isNotEmpty) optA = list[0]?.toString().trim() ?? '';
      if (list.length > 1) optB = list[1]?.toString().trim() ?? '';
      if (list.length > 2) optC = list[2]?.toString().trim() ?? '';
      if (list.length > 3) optD = list[3]?.toString().trim() ?? '';
    }

    // 4. Parse Correct Answer
    String correct = 'A';
    final rawCorrect = json['correctAnswer'] ??
        json['correctOption'] ??
        json['correct_answer'] ??
        json['answer'];

    if (rawCorrect != null) {
      final str = rawCorrect.toString().trim().toUpperCase();
      if (str == 'A' || str == '0' || str == 'OPTION A') {
        correct = 'A';
      } else if (str == 'B' || str == '1' || str == 'OPTION B') {
        correct = 'B';
      } else if (str == 'C' || str == '2' || str == 'OPTION C') {
        correct = 'C';
      } else if (str == 'D' || str == '3' || str == 'OPTION D') {
        correct = 'D';
      } else {
        // Check if raw string matches option text
        if (optA.isNotEmpty && str == optA.toUpperCase()) {
          correct = 'A';
        } else if (optB.isNotEmpty && str == optB.toUpperCase()) {
          correct = 'B';
        } else if (optC.isNotEmpty && str == optC.toUpperCase()) {
          correct = 'C';
        } else if (optD.isNotEmpty && str == optD.toUpperCase()) {
          correct = 'D';
        } else {
          correct = str.isNotEmpty ? str.substring(0, 1) : 'A';
        }
      }
    }

    // 5. Parse Explanation
    final rawExplanation = json['explanation'] ??
        json['rationale'] ??
        json['description'] ??
        json['solution'];
    final String? explanation = (rawExplanation != null &&
            rawExplanation.toString().trim().isNotEmpty)
        ? rawExplanation.toString().trim()
        : null;

    // 6. Parse Subject / Category
    final rawSubject = json['subject'] ??
        json['category'] ??
        json['topic'] ??
        json['subjectName'];
    final String? subject = (rawSubject != null &&
            rawSubject.toString().trim().isNotEmpty)
        ? rawSubject.toString().trim()
        : null;

    // 7. Parse Created At
    DateTime? createdAt;
    final rawDate = json['createdAt'] ?? json['created_at'] ?? json['date'];
    if (rawDate != null) {
      if (rawDate is String) {
        createdAt = DateTime.tryParse(rawDate);
      } else if (rawDate is int) {
        createdAt = DateTime.fromMillisecondsSinceEpoch(rawDate);
      }
    }

    return TestQuestionModel(
      id: id.isNotEmpty ? id : DateTime.now().millisecondsSinceEpoch.toString(),
      question: question,
      optionA: optA,
      optionB: optB,
      optionC: optC,
      optionD: optD,
      correctAnswer: correct,
      explanation: explanation,
      subject: subject,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  /// Convert to JSON payload for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'questionText': question,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'optionD': optionD,
      'options': {
        'A': optionA,
        'B': optionB,
        'C': optionC,
        'D': optionD,
      },
      'correctAnswer': correctAnswer,
      'correctOption': correctAnswer,
      if (explanation != null && explanation!.trim().isNotEmpty)
        'explanation': explanation!.trim(),
      if (subject != null && subject!.trim().isNotEmpty)
        'subject': subject!.trim(),
      if (subject != null && subject!.trim().isNotEmpty)
        'category': subject!.trim(),
      if (createdAt != null)
        'createdAt': createdAt!.toIso8601String(),
    };
  }

  /// Copy with modifications
  TestQuestionModel copyWith({
    String? id,
    String? question,
    String? optionA,
    String? optionB,
    String? optionC,
    String? optionD,
    String? correctAnswer,
    String? explanation,
    String? subject,
    DateTime? createdAt,
  }) {
    return TestQuestionModel(
      id: id ?? this.id,
      question: question ?? this.question,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      subject: subject ?? this.subject,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
