import 'package:flutter/material.dart';
import '../model/student_model.dart';

class StudentProvider extends ChangeNotifier {
  // Master list of students
  final List<StudentModel> _allStudents = [];

  // Filter criteria
  String _searchQuery = '';
  String _selectedCourse = 'All Courses';
  String _selectedStatus = 'All Status';

  // Getters for filters
  String get searchQuery => _searchQuery;
  String get selectedCourse => _selectedCourse;
  String get selectedStatus => _selectedStatus;

  StudentProvider() {
    _loadDummyData();
  }

  // Load 12 dummy students
  void _loadDummyData() {
    _allStudents.addAll([
      StudentModel(
        id: '1',
        name: 'Amit Sharma',
        email: 'amit.sharma@example.com',
        phone: '+91 98765 43210',
        course: 'Classical Homeopathy',
        subscription: 'Yearly',
        status: 'Active',
        avatarText: 'AS',
      ),
      StudentModel(
        id: '2',
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        phone: '+1 555-0199',
        course: 'Materia Medica',
        subscription: 'Monthly',
        status: 'Trial',
        avatarText: 'JS',
      ),
      StudentModel(
        id: '3',
        name: 'Carlos Ruiz',
        email: 'carlos.ruiz@example.com',
        phone: '+34 612 345 678',
        course: 'Repertory',
        subscription: 'Quarterly',
        status: 'Active',
        avatarText: 'CR',
      ),
      StudentModel(
        id: '4',
        name: 'Aisha Patel',
        email: 'aisha.patel@example.com',
        phone: '+91 91234 56789',
        course: 'Organon',
        subscription: 'Half Yearly',
        status: 'Expired',
        avatarText: 'AP',
      ),
      StudentModel(
        id: '5',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1 555-0144',
        course: 'Pharmacy',
        subscription: 'Trial',
        status: 'Trial',
        avatarText: 'JD',
      ),
      StudentModel(
        id: '6',
        name: 'Elena Petrova',
        email: 'elena.petrova@example.com',
        phone: '+7 912 345-67-89',
        course: 'Anatomy',
        subscription: 'Yearly',
        status: 'Inactive',
        avatarText: 'EP',
      ),
      StudentModel(
        id: '7',
        name: 'Kwame Mensah',
        email: 'kwame.mensah@example.com',
        phone: '+233 24 123 4567',
        course: 'Physiology',
        subscription: 'Monthly',
        status: 'Active',
        avatarText: 'KM',
      ),
      StudentModel(
        id: '8',
        name: 'Yuki Tanaka',
        email: 'yuki.tanaka@example.com',
        phone: '+81 90-1234-5678',
        course: 'Pathology',
        subscription: 'Half Yearly',
        status: 'Active',
        avatarText: 'YT',
      ),
      StudentModel(
        id: '9',
        name: 'David Miller',
        email: 'david.miller@example.com',
        phone: '+44 7911 123456',
        course: 'Classical Homeopathy',
        subscription: 'Yearly',
        status: 'Expired',
        avatarText: 'DM',
      ),
      StudentModel(
        id: '10',
        name: 'Fatima Al-Sayed',
        email: 'fatima.alsayed@example.com',
        phone: '+971 50 123 4567',
        course: 'Materia Medica',
        subscription: 'Monthly',
        status: 'Inactive',
        avatarText: 'FA',
      ),
      StudentModel(
        id: '11',
        name: 'William Brown',
        email: 'william.brown@example.com',
        phone: '+1 555-0177',
        course: 'Repertory',
        subscription: 'Quarterly',
        status: 'Active',
        avatarText: 'WB',
      ),
      StudentModel(
        id: '12',
        name: 'Sophie Dubois',
        email: 'sophie.dubois@example.com',
        phone: '+33 6 1234 5678',
        course: 'Organon',
        subscription: 'Trial',
        status: 'Trial',
        avatarText: 'SD',
      ),
    ]);
  }

  // Get filtered list of students
  List<StudentModel> get students {
    return _allStudents.where((student) {
      final matchesSearch = _searchQuery.isEmpty ||
          student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.phone.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.course.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCourse = _selectedCourse == 'All Courses' ||
          student.course == _selectedCourse;

      final matchesStatus = _selectedStatus == 'All Status' ||
          student.status == _selectedStatus;

      return matchesSearch && matchesCourse && matchesStatus;
    }).toList();
  }

  // Filter and search modifiers
  void searchStudents(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterCourse(String course) {
    _selectedCourse = course;
    notifyListeners();
  }

  void filterStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void addStudent(StudentModel student) {
    _allStudents.add(student);
    notifyListeners();
  }

  void editStudent(StudentModel updatedStudent) {
    final index = _allStudents.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      _allStudents[index] = updatedStudent;
      notifyListeners();
    }
  }

  void deleteStudent(String id) {
    _allStudents.removeWhere((student) => student.id == id);
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCourse = 'All Courses';
    _selectedStatus = 'All Status';
    notifyListeners();
  }
}
