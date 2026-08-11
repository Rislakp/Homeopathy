import 'package:flutter/foundation.dart';

class AdminMCQQuestion {
  String question;
  List<String> options;
  int correctAnswer;
  double marks;

  AdminMCQQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.marks,
  });
}

class GrandMockProvider extends ChangeNotifier {
  int currentStep = 0;

  String title = '';
  double marksPerQuestion = 1.0;
  int durationMinutes = 60;
  int numberOfQuestions = 10;

  String? pdfPath;

  final List<AdminMCQQuestion> questions = [];

  // -----------------------------
  // STEP
  // -----------------------------

  void nextStep() {
    if (currentStep < 3) {
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
  // PDF
  // -----------------------------

  void setPdf(String path) {
    pdfPath = path;
    notifyListeners();
  }

  // -----------------------------
  // MCQ
  // -----------------------------

  void addQuestion(
    AdminMCQQuestion question,
  ) {
    questions.add(question);
    notifyListeners();
  }

  void updateQuestion(
    int index,
    AdminMCQQuestion question,
  ) {
    if (index >= 0 &&
        index < questions.length) {
      questions[index] = question;
      notifyListeners();
    }
  }

  void deleteQuestion(int index) {
    if (index >= 0 &&
        index < questions.length) {
      questions.removeAt(index);
      notifyListeners();
    }
  }

  // -----------------------------
  // RESET
  // -----------------------------

  void clearAll() {
    currentStep = 0;

    title = '';
    marksPerQuestion = 1.0;
    durationMinutes = 60;
    numberOfQuestions = 10;

    pdfPath = null;
    questions.clear();

    notifyListeners();
  }
}