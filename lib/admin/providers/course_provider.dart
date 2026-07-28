// import 'package:flutter/material.dart';
// import '../models/course_model.dart';

// class CourseProvider extends ChangeNotifier {
//   String _searchQuery = '';
//   String _selectedCategory = 'All Categories';

//   String get searchQuery => _searchQuery;
//   String get selectedCategory => _selectedCategory;

//   final List<String> _categories = [
//     'All Categories',
//     'Homeopathy',
//     'Medicine',
//     'Clinical',
//     'Pharmacy',
//     'Exam Prep',
//   ];

//   List<String> get categories => _categories;

//   final List<CourseModel> _courses = [
//     const CourseModel(
//       id: 'CRS-101',
//       title: 'Classical Homeopathy Foundations',
//       teacherName: 'Dr. Samuel Hahnemann',
//       studentsCount: 1420,
//       price: '₹4,999',
//       status: 'Published',
//       category: 'Homeopathy',
//       iconData: Icons.medical_services_rounded,
//       gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
//     ),
//     const CourseModel(
//       id: 'CRS-102',
//       title: 'Advanced Materia Medica',
//       teacherName: 'Dr. James Tyler Kent',
//       studentsCount: 980,
//       price: '₹6,499',
//       status: 'Published',
//       category: 'Homeopathy',
//       iconData: Icons.menu_book_rounded,
//       gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
//     ),
//     const CourseModel(
//       id: 'CRS-103',
//       title: 'Repertory Mastery Program',
//       teacherName: 'Dr. William Boericke',
//       studentsCount: 1150,
//       price: '₹5,299',
//       status: 'Published',
//       category: 'Homeopathy',
//       iconData: Icons.auto_stories_rounded,
//       gradientColors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
//     ),
//     const CourseModel(
//       id: 'CRS-104',
//       title: 'Organon of Medicine',
//       teacherName: 'Dr. H.A. Roberts',
//       studentsCount: 840,
//       price: '₹3,999',
//       status: 'Published',
//       category: 'Homeopathy',
//       iconData: Icons.psychology_rounded,
//       gradientColors: [Color(0xFFF59E0B), Color(0xFFD97706)],
//     ),
//     const CourseModel(
//       id: 'CRS-105',
//       title: 'Pathology Essentials',
//       teacherName: 'Prof. Sarah Jenkins',
//       studentsCount: 620,
//       price: '₹4,499',
//       status: 'Draft',
//       category: 'Medicine',
//       iconData: Icons.biotech_rounded,
//       gradientColors: [Color(0xFFEC4899), Color(0xFFBE185D)],
//     ),
//     const CourseModel(
//       id: 'CRS-106',
//       title: 'Anatomy Complete',
//       teacherName: 'Dr. Robert Ford',
//       studentsCount: 1310,
//       price: '₹5,999',
//       status: 'Published',
//       category: 'Medicine',
//       iconData: Icons.accessibility_new_rounded,
//       gradientColors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
//     ),
//     const CourseModel(
//       id: 'CRS-107',
//       title: 'Physiology Crash Course',
//       teacherName: 'Dr. Elena Rostova',
//       studentsCount: 750,
//       price: '₹3,499',
//       status: 'Published',
//       category: 'Medicine',
//       iconData: Icons.favorite_rounded,
//       gradientColors: [Color(0xFF10B981), Color(0xFF047857)],
//     ),
//     const CourseModel(
//       id: 'CRS-108',
//       title: 'Pharmacology Revision',
//       teacherName: 'Dr. Marcus Vance',
//       studentsCount: 510,
//       price: '₹4,199',
//       status: 'Draft',
//       category: 'Pharmacy',
//       iconData: Icons.medication_rounded,
//       gradientColors: [Color(0xFFF97316), Color(0xFFC2410C)],
//     ),
//     const CourseModel(
//       id: 'CRS-109',
//       title: 'Clinical Case Discussions',
//       teacherName: 'Dr. Aris Thorne',
//       studentsCount: 1890,
//       price: '₹7,999',
//       status: 'Published',
//       category: 'Clinical',
//       iconData: Icons.local_hospital_rounded,
//       gradientColors: [Color(0xFF6366F1), Color(0xFF4338CA)],
//     ),
//     const CourseModel(
//       id: 'CRS-110',
//       title: 'AIAPGET Test Series',
//       teacherName: 'WCA Faculty Team',
//       studentsCount: 2450,
//       price: '₹2,999',
//       status: 'Published',
//       category: 'Exam Prep',
//       iconData: Icons.quiz_rounded,
//       gradientColors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
//     ),
//     const CourseModel(
//       id: 'CRS-111',
//       title: 'Homeopathic Pharmacy',
//       teacherName: 'Dr. Clara Oswald',
//       studentsCount: 680,
//       price: '₹3,899',
//       status: 'Published',
//       category: 'Pharmacy',
//       iconData: Icons.science_rounded,
//       gradientColors: [Color(0xFF84CC16), Color(0xFF4D7C0F)],
//     ),
//     const CourseModel(
//       id: 'CRS-112',
//       title: 'Research Methodology',
//       teacherName: 'Dr. Arthur Pendelton',
//       studentsCount: 430,
//       price: '₹4,799',
//       status: 'Draft',
//       category: 'Clinical',
//       iconData: Icons.analytics_rounded,
//       gradientColors: [Color(0xFF64748B), Color(0xFF334155)],
//     ),
//   ];

//   List<CourseModel> get filteredCourses {
//     return _courses.where((course) {
//       final matchesQuery = _searchQuery.isEmpty ||
//           course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           course.teacherName.toLowerCase().contains(_searchQuery.toLowerCase());
//       final matchesCategory = _selectedCategory == 'All Categories' ||
//           course.category == _selectedCategory;
//       return matchesQuery && matchesCategory;
//     }).toList();
//   }

//   void setSearchQuery(String query) {
//     _searchQuery = query;
//     notifyListeners();
//   }

//   void setSelectedCategory(String category) {
//     _selectedCategory = category;
//     notifyListeners();
//   }

//   void addCourse(CourseModel course) {
//     _courses.insert(0, course);
//     notifyListeners();
//   }

//   void updateCourse(CourseModel updated) {
//     final index = _courses.indexWhere((c) => c.id == updated.id);
//     if (index != -1) {
//       _courses[index] = updated;
//       notifyListeners();
//     }
//   }

//   void deleteCourse(String id) {
//     _courses.removeWhere((c) => c.id == id);
//     notifyListeners();
//   }
// }
