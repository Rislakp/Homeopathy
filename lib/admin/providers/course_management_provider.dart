import 'package:flutter/material.dart';
import 'package:homeopathy/admin/models/course_management_model.dart';

class CourseManagementNotifier extends ChangeNotifier {
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
  void addCourse(CourseItem item) { _courses.insert(0, item); notifyListeners(); }
  void deleteCourse(String id) { _courses.removeWhere((c) => c.id == id); notifyListeners(); }
}
