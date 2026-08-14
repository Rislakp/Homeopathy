import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../admin/screens/students/model/student_model.dart';

/// Service for handling API calls related to Students in the Admin Dashboard.
class StudentApiService {
  static String get _adminStudentsUrl => ApiConstants.adminStudents;

  /// Helper to get request headers with Bearer token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('admin_token') ?? prefs.getString('auth_token') ?? '';

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetches a paginated/filtered list of students from the backend API.
  Future<List<StudentModel>> fetchStudents({
    int page = 1,
    int limit = 50,
    String? search,
    String? course,
    String? status,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    if (course != null && course.trim().isNotEmpty && course != 'All Courses') {
      queryParams['course'] = course.trim();
    }

    if (status != null && status.trim().isNotEmpty && status != 'All Status') {
      queryParams['status'] = status.trim();
    }

    final baseUri = Uri.parse(_adminStudentsUrl);
    final url = Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
      path: baseUri.path,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    debugPrint('API URL (GET Students): $url');

    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      debugPrint('STATUS (GET Students): ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        List<dynamic> studentList = [];
        if (responseData['data'] != null) {
          if (responseData['data'] is Map<String, dynamic> &&
              responseData['data']['students'] is List) {
            studentList = responseData['data']['students'] as List<dynamic>;
          } else if (responseData['data'] is List) {
            studentList = responseData['data'] as List<dynamic>;
          }
        } else if (responseData['students'] is List) {
          studentList = responseData['students'] as List<dynamic>;
        }

        return studentList
            .map((jsonItem) => StudentModel.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
      } else {
        String errorMessage = 'Failed to load students (Status: ${response.statusCode})';
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in fetchStudents: $e');
      rethrow;
    }
  }

  /// Fetches detailed information for a single student by their ID.
  Future<StudentModel> fetchStudentById(String id) async {
    final url = Uri.parse(ApiConstants.studentById(id));

    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final dynamic studentJson = responseData['data'] ?? responseData['student'] ?? responseData;
        return StudentModel.fromJson(studentJson as Map<String, dynamic>);
      } else {
        String errorMessage = 'Failed to fetch student details (${response.statusCode})';
        try {
          final Map<String, dynamic> err = json.decode(response.body);
          errorMessage = err['message'] ?? errorMessage;
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in fetchStudentById: $e');
      rethrow;
    }
  }

  /// Admin updates user role (e.g. 'student' <-> 'admin')
  Future<bool> updateUserRole(String userId, String newRole) async {
    final url = Uri.parse(ApiConstants.userRoleUpdate(userId));

    try {
      final headers = await _getHeaders();
      final response = await http.patch(
        url,
        headers: headers,
        body: json.encode({'role': newRole}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final Map<String, dynamic> err = json.decode(response.body);
        throw Exception(err['message'] ?? 'Failed to update user role');
      }
    } catch (e) {
      debugPrint('Error in updateUserRole: $e');
      rethrow;
    }
  }
}
