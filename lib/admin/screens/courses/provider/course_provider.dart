import 'package:flutter/material.dart';
import '../../../service/course/course_api_service.dart';
import '../model/course_model.dart';

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

  // Load courses simulation
  Future<void> loadCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCourses();
      if (response.success) {
        _allCourses = response.data.map((apiCourse) {
          return CourseModel(
            id: apiCourse.id ?? '',
            courseId: apiCourse.courseId,
            title: apiCourse.courseTitle,
            instructor: apiCourse.instructor,
            category: apiCourse.category ?? 'Materia Medica',
            price: apiCourse.price,
            status: 'Published',
            description: 'Course by ${apiCourse.instructor}',
            image: 'menu_book',
            students: 0,
          );
        }).toList();
        _applyFilters();
      }
    } catch (e) {
      debugPrint('Error loading courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CRUD Operations
  Future<void> addCourse(CourseModel course) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.createCourse(
        courseTitle: course.title,
        instructor: course.instructor,
        category: course.category,
        price: course.price,
      );

      if (response.success) {
        final createdCourse = CourseModel(
          id: response.data.id ?? '',
          courseId: response.data.courseId,
          title: response.data.courseTitle,
          instructor: response.data.instructor,
          category: response.data.category ?? course.category,
          price: response.data.price,
          status: course.status,
          description: course.description,
          image: course.image,
          students: course.students,
        );
        _allCourses.insert(0, createdCourse);
        _applyFilters();
      }
    } catch (e) {
      debugPrint('Error adding course: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCourse(CourseModel course) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.updateCourse(
        courseId: course.courseId,
        courseTitle: course.title,
        instructor: course.instructor,
        price: course.price,
      );

      if (response.success) {
        final index = _allCourses.indexWhere((c) => c.courseId == course.courseId);
        if (index != -1) {
          _allCourses[index] = course.copyWith(
            id: response.data.id ?? course.id,
            courseId: response.data.courseId,
            title: response.data.courseTitle,
            instructor: response.data.instructor,
            price: response.data.price,
            category: response.data.category ?? course.category,
          );
          _applyFilters();
        }
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
      final response = await _apiService.deleteCourse(id);
      if (response.success) {
        _allCourses.removeWhere((c) => c.courseId == id || c.id == id);
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