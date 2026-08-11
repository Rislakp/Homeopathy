import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../admin/service/course/course_api_service.dart';

class CourseProvider extends ChangeNotifier {
  final CourseApiService _apiService = CourseApiService();

  List<CourseModel> _allCourses = [];
  List<CourseModel> _filteredCourses = [];
  bool _isLoading = false;

  // Filter States
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';

  // Getters
  bool get isLoading => _isLoading;
  List<CourseModel> get courses => _filteredCourses;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  // Load courses via API
  Future<void> loadCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allCourses = await _apiService.getCourses();
    } catch (e) {
      debugPrint('Error loading courses from API: $e');
    } finally {
      _isLoading = false;
      _applyFilters();
      notifyListeners();
    }
  }

  // CRUD Operations
  Future<void> addCourse(CourseModel course) async {
    _isLoading = true;
    notifyListeners();
    try {
      final created = await _apiService.createCourse(course);
      _allCourses.insert(0, created);
    } catch (e) {
      debugPrint('Error adding course: $e');
    } finally {
      _isLoading = false;
      _applyFilters();
      notifyListeners();
    }
  }

  Future<void> updateCourse(CourseModel course) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updated = await _apiService.updateCourse(course);
      final index = _allCourses.indexWhere((c) => c.id == course.id);
      if (index != -1) {
        _allCourses[index] = updated;
      }
    } catch (e) {
      debugPrint('Error updating course: $e');
    } finally {
      _isLoading = false;
      _applyFilters();
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
      }
    } catch (e) {
      debugPrint('Error deleting course: $e');
    } finally {
      _isLoading = false;
      _applyFilters();
      notifyListeners();
    }
  }

  // Search
  void searchCourses(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Category Filtering
  void filterCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Reset Filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All Categories';
    _applyFilters();
    notifyListeners();
  }

  // Helper filter executor
  void _applyFilters() {
    List<CourseModel> result = List.from(_allCourses);

    // Search by title, instructor, or category
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      result = result.where((c) {
        return c.title.toLowerCase().contains(q) ||
            c.instructor.toLowerCase().contains(q) ||
            c.category.toLowerCase().contains(q);
      }).toList();
    }

    // Filter by Category Dropdown
    if (_selectedCategory != 'All Categories') {
      result = result.where((c) => c.category == _selectedCategory).toList();
    }

    _filteredCourses = result;
  }
}
