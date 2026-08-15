import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../services/student_api_service.dart';
import '../model/student_model.dart';

class StudentProvider extends ChangeNotifier {
  final StudentApiService _apiService = StudentApiService();

  List<StudentModel> _students = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filter criteria
  String _searchQuery = '';
  String _selectedCourse = 'All Courses';
  String _selectedStatus = 'All Status';

  Timer? _debounceTimer;

  // Getters
  List<StudentModel> get students => _students;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCourse => _selectedCourse;
  String get selectedStatus => _selectedStatus;

  StudentProvider() {
    fetchStudents();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Fetches students from backend using current filter parameters.
  Future<void> fetchStudents({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final courseParam = _selectedCourse == 'All Courses' ? null : _selectedCourse;
      final statusParam = _selectedStatus == 'All Status' ? null : _selectedStatus;
      final searchParam = _searchQuery.trim().isEmpty ? null : _searchQuery.trim();

      final result = await _apiService.fetchStudents(
        page: 1,
        limit: 50,
        search: searchParam,
        course: courseParam,
        status: statusParam,
      );

      _students = result;
      _errorMessage = null;
    } catch (e) {
      debugPrint('Error fetching students: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      // If error occurs, we retain existing list or set to empty
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registers a new student via the backend API
  Future<bool> registerStudentViaApi({
    required String name,
    required String email,
    required String password,
    required String dateOfBirth,
    required String contactNumber,
    required String qualification,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Calls your api service to execute the POST /api/auth/register request
      final success = await _apiService.registerStudent(
        name: name,
        email: email,
        password: password,
        dateOfBirth: dateOfBirth,
        contactNumber: contactNumber,
        qualification: qualification,
      );

      if (success == true) {
        // Refresh the student list so the new record immediately shows up in the admin table
        await fetchStudents(showLoading: false);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error registering student: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refreshes the students list.
  Future<void> refresh() => fetchStudents(showLoading: true);

  /// Search students with a debounce timer for optimal performance.
  void searchStudents(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      fetchStudents(showLoading: true);
    });
    notifyListeners();
  }

  /// Filter students by course title.
  void filterCourse(String course) {
    _selectedCourse = course;
    fetchStudents(showLoading: true);
  }

  /// Filter students by subscription status.
  void filterStatus(String status) {
    _selectedStatus = status;
    fetchStudents(showLoading: true);
  }

  /// Reset all filters to default and refetch.
  void resetFilters() {
    _searchQuery = '';
    _selectedCourse = 'All Courses';
    _selectedStatus = 'All Status';
    fetchStudents(showLoading: true);
  }

  /// Add student locally or after creation.
  void addStudent(StudentModel student) {
    _students.insert(0, student);
    notifyListeners();
  }

  /// Edit student locally.
  void editStudent(StudentModel updatedStudent) {
    final index = _students.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent;
      notifyListeners();
    }
  }

  /// Delete student locally.
  void deleteStudent(String id) {
    _students.removeWhere((student) => student.id == id);
    notifyListeners();
  }
}