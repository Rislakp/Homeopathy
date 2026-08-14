import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homeopathy/models/active_exam_model.dart';
import 'package:homeopathy/models/student_exam_model.dart';
import 'package:homeopathy/models/test_result_model.dart';

/// Service responsible for fetching available mock exams, starting exam sessions, and submitting test answers.
class StudentExamService {
  static const String _baseUrl =
      'https://homeopathybackend-1.onrender.com/api/student/exams';

  /// Fetches all available Grand Mock exams for the authenticated student.
  ///
  /// Includes `Authorization: Bearer <token>` header.
  /// Throws an [Exception] if token is missing/empty ("Session expired. Please log in again.")
  /// or if the HTTP status code is not 200 / "success": false.
  Future<List<StudentExamModel>> getAvailableExams({String? token}) async {
    final Uri url = Uri.parse(_baseUrl);

    final prefs = await SharedPreferences.getInstance();
    final String? authToken = token ?? prefs.getString('auth_token');

    if (authToken == null || authToken.trim().isEmpty) {
      throw Exception('Session expired. Please log in again.');
    }

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    try {
      final response = await http.get(url, headers: headers);

      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map<String, dynamic>) {
            responseData = decoded;
          }
        } catch (e) {
          debugPrint('JSON decode error in getAvailableExams: $e');
        }
      }

      if (response.statusCode == 200) {
        final bool isSuccess = responseData['success'] == true;
        if (isSuccess && responseData['data'] is List) {
          final List<dynamic> dataList = responseData['data'] as List<dynamic>;
          return dataList
              .map((item) =>
                  StudentExamModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          final String errorMessage = responseData['message'] as String? ??
              'Failed to fetch available exams.';
          throw Exception(errorMessage);
        }
      } else {
        final String errorMessage = responseData['message'] as String? ??
            responseData['error'] as String? ??
            'Failed to fetch exams (Status: ${response.statusCode}).';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in StudentExamService.getAvailableExams: $e');
      rethrow;
    }
  }

  /// Initiates an active exam session and fetches sanitized questions for [examId].
  ///
  /// GET `/api/student/exams/:id/start`
  /// Includes `Authorization: Bearer <token>` header.
  /// Throws an [Exception] if session token is missing or if the API returns an error status code.
  Future<ActiveExamModel> startExam(String examId) async {
    final Uri url = Uri.parse('$_baseUrl/$examId/start');

    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    if (authToken == null || authToken.trim().isEmpty) {
      throw Exception('Session expired. Please log in again.');
    }

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    try {
      final response = await http.get(url, headers: headers);

      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map<String, dynamic>) {
            responseData = decoded;
          }
        } catch (e) {
          debugPrint('JSON decode error in startExam: $e');
        }
      }

      if (response.statusCode == 200) {
        final bool isSuccess = responseData['success'] == true;
        final dynamic data = responseData['data'];

        if (isSuccess && data is Map<String, dynamic>) {
          return ActiveExamModel.fromJson(data);
        } else if (data is Map<String, dynamic>) {
          return ActiveExamModel.fromJson(data);
        } else {
          final String errorMessage = responseData['message'] as String? ??
              'Failed to start exam. Invalid response format.';
          throw Exception(errorMessage);
        }
      } else {
        final String errorMessage = responseData['message'] as String? ??
            responseData['error'] as String? ??
            'Failed to start exam (Status: ${response.statusCode}).';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in StudentExamService.startExam: $e');
      rethrow;
    }
  }

  /// Submits the student's answered questions for [examId] to backend.
  ///
  /// POST `/api/student/exams/:id/submit`
  /// Payload format: `{ "answers": [ { "questionId": "...", "selectedOption": "A" } ] }`
  /// Returns parsed [TestResultModel] on 200/201 success response.
  Future<TestResultModel> submitExam(
    String examId,
    Map<String, String> selectedAnswers,
  ) async {
    final Uri url = Uri.parse('$_baseUrl/$examId/submit');

    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    if (authToken == null || authToken.trim().isEmpty) {
      throw Exception('Session expired. Please log in again.');
    }

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    // Format payload as JSON list structure: { "answers": [ { "questionId": "...", "selectedOption": "..." } ] }
    final List<Map<String, String>> formattedAnswers =
        selectedAnswers.entries.map((entry) {
      return {
        'questionId': entry.key,
        'selectedOption': entry.value,
      };
    }).toList();

    final Map<String, dynamic> body = {
      'answers': formattedAnswers,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map<String, dynamic>) {
            responseData = decoded;
          }
        } catch (e) {
          debugPrint('JSON decode error in submitExam: $e');
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic data = responseData['data'] ?? responseData;
        if (data is Map<String, dynamic>) {
          return TestResultModel.fromJson(data);
        } else {
          throw Exception('Invalid submission response format from backend.');
        }
      } else {
        final String errorMessage = responseData['message'] as String? ??
            responseData['error'] as String? ??
            'Failed to submit exam (Status: ${response.statusCode}).';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in StudentExamService.submitExam: $e');
      rethrow;
    }
  }
}
