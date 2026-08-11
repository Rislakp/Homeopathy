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
  void deleteCourse(String id) {
    _courses.removeWhere((c) => c.id == id);
    if (selectedCourseData?.id == id) {
      selectedCourseData = null;
    }
    notifyListeners();
  }

  CourseDetailModel? selectedCourseData;
  List<VersionHistoryItem> versionHistory = [];
  bool isLoading = false;

  Future<void> fetchCourseDetails(String courseId) async {
    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final modules = [
        const ModuleDetailModel(
          id: 'MOD-01',
          title: 'Module 1 - Introduction to Homeopathy Principles',
          lessons: [
            LessonDetailModel(
              id: 'LES-101',
              title: 'Welcome & Course Overview',
              subtitle: 'Recorded Video • 14:20',
              type: LessonType.video,
              status: 'Published',
              isLocked: false,
            ),
            LessonDetailModel(
              id: 'LES-102',
              title: 'History of Dr. Samuel Hahnemann',
              subtitle: 'PDF Document • 4.5 MB',
              type: LessonType.file,
              status: 'Published',
              isLocked: false,
            ),
            LessonDetailModel(
              id: 'LES-103',
              title: 'Live Q&A foundational concepts',
              subtitle: 'Live Session • Aug 15, 2:00 PM',
              type: LessonType.live,
              status: 'Draft',
              isLocked: true,
            ),
          ],
        ),
        const ModuleDetailModel(
          id: 'MOD-02',
          title: 'Module 2 - Vital Force & Law of Similars',
          lessons: [
            LessonDetailModel(
              id: 'LES-201',
              title: 'Understanding the Law of Similars',
              subtitle: 'Recorded Video • 35 mins',
              type: LessonType.video,
              status: 'Published',
              isLocked: false,
            ),
          ],
        ),
      ];

      final existing = _courses.firstWhere((c) => c.id == courseId, orElse: () => _courses.first);

      selectedCourseData = CourseDetailModel(
        id: existing.id,
        title: existing.name,
        description: 'Master the fundamental laws, concepts of Vital Force, Potentization, and chronic disease theory in classical homeopathic medicine. Designed for advanced clinical practice.',
        instructor: existing.instructor,
        duration: existing.duration,
        students: existing.students,
        price: existing.price,
        status: existing.status,
        isBestseller: existing.id == 'WCA-01',
        modules: modules,
      );

      versionHistory = [
        const VersionHistoryItem(
          id: 'V-1',
          action: 'Replaced lesson video for "Understanding the Law of Similars"',
          author: 'Dr. Renu Sharma',
          timestamp: '2 hours ago',
        ),
        const VersionHistoryItem(
          id: 'V-2',
          action: 'Updated lesson description and metadata for Module 1 overview',
          author: 'Admin Support',
          timestamp: '1 day ago',
        ),
      ];
    } catch (e) {
      debugPrint('Error fetching details: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateCourseStatus(String courseId, String status) {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      final old = _courses[index];
      _courses[index] = CourseItem(
        id: old.id,
        name: old.name,
        category: old.category,
        instructor: old.instructor,
        duration: old.duration,
        price: old.price,
        students: old.students,
        rating: old.rating,
        status: status,
        language: old.language,
        thumbnailIcon: old.thumbnailIcon,
        thumbnailBgColor: old.thumbnailBgColor,
      );
    }
    if (selectedCourseData != null && selectedCourseData!.id == courseId) {
      selectedCourseData = CourseDetailModel(
        id: selectedCourseData!.id,
        title: selectedCourseData!.title,
        description: selectedCourseData!.description,
        instructor: selectedCourseData!.instructor,
        duration: selectedCourseData!.duration,
        students: selectedCourseData!.students,
        price: selectedCourseData!.price,
        status: status,
        isBestseller: selectedCourseData!.isBestseller,
        modules: selectedCourseData!.modules,
      );
    }
    notifyListeners();
  }

  void addLesson(String moduleId, LessonDetailModel lesson) {
    if (selectedCourseData == null) return;
    final updatedModules = selectedCourseData!.modules.map((m) {
      if (m.id == moduleId) {
        return ModuleDetailModel(
          id: m.id,
          title: m.title,
          lessons: List<LessonDetailModel>.from(m.lessons)..add(lesson),
        );
      }
      return m;
    }).toList();
    selectedCourseData = CourseDetailModel(
      id: selectedCourseData!.id,
      title: selectedCourseData!.title,
      description: selectedCourseData!.description,
      instructor: selectedCourseData!.instructor,
      duration: selectedCourseData!.duration,
      students: selectedCourseData!.students,
      price: selectedCourseData!.price,
      status: selectedCourseData!.status,
      isBestseller: selectedCourseData!.isBestseller,
      modules: updatedModules,
    );
    versionHistory.insert(
      0,
      VersionHistoryItem(
        id: 'V-${DateTime.now().millisecondsSinceEpoch}',
        action: 'Added lesson "${lesson.title}"',
        author: 'Dr. Renu Sharma',
        timestamp: 'Just now',
      ),
    );
    notifyListeners();
  }

  void deleteLesson(String moduleId, String lessonId) {
    if (selectedCourseData == null) return;
    final updatedModules = selectedCourseData!.modules.map((m) {
      if (m.id == moduleId) {
        return ModuleDetailModel(
          id: m.id,
          title: m.title,
          lessons: List<LessonDetailModel>.from(m.lessons)..removeWhere((l) => l.id == lessonId),
        );
      }
      return m;
    }).toList();
    selectedCourseData = CourseDetailModel(
      id: selectedCourseData!.id,
      title: selectedCourseData!.title,
      description: selectedCourseData!.description,
      instructor: selectedCourseData!.instructor,
      duration: selectedCourseData!.duration,
      students: selectedCourseData!.students,
      price: selectedCourseData!.price,
      status: selectedCourseData!.status,
      isBestseller: selectedCourseData!.isBestseller,
      modules: updatedModules,
    );
    versionHistory.insert(
      0,
      VersionHistoryItem(
        id: 'V-${DateTime.now().millisecondsSinceEpoch}',
        action: 'Deleted a lesson from module',
        author: 'Dr. Renu Sharma',
        timestamp: 'Just now',
      ),
    );
    notifyListeners();
  }
}
