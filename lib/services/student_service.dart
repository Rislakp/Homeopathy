import 'dart:async';
import '../models/student_model.dart';
import '../utils/app_constants.dart';

class StudentService {
  // In-memory list to act as local database
  final List<StudentModel> _localDb = AppConstants.getSeedStudents();

  // Simulated latency
  static const Duration _delay = Duration(milliseconds: 600);

  Future<List<StudentModel>> fetchStudents() async {
    await Future.delayed(_delay);
    // Return a copy to ensure immutability is maintained
    return List.unmodifiable(_localDb);
  }

  Future<StudentModel> createStudent(StudentModel student) async {
    await Future.delayed(_delay);
    
    // Auto-generate ID if empty
    final newStudent = student.id.isEmpty
        ? student.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString())
        : student;

    // Check duplicate email or phone (just in case)
    if (_localDb.any((s) => s.email.toLowerCase() == newStudent.email.toLowerCase())) {
      throw Exception('A student with this email address already exists.');
    }
    if (_localDb.any((s) => s.phone == newStudent.phone)) {
      throw Exception('A student with this phone number already exists.');
    }

    _localDb.insert(0, newStudent);
    return newStudent;
  }

  Future<StudentModel> updateStudent(StudentModel student) async {
    await Future.delayed(_delay);
    final index = _localDb.indexWhere((s) => s.id == student.id);
    if (index == -1) {
      throw Exception('Student not found.');
    }

    // Duplicate check excluding self
    if (_localDb.any((s) => s.id != student.id && s.email.toLowerCase() == student.email.toLowerCase())) {
      throw Exception('A student with this email address already exists.');
    }
    if (_localDb.any((s) => s.id != student.id && s.phone == student.phone)) {
      throw Exception('A student with this phone number already exists.');
    }

    _localDb[index] = student;
    return student;
  }

  Future<bool> deleteStudent(String id) async {
    await Future.delayed(_delay);
    final index = _localDb.indexWhere((s) => s.id == id);
    if (index == -1) {
      return false;
    }
    _localDb.removeAt(index);
    return true;
  }
}
