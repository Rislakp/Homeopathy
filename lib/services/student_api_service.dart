import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../admin/screens/students/model/student_model.dart';

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'Session expired. Please log in again.']);
  @override
  String toString() => message;
}

class StudentApiService {
  static String get _adminStudentsUrl => ApiConstants.adminStudents;

  Future<Map<String, String>> _getHeaders() async {
    String? token;

    try {
      if (Hive.isBoxOpen('authBox')) {
        token = Hive.box('authBox').get('token') as String?;
      } else {
        final box = await Hive.openBox('authBox');
        token = box.get('token') as String?;
      }
    } catch (e) {
      debugPrint('StudentApiService._getHeaders: Hive read failed: $e');
    }

    if (token == null || token.trim().isEmpty) {
      try {
        final prefs = await SharedPreferences.getInstance();
        token = prefs.getString('admin_token') ?? prefs.getString('auth_token');
      } catch (e) {
        debugPrint('StudentApiService._getHeaders: SharedPreferences read failed: $e');
      }
    }

    // Optional: If you want to bypass token requirement entirely for fetching students, 
    // you can comment out the exception below.
    if (token == null || token.trim().isEmpty) {
      debugPrint('StudentApiService: Proceeding without token or token missing.');
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.trim().isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> _handleUnauthorized(http.Response response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('admin_token');
      await prefs.remove('user_role');
      await prefs.remove('user_data');
    } catch (_) {}

    throw const UnauthorizedException('Session expired. Please log in again.');
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
      } else if (response.statusCode == 401) {
        await _handleUnauthorized(response);
        return [];
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

  /// Registers a new student account via POST /api/auth/register.
  Future<StudentModel> registerStudent({
    required String name,
    required String email,
    required String password,
    required String dateOfBirth,
    required String contactNumber,
    required String qualification,
  }) async {
    final url = Uri.parse(ApiConstants.register);

    final body = json.encode({
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'dateOfBirth': dateOfBirth.trim(),
      'contactNumber': contactNumber.trim(),
      'qualification': qualification.trim(),
    });

    debugPrint('API URL (POST Register Student): $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      debugPrint('STATUS (POST Register Student): ${response.statusCode}');

      Map<String, dynamic> responseData = {};
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) responseData = decoded;
      } catch (_) {}

      final bool isSuccess =
          response.statusCode == 201 || response.statusCode == 200;

      if (isSuccess) {
        final dynamic studentJson =
            responseData['student'] ??
            responseData['data']?['student'] ??
            responseData['user'] ??
            responseData['data']?['user'] ??
            responseData['data'];

        if (studentJson is Map<String, dynamic>) {
          return StudentModel.fromJson(studentJson);
        }

        return StudentModel(
          id: responseData['studentId']?.toString() ??
              responseData['data']?['studentId']?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          name: name.trim(),
          email: email.trim(),
          phone: contactNumber.trim(),
          dateOfBirth: dateOfBirth.trim(),
          qualification: qualification.trim(),
        );
      } else {
        String errorMessage;
        if (responseData['errors'] is List &&
            (responseData['errors'] as List).isNotEmpty) {
          errorMessage = (responseData['errors'] as List)
              .map((e) => e.toString())
              .join('\n');
        } else if (responseData['message'] != null &&
            responseData['message'].toString().isNotEmpty) {
          errorMessage = responseData['message'].toString();
        } else {
          errorMessage =
              'Registration failed (Status ${response.statusCode}). Please try again.';
        }
        throw Exception(errorMessage);
      }
    } on Exception {
      rethrow;
    } catch (e) {
      debugPrint('StudentApiService.registerStudent error: $e');
      throw Exception('Unable to reach the server. Please check your internet connection.');
    }
  }
}