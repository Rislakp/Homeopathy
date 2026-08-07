import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/courses/model/course_model.dart';
import 'package:homeopathy/services/course_api_service.dart';

class CourseManagementNotifier extends ChangeNotifier {
  final CourseApiService _apiService = CourseApiService();

  List<CourseModel> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;

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

    try {
      final newCourse = await _apiService.createCourse(
        courseTitle: courseTitle,
        instructor: instructor,
        category: category,
        price: price,
      );
      _courses.insert(0, newCourse);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CourseModel> get filteredCourses {
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

  // API Mock CRUD fallback
  void addCourse(CourseModel item) {
    _courses.insert(0, item);
    notifyListeners();
  }

  void deleteCourse(String id) {
    _courses.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
class ActivityLog {
  final String text;
  final String time;
  final IconData icon;

  const ActivityLog({
    required this.text,
    required this.time,
    required this.icon,
  });
}
