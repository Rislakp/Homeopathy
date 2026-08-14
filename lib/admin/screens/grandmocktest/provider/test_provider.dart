import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:homeopathy/services/exam_api_service.dart';

class AdminMCQQuestion {
  String question;
  List<String> options;
  int correctAnswer; // Index: 0 for A, 1 for B, 2 for C, 3 for D, etc.
  double marks;
  String? explanation;

  AdminMCQQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.marks,
    this.explanation,
  });

  AdminMCQQuestion copyWith({
    String? question,
    List<String>? options,
    int? correctAnswer,
    double? marks,
    String? explanation,
  }) {
    return AdminMCQQuestion(
      question: question ?? this.question,
      options: options != null ? List<String>.from(options) : List<String>.from(this.options),
      correctAnswer: correctAnswer ?? this.correctAnswer,
      marks: marks ?? this.marks,
      explanation: explanation ?? this.explanation,
    );
  }
}

class GrandMockProvider extends ChangeNotifier {
  int currentStep = 0;

  String title = '';
  double marksPerQuestion = 1.0;
  int durationMinutes = 60;
  int numberOfQuestions = 10;

  PlatformFile? selectedPdf;
  String? lastExtractionError;

  final List<AdminMCQQuestion> questions = [];

  bool isParsing = false;
  bool isPublishing = false;

  final _apiService = ExamApiService();

  // -----------------------------
  // STEP MANAGEMENT
  // -----------------------------

  void setStep(int step) {
    if (step >= 0 && step <= 2) {
      currentStep = step;
      notifyListeners();
    }
  }

  void nextStep() {
    if (currentStep < 2) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  // -----------------------------
  // TEST DETAILS
  // -----------------------------

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setMarks(double value) {
    marksPerQuestion = value;
    for (final q in questions) {
      q.marks = value;
    }
    notifyListeners();
  }

  void setDuration(int value) {
    durationMinutes = value;
    notifyListeners();
  }

  void setQuestionCount(int value) {
    numberOfQuestions = value;
    notifyListeners();
  }

  // -----------------------------
  // PDF MANAGEMENT
  // -----------------------------

  void setPdf(PlatformFile file) {
    selectedPdf = file;
    lastExtractionError = null;
    
    // Auto-fill title from filename if title is currently empty
    if (title.trim().isEmpty) {
      String cleanTitle = file.name;
      if (cleanTitle.toLowerCase().endsWith('.pdf')) {
        cleanTitle = cleanTitle.substring(0, cleanTitle.length - 4);
      }
      cleanTitle = cleanTitle.replaceAll('_', ' ').replaceAll('-', ' ');
      title = cleanTitle.trim();
    }

    notifyListeners();
  }

  void clearPdf() {
    selectedPdf = null;
    lastExtractionError = null;
    notifyListeners();
  }

  // -----------------------------
  // MCQ QUESTIONS CRUD
  // -----------------------------

  void addQuestion(AdminMCQQuestion question) {
    questions.add(question);
    numberOfQuestions = questions.length;
    notifyListeners();
  }

  void updateQuestion(int index, AdminMCQQuestion question) {
    if (index >= 0 && index < questions.length) {
      questions[index] = question;
      notifyListeners();
    }
  }

  void deleteQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      questions.removeAt(index);
      numberOfQuestions = questions.length;
      notifyListeners();
    }
  }

  // -----------------------------
  // API INTEGRATION
  // -----------------------------

  Future<void> extractQuestionsFromPdf() async {
    if (selectedPdf == null) {
      throw Exception('No PDF file selected. Please choose a PDF first.');
    }

    isParsing = true;
    lastExtractionError = null;
    notifyListeners();

    try {
      final response = await _apiService.extractMcqs(selectedPdf!);
      final dynamic rawQuestions = response['questions'] ?? response['data'];
      final List<dynamic> extractedList = (rawQuestions is List) ? rawQuestions : [];

      if (extractedList.isEmpty) {
        throw Exception('No MCQs could be extracted from the provided PDF.');
      }

      questions.clear();
      for (final q in extractedList) {
        if (q is! Map) continue;

        final qText = (q['questionText'] ?? q['question'] ?? q['title'] ?? '').toString().trim();
        if (qText.isEmpty) continue;

        List<String> parsedOptions = [];
        final dynamic rawOpts = q['options'];

        if (rawOpts is Map) {
          final sortedKeys = rawOpts.keys.toList()
            ..sort((a, b) => a.toString().compareTo(b.toString()));
          parsedOptions = sortedKeys.map((k) => rawOpts[k]?.toString().trim() ?? '').toList();
        } else if (rawOpts is List) {
          parsedOptions = rawOpts.map((item) {
            if (item is Map && item.containsKey('text')) {
              return item['text']?.toString().trim() ?? '';
            }
            return item?.toString().trim() ?? '';
          }).toList();
        }

        // Ensure exactly 4 options exist (or pad if fewer)
        while (parsedOptions.length < 4) {
          parsedOptions.add('');
        }

        // Parse correct answer
        final dynamic rawCorrect = q['correctOption'] ?? q['correctAnswer'] ?? q['answer'] ?? 'A';
        int correctIndex = 0;

        if (rawCorrect is int) {
          correctIndex = rawCorrect;
        } else {
          final correctStr = rawCorrect.toString().trim().toUpperCase();
          if (correctStr == 'A' || correctStr == '0' || correctStr == 'OPTION A') {
            correctIndex = 0;
          } else if (correctStr == 'B' || correctStr == '1' || correctStr == 'OPTION B') {
            correctIndex = 1;
          } else if (correctStr == 'C' || correctStr == '2' || correctStr == 'OPTION C') {
            correctIndex = 2;
          } else if (correctStr == 'D' || correctStr == '3' || correctStr == 'OPTION D') {
            correctIndex = 3;
          } else {
            // Check if string matches one of the options
            final foundIdx = parsedOptions.indexWhere(
              (opt) => opt.toLowerCase() == rawCorrect.toString().trim().toLowerCase(),
            );
            if (foundIdx != -1) {
              correctIndex = foundIdx;
            }
          }
        }

        if (correctIndex < 0 || correctIndex >= parsedOptions.length) {
          correctIndex = 0;
        }

        // Parse explanation if available
        final rawExplanation = q['explanation'] ?? q['rationale'] ?? q['description'] ?? q['solution'];
        final String? explanation = (rawExplanation != null && rawExplanation.toString().trim().isNotEmpty)
            ? rawExplanation.toString().trim()
            : null;

        questions.add(AdminMCQQuestion(
          question: qText,
          options: parsedOptions,
          correctAnswer: correctIndex,
          marks: marksPerQuestion,
          explanation: explanation,
        ));
      }

      if (questions.isNotEmpty) {
        numberOfQuestions = questions.length;
      }
    } catch (e) {
      lastExtractionError = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isParsing = false;
      notifyListeners();
    }
  }

  Future<void> publishMockExam() async {
    if (title.trim().isEmpty) {
      throw Exception('Exam title cannot be empty.');
    }
    if (questions.isEmpty) {
      throw Exception('No questions to publish. Please add or extract questions first.');
    }

    isPublishing = true;
    notifyListeners();

    try {
      final optionLetters = const ['A', 'B', 'C', 'D', 'E', 'F'];
      final mappedQuestions = questions.map((q) {
        final optionsMap = <String, String>{};
        for (int i = 0; i < q.options.length; i++) {
          final letter = i < optionLetters.length ? optionLetters[i] : 'Option ${i + 1}';
          optionsMap[letter] = q.options[i];
        }
        final correctLetter = (q.correctAnswer >= 0 && q.correctAnswer < optionLetters.length)
            ? optionLetters[q.correctAnswer]
            : 'A';

        final Map<String, dynamic> item = {
          'questionText': q.question,
          'options': optionsMap,
          'correctOption': correctLetter,
        };

        if (q.explanation != null && q.explanation!.trim().isNotEmpty) {
          item['explanation'] = q.explanation!.trim();
        }

        return item;
      }).toList();

      await _apiService.saveGrandMock(
        title: title.trim(),
        marksPerQuestion: marksPerQuestion,
        durationMinutes: durationMinutes,
        totalQuestions: questions.length,
        questions: mappedQuestions,
      );

      // Reset state upon successful publish
      clearAll();
    } finally {
      isPublishing = false;
      notifyListeners();
    }
  }

  // -----------------------------
  // RESET STATE
  // -----------------------------

  void clearAll() {
    currentStep = 0;

    title = '';
    marksPerQuestion = 1.0;
    durationMinutes = 60;
    numberOfQuestions = 10;

    selectedPdf = null;
    lastExtractionError = null;
    questions.clear();
    isParsing = false;
    isPublishing = false;

    notifyListeners();
  }
}