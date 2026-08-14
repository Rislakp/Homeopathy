import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homeopathy/core/constants/api_constants.dart';
import 'package:homeopathy/student_portal/models/student_result_model.dart';

/// Service responsible for fetching student exam results from backend API.
class StudentResultService {
  static const String _authBoxName = 'authBox';
  static const String _authTokenKey = 'auth_token';

  /// Helper to get or open Hive [authBox].
  Future<Box> _getAuthBox() async {
    if (Hive.isBoxOpen(_authBoxName)) {
      return Hive.box(_authBoxName);
    } else {
      return await Hive.openBox(_authBoxName);
    }
  }

  /// Retrieves the saved student auth token from Hive (or SharedPreferences).
  Future<String?> _getToken() async {
    try {
      final Box authBox = await _getAuthBox();
      final String? token = authBox.get('token');
      if (token != null && token.trim().isNotEmpty) {
        return token.trim();
      }

      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_authTokenKey)?.trim();
    } catch (e) {
      debugPrint('StudentResultService._getToken error: $e');
      return null;
    }
  }

  /// Fetches all exam results for the authenticated student.
  ///
  /// - Method: `GET`
  /// - URL: `https://homeopathybackend-1.onrender.com/api/student/results`
  /// - Headers: `Authorization: Bearer <token>`, `Content-Type: application/json`
  Future<List<StudentResult>> getStudentResults() async {
    final String? token = await _getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Session expired. Please login again.');
    }

    final Uri url = Uri.parse(ApiConstants.studentResults);

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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
          debugPrint('StudentResultService JSON decode error: $e');
        }
      }

      if (response.statusCode == 200) {
        final dynamic rawData = responseData['data'] ?? responseData['results'];
        if (rawData is List) {
          final List<StudentResult> results = rawData
              .whereType<Map<String, dynamic>>()
              .map((item) => StudentResult.fromJson(item))
              .toList();

          // Sort by createdAt descending (most recent first)
          results.sort((a, b) {
            if (a.createdAt == null && b.createdAt == null) return 0;
            if (a.createdAt == null) return 1;
            if (b.createdAt == null) return -1;
            return b.createdAt!.compareTo(a.createdAt!);
          });

          return results;
        } else {
          return [];
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode >= 500) {
        throw Exception('Unable to load exam results. Please try again.');
      } else {
        final String errorMessage = responseData['message'] as String? ??
            responseData['error'] as String? ??
            'Unable to load exam results. Please try again.';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Unable to connect to server. Please check your internet connection.');
    } on http.ClientException catch (e) {
      if (e.message.contains('Failed to fetch') ||
          e.message.contains('SocketException')) {
        throw Exception('Unable to connect to server. Please check your internet connection.');
      }
      throw Exception('Unable to connect to server. Please check your internet connection.');
    } on FormatException {
      throw Exception('Something went wrong while loading your result.');
    } catch (e) {
      debugPrint('StudentResultService.getStudentResults error: $e');
      if (e is Exception) rethrow;
      throw Exception('Something went wrong while loading your result.');
    }
  }
}
