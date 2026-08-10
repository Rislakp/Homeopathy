import 'package:flutter/material.dart';
import 'package:homeopathy/admin/models/course_management_model.dart';
import '../models/course_api_models.dart';
import '../service/course/course_api_service.dart';

class CourseManagementNotifier extends ChangeNotifier {
  final CourseApiService _apiService = CourseApiService();

  CourseDetailModel? selectedCourseData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String searchQuery = '';
  String selectedCategory = 'All Categories';
  String selectedInstructor = 'All Instructors';
  String selectedStatus = 'All Status';
  String selectedLanguage = 'All Languages';
  String selectedSort = 'Newest';

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CourseModel> get courses => _courses;

  final List<String> categories = [
    'All Categories',
    'Materia Medica',
    'Organon',
    'Pharmacy',
    'Clinical',
    'Anatomy',
  ];

  final List<String> instructors = [
    'All Instructors',
    'Dr. Renu Sharma',
    'Dr. Arjun',
    'Dr. Meera',
    'Dr. Ahmed',
  ];

  final List<String> statuses = ['All Status', 'Published', 'Draft'];
  final List<String> languages = ['All Languages', 'English', 'Hindi', 'Bilingual'];
  final List<String> sortOptions = ['Newest', 'Popularity', 'Rating', 'Price: Low to High'];

  // API Methods
  Future<void> fetchCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _courses = await _apiService.getCourses();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('Error loading courses in provider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Alias for loadCourses in case it's triggered by existing widgets
  Future<void> loadCourses() async {
    await fetchCourses();
  }

  // API Course Creation
  Future<bool> createCourse({
    required String courseTitle,
    required String instructor,
    required String category,
    required double price,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

  CourseManagementNotifier() {
    loadCourses();
  }

  Future<void> loadCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCourses();
      if (response.success) {
        _courses.clear();
        _courses.addAll(response.data.map((apiCourse) {
          return CourseItem(
            id: apiCourse.courseId,
            name: apiCourse.courseTitle,
            category: apiCourse.category ?? 'Materia Medica',
            instructor: apiCourse.instructor,
            duration: '32 Hours',
            price: '₹${apiCourse.price.toStringAsFixed(0)}',
            students: 0,
            rating: 5.0,
            status: 'Published',
            thumbnailIcon: Icons.menu_book_rounded,
            thumbnailBgColor: const Color(0xFF16A34A),
          );
        }));
      }
    } catch (e) {
      debugPrint('Error loading courses in CourseManagementNotifier: $e');

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CourseItem> get filteredCourses {
    return _courses.where((c) {
      final matchSearch = searchQuery.isEmpty ||
          c.courseTitle.toLowerCase().contains(searchQuery.toLowerCase()) ||
          c.instructor.toLowerCase().contains(searchQuery.toLowerCase());
      final matchCat = selectedCategory == 'All Categories' || c.category == selectedCategory;
      final matchInst = selectedInstructor == 'All Instructors' || c.instructor == selectedInstructor;

      return matchSearch && matchCat && matchInst;
    }).toList();
  }

  void setSearch(String val) { searchQuery = val; notifyListeners(); }
  void setCategory(String val) { selectedCategory = val; notifyListeners(); }
  void setInstructor(String val) { selectedInstructor = val; notifyListeners(); }
  void setStatus(String val) { selectedStatus = val; notifyListeners(); }
  void setLanguage(String val) { selectedLanguage = val; notifyListeners(); }
  void setSort(String val) { selectedSort = val; notifyListeners(); }

  void addCourse(CourseItem item) {
    _courses.insert(0, item);
    notifyListeners();
  }

  Future<void> updateCourse(CourseItem course) async {
    _isLoading = true;
    notifyListeners();

    try {
      final priceStr = course.price.replaceAll(RegExp(r'[^0-9.]'), '');
      final priceDouble = double.tryParse(priceStr) ?? 0.0;

      final response = await _apiService.updateCourse(
        courseId: course.id,
        courseTitle: course.name,
        instructor: course.instructor,
        price: priceDouble,
      );

      if (response.success) {
        final index = _courses.indexWhere((c) => c.id == course.id);
        if (index != -1) {
          _courses[index] = course;
        }
      }
    } catch (e) {
      debugPrint('Error updating course in CourseManagementNotifier: $e');
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
        _courses.removeWhere((c) => c.id == id);
      }
    } catch (e) {
      debugPrint('Error deleting course in CourseManagementNotifier: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCourseDetails(String courseId) async {
    _isLoading = true;
    selectedCourseData = null;
    notifyListeners();

    try {
      final course = await _apiService.getCourseDetail(courseId);
      final modules = await _apiService.getCourseModules(courseId);

      selectedCourseData = CourseDetailModel(
        course: course,
        modules: modules,
      );
    } catch (e) {
      debugPrint('Error fetching course details: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
