import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:homeopathy/admin/screens/courses/model/course_model.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class CourseApiService {
  static const String _baseUrl = ApiConstants.courses;

  // GET all courses
  Future<List<CourseModel>> getCourses() async {
    final url = Uri.parse(_baseUrl);
    debugPrint('API URL (GET): $url');

    try {
      final response = await http.get(url);
      debugPrint('STATUS (GET): ${response.statusCode}');
      debugPrint('RESPONSE (GET): ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? responseData['courses'] ?? [];
        return data.map((json) => CourseModel.fromJson(json)).toList();
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final errorMessage = responseData['message'] ?? responseData['error'] ?? 'Failed to load courses';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in getCourses: $e');
      rethrow;
    }
  }

  // POST create a new course
  Future<CourseModel> createCourse({
    required String courseTitle,
    required String instructor,
    required String category,
    required double price,
  }) async {
    final url = Uri.parse(_baseUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'courseTitle': courseTitle,
      'instructor': instructor,
      'category': category,
      'price': price,
    });

    debugPrint('API URL (POST): $url');
    debugPrint('HEADERS (POST): $headers');
    debugPrint('BODY (POST): $body');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      debugPrint('STATUS (POST): ${response.statusCode}');
      debugPrint('RESPONSE (POST): ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = responseData['data'] ?? responseData;
        return CourseModel.fromJson(data);
      } else {
        // Detailed validation feedback from backend
        final errorMessage = responseData['message'] ?? responseData['error'] ?? 'Validation failed';
        final errors = responseData['errors'];
        if (errors != null) {
          throw Exception('$errorMessage: ${errors.toString()}');
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in createCourse: $e');
      rethrow;
    }
  }

  // PUT update an existing course
  Future<CourseModel> updateCourse({
    required String id,
    required String courseTitle,
    required String instructor,
    required String category,
    required double price,
  }) async {
    final url = Uri.parse('$_baseUrl/$id');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'courseTitle': courseTitle,
      'instructor': instructor,
      'category': category,
      'price': price,
    });

    debugPrint('API URL (PUT): $url');
    debugPrint('HEADERS (PUT): $headers');
    debugPrint('BODY (PUT): $body');

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );

      debugPrint('STATUS (PUT): ${response.statusCode}');
      debugPrint('RESPONSE (PUT): ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 204) {
        final Map<String, dynamic> data = responseData['data'] ?? responseData;
        if (data.isEmpty) {
          return CourseModel(
            id: id,
            courseId: '',
            title: courseTitle,
            instructor: instructor,
            category: category,
            price: price,
          );
        }
        return CourseModel.fromJson(data);
      } else {
        final errorMessage = responseData['message'] ?? responseData['error'] ?? 'Failed to update course';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in updateCourse: $e');
      rethrow;
    }
  }

  // DELETE delete a course
  Future<bool> deleteCourse(String id) async {
    final url = Uri.parse('$_baseUrl/$id');
    debugPrint('API URL (DELETE): $url');

    try {
      final response = await http.delete(url);
      debugPrint('STATUS (DELETE): ${response.statusCode}');
      debugPrint('RESPONSE (DELETE): ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final errorMessage = responseData['message'] ?? responseData['error'] ?? 'Failed to delete course';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in deleteCourse: $e');
      rethrow;
    }
  }
}