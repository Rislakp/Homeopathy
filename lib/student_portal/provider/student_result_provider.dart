import 'package:flutter/foundation.dart';
import 'package:homeopathy/student_portal/models/student_result_model.dart';
import 'package:homeopathy/student_portal/services/student_result_service.dart';

/// Provider for managing student exam results state across the student portal.
class StudentResultProvider extends ChangeNotifier {
  final StudentResultService _service = StudentResultService();

  List<StudentResult> _results = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<StudentResult> get results => _results;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Returns the most recent result if available.
  StudentResult? get latestResult => _results.isNotEmpty ? _results.first : null;

  /// Retrieves a specific result matching [examId] or [resultId].
  StudentResult? getResultByExamId(String? examId) {
    if (examId == null || examId.trim().isEmpty) {
      return latestResult;
    }

    try {
      return _results.firstWhere(
        (res) => res.exam.id == examId || res.id == examId,
      );
    } catch (_) {
      return latestResult;
    }
  }

  /// Fetches all exam results from the API.
  Future<void> fetchStudentResults() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _results = await _service.getStudentResults();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
