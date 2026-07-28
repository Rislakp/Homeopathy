import 'package:flutter/material.dart';
import '../models/student_model.dart';

class StudentProvider extends ChangeNotifier {
  List<StudentModel> _allStudents = [];
  List<StudentModel> _filteredStudents = [];
  bool _isLoading = false;

  // Filters State
  String _searchQuery = '';
  String _selectedCourse = 'All';
  String _selectedStatus = 'All';
  String _selectedSubscription = 'All';

  // Sorting State
  String _sortColumn = 'name'; // 'name', 'date', 'status'
  bool _sortAscending = true;

  // Pagination State
  int _currentPage = 1;
  int _rowsPerPage = 10;

  // Getters
  bool get isLoading => _isLoading;
  List<StudentModel> get students => _filteredStudents; // Visible/filtered students
  List<StudentModel> get filteredStudents => _filteredStudents; // Alias as requested

  String get searchQuery => _searchQuery;
  String get selectedCourse => _selectedCourse;
  String get selectedStatus => _selectedStatus;
  String get selectedSubscription => _selectedSubscription;

  String get sortColumn => _sortColumn;
  bool get sortAscending => _sortAscending;

  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;
  int get totalPages => (_filteredStudents.length / _rowsPerPage).ceil() == 0 ? 1 : (_filteredStudents.length / _rowsPerPage).ceil();

  // Paginated visible items
  List<StudentModel> get paginatedStudents {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    if (startIndex >= _filteredStudents.length) return [];
    final endIndex = startIndex + _rowsPerPage;
    return _filteredStudents.sublist(
      startIndex,
      endIndex > _filteredStudents.length ? _filteredStudents.length : endIndex,
    );
  }

  // CRUD Operations (Processed instantly)
  Future<void> addStudent(StudentModel student) async {
    final newStudent = student.id.isEmpty
        ? student.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString())
        : student;

    _allStudents.insert(0, newStudent);
    _applyFilters();
    notifyListeners();
  }

  Future<void> updateStudent(StudentModel student) async {
    final index = _allStudents.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _allStudents[index] = student;
    }
    _applyFilters();
    notifyListeners();
  }

  Future<void> deleteStudent(String id) async {
    _allStudents.removeWhere((s) => s.id == id);
    _applyFilters();
    notifyListeners();
  }

  // Search
  void searchStudents(String value) {
    _searchQuery = value;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  // Dropdown filter courses
  void filterCourse(String course) {
    _selectedCourse = course;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  // Dropdown filter status
  void filterStatus(String status) {
    _selectedStatus = status;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  // Dropdown filter subscription
  void filterSubscription(String subscription) {
    _selectedSubscription = subscription;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  // Sort methods
  void sortByName() {
    if (_sortColumn == 'name') {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumn = 'name';
      _sortAscending = true;
    }
    _applyFilters();
    notifyListeners();
  }

  void sortByDate() {
    if (_sortColumn == 'date') {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumn = 'date';
      _sortAscending = true;
    }
    _applyFilters();
    notifyListeners();
  }

  void sortByStatus() {
    if (_sortColumn == 'status') {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumn = 'status';
      _sortAscending = true;
    }
    _applyFilters();
    notifyListeners();
  }

  // Reset Filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCourse = 'All';
    _selectedStatus = 'All';
    _selectedSubscription = 'All';
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  // Pagination controls
  void setPage(int page) {
    if (page >= 1 && page <= totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < totalPages) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  void setRowsPerPage(int rows) {
    _rowsPerPage = rows;
    _currentPage = 1;
    notifyListeners();
  }

  // Private filter apply
  void _applyFilters() {
    List<StudentModel> result = List.from(_allStudents);

    // Search filter (Case-insensitive Name, Email, Phone)
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      result = result.where((s) {
        return s.name.toLowerCase().contains(query) ||
            s.email.toLowerCase().contains(query) ||
            s.phone.contains(query);
      }).toList();
    }

    // Course filter
    if (_selectedCourse != 'All') {
      result = result.where((s) => s.course == _selectedCourse).toList();
    }

    // Status filter
    if (_selectedStatus != 'All') {
      result = result.where((s) => s.status == _selectedStatus).toList();
    }

    // Subscription filter
    if (_selectedSubscription != 'All') {
      result = result.where((s) => s.subscription == _selectedSubscription).toList();
    }

    // Sort order application
    result.sort((a, b) {
      int comp = 0;
      if (_sortColumn == 'name') {
        comp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      } else if (_sortColumn == 'date') {
        comp = a.joinedDate.compareTo(b.joinedDate);
      } else if (_sortColumn == 'status') {
        comp = a.status.toLowerCase().compareTo(b.status.toLowerCase());
      }
      return _sortAscending ? comp : -comp;
    });

    _filteredStudents = result;

    if (_currentPage > totalPages) {
      _currentPage = totalPages;
    }
  }
}
