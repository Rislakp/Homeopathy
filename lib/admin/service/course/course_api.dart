import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:homeopathy/admin/screens/courses/model/course_model.dart';
// Import your ApiConstants file where baseUrl is defined

class CourseApiService {
  static const String _baseUrl = 'https://homeopathybackend-1.onrender.com/api/courses';

  Future<CourseModel> createCourse({
    required String courseTitle,
    required String instructor,
    required String category,
    required double price,
    required int students,
    required String status,
    required String description,
    required String image,
    required bool antiGravityEnabled,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': courseTitle,
          'instructor': instructor,
          'category': category,
          'price': price,
          'students': students,
          'status': status,
          'description': description,
          'image': image,
          'antiGravityPrompt': antiGravityEnabled ? 'Lifting knowledge into orbit' : 'Grounded',
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Assuming your backend returns the created course as a JSON object
        final data = json.decode(response.body);
        return CourseModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to save to database');
      }
    } catch (e) {
      throw Exception('Network error: Ensure you have an internet connection.');
    }
  }
  
  


  // ==========================================
  // GET: Fetch all courses (GET)
  // ==========================================
  Future<List<CourseModel>> getCourses() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CourseModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load courses. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error while fetching courses. Details: $e');
    }
  }

  // ==========================================
  // PUT: Update an existing course (PUT/PATCH)
  // ==========================================
  Future<CourseModel> updateCourse(String courseId, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$courseId'),
        headers: {
          'Content-Type': 'application/json',
        },
        // Passing a map allows you to selectively update only the fields that changed
        body: json.encode(updatedData), 
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CourseModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update course');
      }
    } catch (e) {
      throw Exception('Network error while updating course. Details: $e');
    }
  }

  // ==========================================
  // DELETE: Remove a course (DELETE)
  // ==========================================
  Future<void> deleteCourse(String courseId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$courseId'),
      );

      // 200 (OK) or 204 (No Content) are common success codes for deletion
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete course. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error while deleting course. Details: $e');
    }
  }
}
