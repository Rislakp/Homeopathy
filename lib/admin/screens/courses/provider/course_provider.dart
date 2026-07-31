import 'package:flutter/material.dart';

import '../model/course_model.dart';


class CourseProvider extends ChangeNotifier {
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

    // 600ms network delay simulation
    await Future.delayed(const Duration(milliseconds: 600));

    _allCourses = [
      const CourseModel(
        id: '1',
        title: 'Classical Homeopathy Foundations',
        instructor: 'Dr. Samuel Hahnemann',
        category: 'Materia Medica',
        price: 4999,
        students: 120,
        status: 'Published',
        description: 'Explore the primary principles of homeotherapy, including similia similibus curentur, single remedy, and minimum dose.',
        image: 'menu_book',
      ),
      const CourseModel(
        id: '2',
        title: 'Advanced Materia Medica',
        instructor: 'Dr. J. T. Kent',
        category: 'Materia Medica',
        price: 6499,
        students: 85,
        status: 'Published',
        description: 'Deep dive into Kentian constitutional profiles, drug provings, and comparative study of polychrests.',
        image: 'auto_stories',
      ),
      const CourseModel(
        id: '3',
        title: 'Repertory Mastery Program',
        instructor: 'Dr. Boenninghausen',
        category: 'Repertory',
        price: 5299,
        students: 95,
        status: 'Published',
        description: 'Learn case analysis, rubric selection, and comparative study of Kent, Boenninghausen, and Boger repertories.',
        image: 'troubleshoot',
      ),
      const CourseModel(
        id: '4',
        title: 'Organon Essentials',
        instructor: 'Dr. Samuel Hahnemann',
        category: 'Organon',
        price: 3999,
        students: 110,
        status: 'Published',
        description: 'Chronological analysis of Samuel Hahnemann\'s Organon of Medicine (Aphorisms 1 to 291) covering logic and philosophy.',
        image: 'history_edu',
      ),
      const CourseModel(
        id: '5',
        title: 'Anatomy Complete',
        instructor: 'Dr. Henry Gray',
        category: 'Anatomy',
        price: 4599,
        students: 150,
        status: 'Published',
        description: 'Comprehensive gross anatomy module covering osteology, myology, neurology, and clinical correlation.',
        image: 'accessibility',
      ),
      const CourseModel(
        id: '6',
        title: 'Physiology Masterclass',
        instructor: 'Dr. Arthur Guyton',
        category: 'Physiology',
        price: 4799,
        students: 140,
        status: 'Draft',
        description: 'Understand molecular, cellular, systemic human organ actions, and homeostatic regulation loops.',
        image: 'favorite',
      ),
      const CourseModel(
        id: '7',
        title: 'Pathology Basics',
        instructor: 'Dr. William Boyd',
        category: 'Pathology',
        price: 4299,
        students: 60,
        status: 'Published',
        description: 'Introduction to general pathognomonic processes, cell injury, inflammation, hemodynamic disorders, and neoplasia.',
        image: 'biotech',
      ),
      const CourseModel(
        id: '8',
        title: 'Community Medicine',
        instructor: 'Dr. K. Park',
        category: 'Physiology',
        price: 3499,
        students: 45,
        status: 'Published',
        description: 'Epidemiological studies, preventive medicine protocols, health policies, environmental sanitation, and demography.',
        image: 'groups',
      ),
      const CourseModel(
        id: '9',
        title: 'Pharmacology',
        instructor: 'Dr. Burt Kent',
        category: 'Materia Medica',
        price: 3899,
        students: 75,
        status: 'Published',
        description: 'Understanding pharmacodynamics, pharmacokinetics, adverse effects, and comparative dosing guidelines.',
        image: 'vaccines',
      ),
      const CourseModel(
        id: '10',
        title: 'Practice of Medicine',
        instructor: 'Dr. T. Harrison',
        category: 'Repertory',
        price: 5999,
        students: 130,
        status: 'Published',
        description: 'Diagnostic criteria, systemic clinical symptoms, physical examinations, and holistic case formulations.',
        image: 'local_hospital',
      ),
      const CourseModel(
        id: '11',
        title: 'Surgery',
        instructor: 'Dr. Hamilton Bailey',
        category: 'Anatomy',
        price: 6999,
        students: 50,
        status: 'Archived',
        description: 'Surgical pathology, pre/post-operative patient monitoring guidelines, suturing basics, and emergency setups.',
        image: 'content_cut',
      ),
      const CourseModel(
        id: '12',
        title: 'Forensic Medicine',
        instructor: 'Dr. K. S. Reddy',
        category: 'Pathology',
        price: 3299,
        students: 40,
        status: 'Published',
        description: 'Medical jurisprudence, postmortem investigations, toxicology assays, legal evidence documentation rules.',
        image: 'gavel',
      ),
    ];

    _isLoading = false;
    _applyFilters();
    notifyListeners();
  }

  // CRUD Operations
  Future<void> addCourse(CourseModel course) async {
    final newCourse = course.id.isEmpty
        ? course.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString())
        : course;
    _allCourses.insert(0, newCourse);
    _applyFilters();
    notifyListeners();
  }

  Future<void> updateCourse(CourseModel course) async {
    final index = _allCourses.indexWhere((c) => c.id == course.id);
    if (index != -1) {
      _allCourses[index] = course;
    }
    _applyFilters();
    notifyListeners();
  }

  Future<void> deleteCourse(String id) async {
    _allCourses.removeWhere((c) => c.id == id);
    _applyFilters();
    notifyListeners();
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