import 'package:flutter/foundation.dart';
import 'package:homeopathy/model/course_model.dart';


// CourseProvider holds all the course data and exposes it to the UI.
// Any widget wrapped in a Consumer<CourseProvider> (or using context.watch)
// will automatically rebuild whenever notifyListeners() is called.
class CourseProvider extends ChangeNotifier {
  // Hard-coded sample data, just like the screenshot we're recreating.
  final List<Course> _courses = const [
    Course(
      instructor: 'Dr. Anjali Menon',
      title: 'AIAPGET 2026 — Complete Preparation',
      duration: '9 months',
      studentsCount: '12,480',
      rating: 4.9,
      ratingCount: 2140,
      price: 14999,
      originalPrice: 24999,
      discountPercent: 40,
      tag: 'BESTSELLER',
    ),
    Course(
      instructor: 'Dr. Rakesh Iyer',
      title: 'NEET PG Homeopathy Foundation',
      duration: '6 months',
      studentsCount: '8,920',
      rating: 4.8,
      ratingCount: 1580,
      price: 9999,
      originalPrice: 16999,
      discountPercent: 41,
      tag: 'NEW BATCH',
      hasVideoPreview: true,
    ),
    Course(
      instructor: 'Dr. Priya Sharma',
      title: 'Organon of Medicine — Deep Dive',
      duration: '3 months',
      studentsCount: '6,340',
      rating: 4.9,
      ratingCount: 980,
      price: 4999,
      originalPrice: 7999,
      discountPercent: 38,
      tag: 'TRENDING',
    ),
  ];

  // Read-only access for the UI layer.
  List<Course> get courses => _courses;

  // Example of an action a beginner project might add later:
  // enrolling in a course. Kept simple on purpose.
  final Set<String> _enrolledTitles = {};

  bool isEnrolled(Course course) => _enrolledTitles.contains(course.title);

  void enroll(Course course) {
    _enrolledTitles.add(course.title);
    notifyListeners(); // tells every listening widget to rebuild
  }
}