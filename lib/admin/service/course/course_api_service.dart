import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../models/course_model.dart';

class CourseApiService {
  // GET: Fetch list of courses
  Future<List<CourseModel>> getCourses() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.courses));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> list = data['data'];
          return list.map((item) => CourseModel.fromJson(item)).toList();
        }
      }
      throw Exception('Failed to load courses: ${response.body}');
    } catch (e) {
      throw Exception('Error loading courses: $e');
    }
  }

  // POST: Create a new course
  Future<CourseModel> createCourse(CourseModel course) async {
    try {
      final body = {
        'courseTitle': course.title,
        'instructor': course.instructor,
        'category': course.category,
        'price': course.price,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.courses),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return CourseModel.fromJson(data['data']);
        }
      }
      throw Exception('Failed to create course: ${response.body}');
    } catch (e) {
      throw Exception('Error creating course: $e');
    }
  }

  // PUT: Update an existing course
  Future<CourseModel> updateCourse(CourseModel course) async {
    try {
      final body = {
        'courseId': course.id,
        'courseTitle': course.title,
        'instructor': course.instructor,
        'category': course.category,
        'price': course.price,
      };

      final response = await http.put(
        Uri.parse('${ApiConstants.courses}/${course.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return CourseModel.fromJson(data['data']);
        }
      }
      throw Exception('Failed to update course: ${response.body}');
    } catch (e) {
      throw Exception('Error updating course: $e');
    }
  }

  // DELETE: Delete a course
  Future<bool> deleteCourse(String courseId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.courses}/$courseId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] == true;
      }
      throw Exception('Failed to delete course: ${response.body}');
    } catch (e) {
      throw Exception('Error deleting course: $e');
    }
  }
}
