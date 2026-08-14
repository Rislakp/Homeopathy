import 'package:flutter/foundation.dart';
import 'package:homeopathy/api/api_service.dart';
import 'package:homeopathy/models/test_question_model.dart';

class TestHistoryProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<TestQuestionModel> _questions = [];
  bool _isLoading = false;
  bool _isUploading = false;
  String? _errorMessage;
  String? _successMessage;

  String _searchQuery = '';
  String _selectedSubject = 'All';

  TestHistoryProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // -------------------------------------------------------------
  // GETTERS
  // -------------------------------------------------------------

  List<TestQuestionModel> get questions => _questions;

  int get totalQuestions => _questions.length;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  String? get errorMessage => _errorMessage;

  String? get successMessage => _successMessage;

  String get searchQuery => _searchQuery;

  String get selectedSubject => _selectedSubject;

  /// Returns list of unique subjects available plus 'All'
  List<String> get availableSubjects {
    final Set<String> subjects = {'All'};
    for (final q in _questions) {
      if (q.subject != null && q.subject!.trim().isNotEmpty) {
        subjects.add(q.subject!.trim());
      }
    }
    return subjects.toList();
  }

  /// Filtered questions based on search query and subject filter
  List<TestQuestionModel> get filteredQuestions {
    return _questions.where((q) {
      // 1. Subject filter
      if (_selectedSubject != 'All') {
        if (q.subject == null ||
            q.subject!.trim().toLowerCase() != _selectedSubject.toLowerCase()) {
          return false;
        }
      }

      // 2. Search query filter
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.trim().toLowerCase();
        final matchQuestion = q.question.toLowerCase().contains(query);
        final matchOptionA = q.optionA.toLowerCase().contains(query);
        final matchOptionB = q.optionB.toLowerCase().contains(query);
        final matchOptionC = q.optionC.toLowerCase().contains(query);
        final matchOptionD = q.optionD.toLowerCase().contains(query);
        final matchSubject = q.subject?.toLowerCase().contains(query) ?? false;
        final matchExplanation =
            q.explanation?.toLowerCase().contains(query) ?? false;

        return matchQuestion ||
            matchOptionA ||
            matchOptionB ||
            matchOptionC ||
            matchOptionD ||
            matchSubject ||
            matchExplanation;
      }

      return true;
    }).toList();
  }

  // -------------------------------------------------------------
  // ACTIONS
  // -------------------------------------------------------------

  /// Set search query for filtering
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Set selected subject filter
  void setSubjectFilter(String subject) {
    _selectedSubject = subject;
    notifyListeners();
  }

  /// Clear any active error or success messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Fetch all questions from the GET API
  Future<void> fetchQuestions({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final fetched = await _apiService.fetchTestQuestions();
      _questions = fetched;
      _errorMessage = null;
    } catch (e) {
      debugPrint('TestHistoryProvider.fetchQuestions error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Upload a new question via POST API
  Future<bool> uploadQuestion({
    required String question,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String correctAnswer,
    String? explanation,
    String? subject,
  }) async {
    _isUploading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final newQuestion = TestQuestionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        question: question.trim(),
        optionA: optionA.trim(),
        optionB: optionB.trim(),
        optionC: optionC.trim(),
        optionD: optionD.trim(),
        correctAnswer: correctAnswer.trim().toUpperCase(),
        explanation: (explanation != null && explanation.trim().isNotEmpty)
            ? explanation.trim()
            : null,
        subject: (subject != null && subject.trim().isNotEmpty)
            ? subject.trim()
            : null,
        createdAt: DateTime.now(),
      );

      final savedQuestion = await _apiService.uploadTestQuestion(newQuestion);

      // Prepend to top of list
      _questions.insert(0, savedQuestion);
      _successMessage = 'Question uploaded successfully!';
      _errorMessage = null;

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('TestHistoryProvider.uploadQuestion error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _successMessage = null;
      notifyListeners();
      return false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// Delete a question by ID
  Future<bool> deleteQuestion(String id) async {
    try {
      final success = await _apiService.deleteTestQuestion(id);
      if (success) {
        _questions.removeWhere((q) => q.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('TestHistoryProvider.deleteQuestion error: $e');
      return false;
    }
  }
}
