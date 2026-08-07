import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/course_model.dart';

class CourseProvider extends ChangeNotifier {
  static const String _baseUrl = 'https://homeopathybackend-1.onrender.com/api/courses';

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
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> rawData = [];

        // Safely handle both Map { "data": [...] } and direct List [...] responses
        if (decoded is Map<String, dynamic>) {
          rawData = decoded['data'] ?? decoded['courses'] ?? [];
        } else if (decoded is List) {
          rawData = decoded;
        }

        _allCourses.clear();

        // Safely parse each item so one bad database entry doesn't break the whole app
        for (var item in rawData) {
          try {
            _allCourses.add(CourseModel.fromJson(item));
          } catch (e) {
            debugPrint('Skipped corrupted course entry: $e');
          }
        }
      } else {
        throw Exception('Failed to load courses. Status: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('Error fetching courses in CourseProvider: $e');
    } finally {
      _isLoading = false;
      _applyFilters();
      notifyListeners();
    }
  }

  // Alias for backward compatibility
  Future<void> loadCourses() async {
    await fetchCourses();
  }

  // ==========================================
  // Create a new course (POST)
  // ==========================================
  Future<bool> addCourse(CourseModel course) async {
    _isCreating = true;
    _isLoading = true;
    _errorMessage = null;
    bool success = false;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(course.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final Map<String, dynamic> data = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
            ? decoded['data'] 
            : decoded;
            
        final newCourse = CourseModel.fromJson(data);
        
        _allCourses.insert(0, newCourse);
        _applyFilters();
        success = true;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _errorMessage = responseData['message'] ?? 'Failed to save course. Status: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      debugPrint('Error adding course in CourseProvider: $e');
    } finally {
      _isCreating = false;
      _isLoading = false;
      notifyListeners();
    }
    
    return success;
  }

  // Legacy createCourse helper
 Future<bool> createCourse({
  required String courseTitle,
  required String instructor,
  required String category,
  required double price,
}) async {
  _isCreating = true;
  _isLoading = true;
  _errorMessage = null;

  notifyListeners();

  try {
    print('Creating course: $courseTitle');

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'courseTitle': courseTitle,
        'instructor': instructor,
        'category': category,
        'price': price,
      }),
    );

    print('POST STATUS: ${response.statusCode}');
    print('POST RESPONSE: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      await fetchCourses();
      return true;
    }

    _errorMessage =
        responseData['message'] ?? 'Failed to create course';

    return false;
  } catch (e) {
    _errorMessage = 'Network error: $e';

    debugPrint('CREATE COURSE ERROR: $e');

    return false;
  } finally {
    _isCreating = false;
    _isLoading = false;

    notifyListeners();
  }
}

  // ==========================================
  // Update an existing course (PUT)
  // ==========================================
  Future<bool> updateCourse(dynamic arg1, [CourseModel? arg2]) async {
    String courseId;
    CourseModel updatedCourse;
    bool success = false;

    if (arg2 == null && arg1 is CourseModel) {
      updatedCourse = arg1;
      courseId = arg1.courseId.isNotEmpty ? arg1.courseId : arg1.id;
    } else if (arg1 is String && arg2 is CourseModel) {
      courseId = arg1;
      updatedCourse = arg2;
    } else {
      _errorMessage = 'Invalid arguments to updateCourse';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$courseId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedCourse.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        final index = _allCourses.indexWhere((c) => c.courseId == courseId || c.id == courseId);
        if (index != -1) {
          _allCourses[index] = updatedCourse;
        }
        _applyFilters();
        success = true;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _errorMessage = responseData['message'] ?? 'Failed to update course. Status: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      debugPrint('Error updating course in CourseProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
    return success;
  }

  // ==========================================
  // Delete a course (DELETE)
  // ==========================================
  Future<bool> deleteCourse(String courseId) async {
    _isLoading = true;
    _errorMessage = null;
    bool success = false;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$courseId'),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _allCourses.removeWhere((c) => c.courseId == courseId || c.id == courseId);
        _applyFilters();
        success = true;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _errorMessage = responseData['message'] ?? 'Failed to delete course. Status: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      debugPrint('Error deleting course in CourseProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
    return success;
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