import 'package:flutter/material.dart';
import '../../../service/course/course_api_service.dart';
import '../model/course_model.dart';

class CourseProvider extends ChangeNotifier {
  final CourseApiService _apiService = CourseApiService();

  List<CourseModel> _allCourses = [];
  List<CourseModel> _filteredCourses = [];
  
  bool _isLoading = false;
  bool _isCreating = false; 
  String? _errorMessage;

  // Filter and Search States
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';

  // Getters
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;
  List<CourseModel> get courses => _filteredCourses;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  // ==========================================
  // Fetch all courses (GET)
  // ==========================================
  Future<void> fetchCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getCourses();
      _allCourses = response;
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading courses: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCourses() => fetchCourses();

  // CRUD Operations
  Future<void> addCourse(CourseModel course) async {
    _isCreating = true;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.createCourse(course);
      _allCourses.insert(0, response);
      _applyFilters();
    } catch (e) {
      debugPrint('Error adding course: $e');
      rethrow;
    } finally {
      _isCreating = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCourse(CourseModel course) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.updateCourse(course);
      final index = _allCourses.indexWhere((c) => c.id == course.id);
      if (index != -1) {
        _allCourses[index] = response;
        _applyFilters();
      }
    } catch (e) {
      debugPrint('Error updating course: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCourse(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _apiService.deleteCourse(id);
      if (success) {
        _allCourses.removeWhere((c) => c.id == id);
        _applyFilters();
      }
    } catch (e) {
      debugPrint('Error deleting course: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // Search & Filtering Logic
  // ==========================================
  void searchCourses(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All Categories';
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<CourseModel> result = List.from(_allCourses);

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      result = result.where((c) {
        return c.title.toLowerCase().contains(q) ||
            c.instructor.toLowerCase().contains(q) ||
            c.category.toLowerCase().contains(q);
      }).toList();
    }

    if (_selectedCategory != 'All Categories') {
      result = result.where((c) => c.category == _selectedCategory).toList();
    }

    _filteredCourses = result;
  }
}