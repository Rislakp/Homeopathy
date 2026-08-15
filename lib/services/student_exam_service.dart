import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

  /// Timeout applied to all API requests.
  /// Set to 50 s to survive Render.com free-tier cold-start (~30-45 s),
  /// while still ending promptly on genuine network failure.
  static const Duration _timeout = Duration(seconds: 50);

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
      final response = await http
          .get(url, headers: headers)
          .timeout(_timeout);

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
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection.');
    } on TimeoutException {
      // Render free-tier cold-start can take 30-45 s. If the server is still
      // warming up the timeout fires here, surfacing a readable error instead
      // of leaving the FutureBuilder stuck in ConnectionState.waiting forever.
      throw Exception(
          'The server is taking too long to respond. '
          'This usually means the backend is starting up — please wait a moment and tap Retry.');
    } catch (e) {
      debugPrint('Error in StudentExamService.getAvailableExams: $e');
      rethrow;
    }
  }

  /// Initiates an active exam session and fetches sanitized questions for [examId].
  ///
  /// POST `/api/student/exams/:id/start`
  /// Includes `Authorization: Bearer <token>` header.
  /// Throws an [Exception] if session token is missing or if the API returns an error status code.
  Future<ActiveExamModel> startExam(String examId) async {
    final Uri url = Uri.parse('$_baseUrl/$examId/start');

    // ── 1. Retrieve the student's JWT from SharedPreferences ─────────────────
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    if (authToken == null || authToken.trim().isEmpty) {
      throw Exception('Session expired. Please log in again.');
    }

    // ── 2. Build headers with Authorization: Bearer <token> ──────────────────
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    // ── 3. POST to /api/student/exams/:id/start (backend requires POST) ───────
    try {
      final response = await http
          .post(url, headers: headers)
          .timeout(_timeout);

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

      // ── 4. Accept 200 or 201 as success ──────────────────────────────────────
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic data = responseData['data'];

        if (data is Map<String, dynamic>) {
          return ActiveExamModel.fromJson(data);
        } else {
          final String errorMessage = responseData['message'] as String? ??
              'Failed to start exam. Invalid response format.';
          throw Exception(errorMessage);
        }
      } else {
        // Surface the backend's error message verbatim when available
        final String errorMessage = responseData['message'] as String? ??
            responseData['error'] as String? ??
            'Failed to start exam (Status: ${response.statusCode}).';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection.');
    } on TimeoutException {
      throw Exception(
          'The server is taking too long to respond. Please try again.');
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
  ///
  /// The [http.post] is wrapped in a try-catch-finally with [_timeout] so the
  /// loading dialog in the UI is never left open on network failure or a
  /// Render.com cold-start timeout.
  Future<TestResultModel> submitExam(
    String examId,
    Map<String, String> selectedAnswers, {
    String? token,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/$examId/submit');
    debugPrint('StudentExamService.submitExam → POST $url');

    // ── 1. Retrieve the student's JWT from SharedPreferences ─────────────────
    //    If the caller already read the token (e.g. from the UI layer) it can
    //    be passed via [token] to skip the extra SharedPreferences read.
    final String? authToken;
    if (token != null && token.trim().isNotEmpty) {
      authToken = token;
    } else {
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('auth_token');
    }

    if (authToken == null || authToken.trim().isEmpty) {
      throw Exception('Session expired. Please log in again.');
    }

    // ── 2. Build headers with Authorization: Bearer <token> ──────────────────
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    // ── 3. Format payload: { "answers": [ { "questionId": "...", "selectedOption": "..." } ] }
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

    debugPrint('submitExam payload: ${json.encode(body)}');

    // ── 4. POST with timeout ──────────────────────────────────────────────────
    try {
      final response = await http
          .post(
            url,
            headers: headers,
            body: json.encode(body),
          )
          .timeout(_timeout);

      debugPrint('submitExam STATUS: ${response.statusCode}');

      // ── 5. Parse response body ────────────────────────────────────────────
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

      // ── 6. Interpret status code ──────────────────────────────────────────
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
    } on SocketException {
      // No network connectivity.
      throw Exception(
          'Unable to connect to the server. Please check your internet connection.');
    } on TimeoutException {
      // Server cold-start on Render free-tier can exceed _timeout.
      throw Exception(
          'The submission request timed out. '
          'The backend may still be starting up — please wait a moment and try again.');
    } catch (e) {
      debugPrint('Error in StudentExamService.submitExam: $e');
      rethrow;
    }
  }
}
