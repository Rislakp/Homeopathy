import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:homeopathy/models/exam_detail_model.dart';
import 'package:homeopathy/models/exam_summary_model.dart';

/// Service responsible for managing exam API requests.
class ExamService {
  static const String _grandMockBaseUrl =
      'https://homeopathybackend-1.onrender.com/api/exams/grand-mock';

  /// Timeout for all requests. 50 s covers Render cold-start (~30-45 s).
  static const Duration _timeout = Duration(seconds: 50);

  /// Fetches the list of all created Grand Mock exams.
  ///
  /// Throws an [Exception] if the HTTP status code is not 200,
  /// if the response JSON indicates `"success": false`, or if a network error occurs.
  Future<List<ExamSummaryModel>> getGrandMockExams() async {
    final Uri url = Uri.parse(_grandMockBaseUrl);
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(_timeout);

      // Attempt to decode JSON response body safely
      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map<String, dynamic>) {
            responseData = decoded;
          }
        } catch (e) {
          debugPrint('JSON decode error in getGrandMockExams: $e');
        }
      }

      // Check for success status code
      if (response.statusCode == 200) {
        final bool isSuccess = responseData['success'] == true;
        if (isSuccess && responseData['data'] is List) {
          final List<dynamic> dataList = responseData['data'] as List<dynamic>;
          return dataList
              .map((item) =>
                  ExamSummaryModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          final String errorMessage = responseData['message'] as String? ??
              'Failed to fetch Grand Mock exams.';
          throw Exception(errorMessage);
        }
      } else {
        // Non-200 status code handler
        final String errorMessage = responseData['message'] as String? ??
            responseData['error'] as String? ??
            'Failed to fetch Grand Mock exams (Status: ${response.statusCode}).';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection.');
    } on TimeoutException {
      throw Exception(
          'The server is taking too long to respond. '
          'This usually means the backend is starting up — please wait a moment and retry.');
    } catch (e) {
      debugPrint('Error in ExamService.getGrandMockExams: $e');
      rethrow;
    }
  }

  /// Fetches the complete details and questions for a specific Grand Mock exam by its [id].
  ///
  /// Handles 200, 400, 404, and 500 status codes, throwing readable exceptions
  /// containing the message from the backend response.
  Future<ExamDetailModel> getExamDetailsById(String id) async {
    final Uri url = Uri.parse('$_grandMockBaseUrl/$id');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(_timeout);

      // Attempt to decode JSON response body safely
      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map<String, dynamic>) {
            responseData = decoded;
          }
        } catch (e) {
          debugPrint('JSON decode error in getExamDetailsById: $e');
        }
      }

      switch (response.statusCode) {
        case 200:
          final bool isSuccess = responseData['success'] == true;
          if (isSuccess && responseData['data'] is Map) {
            return ExamDetailModel.fromJson(
              responseData['data'] as Map<String, dynamic>,
            );
          } else {
            final String message = responseData['message'] as String? ??
                'Failed to parse Grand Mock Exam details.';
            throw Exception(message);
          }

        case 400:
          final String message = responseData['message'] as String? ??
              'Invalid Exam ID format.';
          throw Exception(message);

        case 404:
          final String message = responseData['message'] as String? ??
              'Grand Mock Exam not found.';
          throw Exception(message);

        case 500:
          final String message = responseData['message'] as String? ??
              'Failed to fetch Grand Mock Exam details.';
          throw Exception(message);

        default:
          final String message = responseData['message'] as String? ??
              responseData['error'] as String? ??
              'Server returned error code: ${response.statusCode}';
          throw Exception(message);
      }
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection.');
    } on TimeoutException {
      throw Exception(
          'The server is taking too long to respond. Please try again.');
    } catch (e) {
      debugPrint('Error in ExamService.getExamDetailsById: $e');
      rethrow;
    }
  }
}
