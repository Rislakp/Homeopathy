import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:homeopathy/core/constants/api_constants.dart';
import 'package:homeopathy/models/test_question_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client _client;
  static const Duration _timeoutDuration = Duration(seconds: 20);

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// GET all test questions
  Future<List<TestQuestionModel>> fetchTestQuestions() async {
    final url = Uri.parse(ApiConstants.testQuestions);
    debugPrint('API [GET]: $url');

    try {
      final response = await _client
          .get(url, headers: _headers)
          .timeout(_timeoutDuration);

      debugPrint('API [GET] Status: ${response.statusCode}');
      debugPrint('API [GET] Body: ${response.body.length > 300 ? "${response.body.substring(0, 300)}..." : response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _parseQuestionsResponse(response.body);
      } else if (response.statusCode == 404) {
        // Fallback: Check grandMock endpoint if test-questions route is nested under exams
        return await _fallbackFetchFromGrandMock();
      } else {
        final errorMsg = _extractErrorMessage(response.body, response.statusCode);
        throw Exception(errorMsg);
      }
    } on SocketException {
      throw Exception('Unable to connect to the server. Please check your internet connection.');
    } on TimeoutException {
      throw Exception('Connection timed out. The server is taking too long to respond.');
    } catch (e) {
      debugPrint('Error in fetchTestQuestions: $e');
      if (e.toString().startsWith('Exception:')) {
        rethrow;
      }
      throw Exception('Failed to load test questions: ${e.toString()}');
    }
  }

  /// Fallback to grandMock endpoint if test-questions is not directly deployed yet
  Future<List<TestQuestionModel>> _fallbackFetchFromGrandMock() async {
    final fallbackUrl = Uri.parse(ApiConstants.grandMock);
    debugPrint('API Fallback [GET]: $fallbackUrl');

    try {
      final response = await _client
          .get(fallbackUrl, headers: _headers)
          .timeout(_timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _parseQuestionsResponse(response.body);
      }
      return [];
    } catch (e) {
      debugPrint('Fallback fetch encountered error: $e');
      return [];
    }
  }

  /// Helper to parse response body into `List<TestQuestionModel>`
  List<TestQuestionModel> _parseQuestionsResponse(String body) {
    if (body.isEmpty) return [];

    final dynamic decoded = json.decode(body);
    List<dynamic> rawList = [];

    if (decoded is List) {
      rawList = decoded;
    } else if (decoded is Map<String, dynamic>) {
      if (decoded['questions'] is List) {
        rawList = decoded['questions'];
      } else if (decoded['data'] is List) {
        rawList = decoded['data'];
      } else if (decoded['data'] is Map && decoded['data']['questions'] is List) {
        rawList = decoded['data']['questions'];
      } else if (decoded['exams'] is List) {
        // Collect questions across exams if exams list is returned
        for (final exam in decoded['exams']) {
          if (exam is Map && exam['questions'] is List) {
            rawList.addAll(exam['questions']);
          }
        }
      }
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map((item) => TestQuestionModel.fromJson(item))
        .toList();
  }

  /// POST / Upload a single test question
  Future<TestQuestionModel> uploadTestQuestion(TestQuestionModel question) async {
    final url = Uri.parse(ApiConstants.testQuestions);
    final body = json.encode(question.toJson());

    debugPrint('API [POST]: $url');
    debugPrint('API [POST] Body: $body');

    try {
      final response = await _client
          .post(url, headers: _headers, body: body)
          .timeout(_timeoutDuration);

      debugPrint('API [POST] Status: ${response.statusCode}');
      debugPrint('API [POST] Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          if (decoded['success'] == false) {
            throw Exception(decoded['message'] ?? decoded['error'] ?? 'Failed to save question');
          }
          final item = decoded['data'] ?? decoded['question'] ?? decoded;
          if (item is Map<String, dynamic>) {
            return TestQuestionModel.fromJson(item);
          }
        }
        return question;
      } else if (response.statusCode == 404) {
        // If route /test-questions is not mounted, attempt grand-mock save format
        return await _fallbackSaveToGrandMock(question);
      } else {
        final errorMsg = _extractErrorMessage(response.body, response.statusCode);
        throw Exception(errorMsg);
      }
    } on SocketException {
      throw Exception('Network error: Unable to reach the server.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      debugPrint('Error in uploadTestQuestion: $e');
      if (e.toString().startsWith('Exception:')) {
        rethrow;
      }
      throw Exception('Failed to upload question: $e');
    }
  }

  /// Fallback: save to grand-mock format
  Future<TestQuestionModel> _fallbackSaveToGrandMock(TestQuestionModel question) async {
    final fallbackUrl = Uri.parse(ApiConstants.grandMock);
    final payload = json.encode({
      'title': question.subject?.isNotEmpty == true ? question.subject : 'Grand Mock Question',
      'marksPerQuestion': 1.0,
      'durationMinutes': 60,
      'totalQuestions': 1,
      'questions': [question.toJson()],
    });

    final response = await _client
        .post(fallbackUrl, headers: _headers, body: payload)
        .timeout(_timeoutDuration);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return question;
    } else {
      throw Exception('Server returned ${response.statusCode} while uploading question.');
    }
  }

  /// DELETE a test question by ID
  Future<bool> deleteTestQuestion(String questionId) async {
    final url = Uri.parse('${ApiConstants.testQuestions}/$questionId');
    debugPrint('API [DELETE]: $url');

    try {
      final response = await _client
          .delete(url, headers: _headers)
          .timeout(_timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error in deleteTestQuestion: $e');
      return false;
    }
  }

  /// Helper to extract clean error message from response body
  String _extractErrorMessage(String responseBody, int statusCode) {
    try {
      if (responseBody.isNotEmpty) {
        final decoded = json.decode(responseBody);
        if (decoded is Map) {
          final msg = decoded['message'] ?? decoded['error'] ?? decoded['msg'];
          if (msg != null && msg.toString().isNotEmpty) {
            return msg.toString();
          }
        }
      }
    } catch (_) {}
    return 'Server error ($statusCode). Please try again later.';
  }
}
