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

  final List<CourseItem> _courses = [
    const CourseItem(
      id: 'WCA-01',
      name: 'Advanced Materia Medica',
      category: 'Materia Medica',
      instructor: 'Dr. Renu Sharma',
      duration: '32 Hours',
      price: '₹2,499',
      students: 425,
      rating: 4.9,
      status: 'Published',
      thumbnailIcon: Icons.menu_book_rounded,
      thumbnailBgColor: Color(0xFF16A34A),
    ),
    const CourseItem(
      id: 'WCA-02',
      name: 'Organon of Medicine',
      category: 'Organon',
      instructor: 'Dr. Arjun',
      duration: '28 Hours',
      price: '₹1,999',
      students: 312,
      rating: 4.8,
      status: 'Published',
      thumbnailIcon: Icons.psychology_rounded,
      thumbnailBgColor: Color(0xFF2563EB),
    ),
    const CourseItem(
      id: 'WCA-03',
      name: 'Homeopathic Pharmacy',
      category: 'Pharmacy',
      instructor: 'Dr. Meera',
      duration: '18 Hours',
      price: '₹999',
      students: 208,
      rating: 4.6,
      status: 'Draft',
      thumbnailIcon: Icons.science_rounded,
      thumbnailBgColor: Color(0xFFD97706),
    ),
    const CourseItem(
      id: 'WCA-04',
      name: 'Case Studies & Therapeutics',
      category: 'Clinical',
      instructor: 'Dr. Ahmed',
      duration: '40 Hours',
      price: '₹2,999',
      students: 520,
      rating: 4.9,
      status: 'Published',
      thumbnailIcon: Icons.medical_services_rounded,
      thumbnailBgColor: Color(0xFF9333EA),
    ),
  ];

  final List<ActivityLog> activities = const [
    ActivityLog(text: 'New course "Advanced Materia Medica" added', time: '12 mins ago', icon: Icons.add_circle_outline_rounded),
    ActivityLog(text: 'Course "Organon of Medicine" updated', time: '1 hour ago', icon: Icons.edit_note_rounded),
    ActivityLog(text: 'Draft "Homeopathic Pharmacy" awaiting approval', time: '3 hours ago', icon: Icons.pending_actions_rounded),
    ActivityLog(text: 'New instructor Dr. Ahmed assigned', time: '5 hours ago', icon: Icons.person_add_alt_1_rounded),
  ];

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
          c.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          c.instructor.toLowerCase().contains(searchQuery.toLowerCase());
      final matchCat = selectedCategory == 'All Categories' || c.category == selectedCategory;
      final matchInst = selectedInstructor == 'All Instructors' || c.instructor == selectedInstructor;
      final matchStatus = selectedStatus == 'All Status' || c.status == selectedStatus;
      final matchLang = selectedLanguage == 'All Languages' || c.language == selectedLanguage;

      return matchSearch && matchCat && matchInst && matchStatus && matchLang;
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
