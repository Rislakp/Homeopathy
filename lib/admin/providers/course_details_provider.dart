import 'package:flutter/material.dart';
import '../models/course_details_model.dart';

class CourseDetailsProvider extends ChangeNotifier {
  bool _isLoading = false;
  CourseDetail? _courseData;
  List<VersionHistoryItem> _versionHistory = [];

  bool get isLoading => _isLoading;
  CourseDetail? get courseData => _courseData;
  List<VersionHistoryItem> get versionHistory => _versionHistory;

  // Placeholder for future API/Service injection if needed.
  // final CourseApiService _apiService = CourseApiService();

  // 1. FETCH COURSE DETAILS (with rich initial mock data)
  Future<void> fetchCourseDetails(String courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network request delay
      await Future.delayed(const Duration(milliseconds: 600));

      // Build initial modules & lessons
      final modules = [
        const ModuleDetail(
          id: 'MOD-01',
          title: 'Module 1 - Introduction to Homeopathy Principles',
          lessons: [
            LessonDetail(
              id: 'LES-101',
              title: 'Welcome & Course Overview',
              subtitle: 'Video • 12 mins',
              type: LessonType.video,
              status: 'Published',
              isLocked: false,
            ),
            LessonDetail(
              id: 'LES-102',
              title: 'History of Dr. Samuel Hahnemann',
              subtitle: 'PDF Document • 4.5 MB',
              type: LessonType.pdf,
              status: 'Published',
              isLocked: false,
            ),
            LessonDetail(
              id: 'LES-103',
              title: 'Live Q&A: Foundational Concepts',
              subtitle: 'Live Session • Aug 15, 2:00 PM',
              type: LessonType.live,
              status: 'Draft',
              isLocked: true,
            ),
          ],
        ),
        const ModuleDetail(
          id: 'MOD-02',
          title: 'Module 2 - The Law of Similars & Vital Force',
          lessons: [
            LessonDetail(
              id: 'LES-201',
              title: 'Understanding the Law of Similars',
              subtitle: 'Video • 35 mins',
              type: LessonType.video,
              status: 'Published',
              isLocked: false,
            ),
            LessonDetail(
              id: 'LES-202',
              title: 'Vital Force Concept Deep-dive',
              subtitle: 'Video • 42 mins',
              type: LessonType.video,
              status: 'Published',
              isLocked: false,
            ),
            LessonDetail(
              id: 'LES-203',
              title: 'Self-Assessment: Principles Test',
              subtitle: 'PDF Document • 1.2 MB',
              type: LessonType.pdf,
              status: 'Published',
              isLocked: false,
            ),
          ],
        ),
        const ModuleDetail(
          id: 'MOD-03',
          title: 'Module 3 - Chronic Miasms & Disease Theory',
          lessons: [
            LessonDetail(
              id: 'LES-301',
              title: 'Introduction to Miasmatic Diagnosis',
              subtitle: 'Video • 28 mins',
              type: LessonType.video,
              status: 'Published',
              isLocked: false,
            ),
            LessonDetail(
              id: 'LES-302',
              title: 'Psora, Sycosis & Syphilis Miasms',
              subtitle: 'Live Session • Aug 22, 4:00 PM',
              type: LessonType.live,
              status: 'Draft',
              isLocked: true,
            ),
          ],
        ),
      ];

      _courseData = CourseDetail(
        id: '64e5c7a912ab34cd56ef7890', // internal mongodb id style
        courseId: courseId.isNotEmpty ? courseId : 'CRS-000412',
        title: 'Classical Homeopathy Foundations',
        description: 'Master the fundamental laws, concepts of Vital Force, Potentization, and chronic disease theory in classical homeopathic medicine. Designed for advanced clinical practice.',
        instructorName: 'Dr. Renu Sharma',
        instructorAvatar: 'DR',
        duration: '32 Hours',
        students: 425,
        price: 2499.00,
        status: 'Published',
        isBestseller: true,
        category: 'Materia Medica',
        modules: modules,
      );

      // Build initial mock version history
      _versionHistory = [
        const VersionHistoryItem(
          id: 'V-001',
          action: 'Replaced lesson video for "Understanding the Law of Similars"',
          author: 'Dr. Renu Sharma',
          timestamp: '2 hours ago',
        ),
        const VersionHistoryItem(
          id: 'V-002',
          action: 'Updated lesson description and metadata for Module 1 overview',
          author: 'Admin Support',
          timestamp: '1 day ago',
        ),
        const VersionHistoryItem(
          id: 'V-003',
          action: 'Added PDF document "History of Dr. Samuel Hahnemann"',
          author: 'Dr. Renu Sharma',
          timestamp: '3 days ago',
        ),
        const VersionHistoryItem(
          id: 'V-004',
          action: 'Created course shell and initialized curriculum draft',
          author: 'Admin Support',
          timestamp: '1 week ago',
        ),
      ];
    } catch (e) {
      debugPrint('Error fetching course details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. DELETE COURSE
  Future<bool> deleteCourse(String courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API deletion call
      await Future.delayed(const Duration(seconds: 1));
      
      _courseData = null;
      _versionHistory.clear();
      debugPrint('Course $courseId successfully deleted from database.');
      return true;
    } catch (e) {
      debugPrint('Error deleting course $courseId: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. UPDATE COURSE STATUS
  Future<void> updateCourseStatus(String courseId, String status) async {
    if (_courseData == null || _courseData!.courseId != courseId) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate patch request delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      _courseData = _courseData!.copyWith(status: status);

      // Add to version history
      _versionHistory.insert(
        0,
        VersionHistoryItem(
          id: 'V-${DateTime.now().millisecondsSinceEpoch}',
          action: 'Changed course status to "$status"',
          author: 'Super Admin',
          timestamp: 'Just now',
        ),
      );
    } catch (e) {
      debugPrint('Error updating status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. ADD LESSON TO MODULE
  Future<void> addLesson(String moduleId, LessonDetail lesson) async {
    if (_courseData == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API post call delay
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedModules = _courseData!.modules.map((module) {
        if (module.id == moduleId) {
          final updatedLessons = List<LessonDetail>.from(module.lessons)..add(lesson);
          return module.copyWith(lessons: updatedLessons);
        }
        return module;
      }).toList();

      _courseData = _courseData!.copyWith(modules: updatedModules);

      // Add to version history
      _versionHistory.insert(
        0,
        VersionHistoryItem(
          id: 'V-${DateTime.now().millisecondsSinceEpoch}',
          action: 'Added lesson "${lesson.title}" to module',
          author: 'Dr. Renu Sharma',
          timestamp: 'Just now',
        ),
      );
    } catch (e) {
      debugPrint('Error adding lesson: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 5. DELETE LESSON FROM MODULE
  Future<void> deleteLesson(String moduleId, String lessonId) async {
    if (_courseData == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedModules = _courseData!.modules.map((module) {
        if (module.id == moduleId) {
          final updatedLessons = List<LessonDetail>.from(module.lessons)
            ..removeWhere((l) => l.id == lessonId);
          return module.copyWith(lessons: updatedLessons);
        }
        return module;
      }).toList();

      _courseData = _courseData!.copyWith(modules: updatedModules);

      // Add to version history
      _versionHistory.insert(
        0,
        VersionHistoryItem(
          id: 'V-${DateTime.now().millisecondsSinceEpoch}',
          action: 'Deleted a lesson from module',
          author: 'Dr. Renu Sharma',
          timestamp: 'Just now',
        ),
      );
    } catch (e) {
      debugPrint('Error deleting lesson: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
