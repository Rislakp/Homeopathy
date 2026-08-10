import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../models/course_api_models.dart';

class CourseApiService {
  final http.Client _client;

  CourseApiService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // 1. CREATE COURSE LIST (POST)
  Future<CourseCreateResponse> createCourse({
    required String courseTitle,
    required String instructor,
    required String category,
    required double price,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.courses}');

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'courseTitle': courseTitle,
          'instructor': instructor,
          'category': category,
          'price': price,
        }),
      );

      final dynamic body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body is Map<String, dynamic>) {
          return CourseCreateResponse.fromJson(body);
        } else {
          throw const HttpException('Unexpected response format');
        }
      } else {
        String errorMessage = 'Failed to create course';
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'].toString();
        } else if (body is Map && body.containsKey('error')) {
          errorMessage = body['error'].toString();
        }
        throw HttpException(errorMessage);
      }
    } on SocketException {
      throw const HttpException('No internet connection');
    } on FormatException {
      throw const HttpException('Invalid response format');
    }
  }

  // 2. COURSE LIST (GET)
  Future<CourseListResponse> getCourses() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.courses}');

    try {
      final response = await _client.get(
        url,
        headers: _headers,
      );

      final dynamic body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (body is Map<String, dynamic>) {
          return CourseListResponse.fromJson(body);
        } else {
          throw const HttpException('Unexpected response format');
        }
      } else {
        String errorMessage = 'Failed to load courses';
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'].toString();
        } else if (body is Map && body.containsKey('error')) {
          errorMessage = body['error'].toString();
        }
        throw HttpException(errorMessage);
      }
    } on SocketException {
      throw const HttpException('No internet connection');
    } on FormatException {
      throw const HttpException('Invalid response format');
    }
  }

  // 3. UPDATE COURSE (PUT)
  Future<CourseUpdateResponse> updateCourse({
    required String courseId,
    required String courseTitle,
    required String instructor,
    required double price,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.courseDetail(courseId)}');

    try {
      final response = await _client.put(
        url,
        headers: _headers,
        body: jsonEncode({
          'courseId': courseId,
          'courseTitle': courseTitle,
          'instructor': instructor,
          'price': price,
        }),
      );

      final dynamic body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (body is Map<String, dynamic>) {
          return CourseUpdateResponse.fromJson(body);
        } else {
          throw const HttpException('Unexpected response format');
        }
      } else {
        String errorMessage = 'Failed to update course';
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'].toString();
        } else if (body is Map && body.containsKey('error')) {
          errorMessage = body['error'].toString();
        }
        throw HttpException(errorMessage);
      }
    } on SocketException {
      throw const HttpException('No internet connection');
    } on FormatException {
      throw const HttpException('Invalid response format');
    }
  }

  // 4. DELETE COURSE (DELETE)
  Future<CourseDeleteResponse> deleteCourse(String courseId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.courseDetail(courseId)}');

    try {
      final response = await _client.delete(
        url,
        headers: _headers,
      );

      final dynamic body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (body is Map<String, dynamic>) {
          return CourseDeleteResponse.fromJson(body);
        } else {
          throw const HttpException('Unexpected response format');
        }
      } else {
        String errorMessage = 'Failed to delete course';
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'].toString();
        } else if (body is Map && body.containsKey('error')) {
          errorMessage = body['error'].toString();
        }
        throw HttpException(errorMessage);
      }
    } on SocketException {
      throw const HttpException('No internet connection');
    } on FormatException {
      throw const HttpException('Invalid response format');
    }
  }

  // 5. CREATE MODULE (POST)
  Future<ModuleCreateResponse> createModule({
    required String courseId,
    required String lessonTitle,
    required String uploadFileOrLink,
    required String lessonType,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.courseModules(courseId)}');

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'lessonTitle': lessonTitle,
          'uploadFileOrLink': uploadFileOrLink,
          'lessonType': lessonType,
        }),
      );

      final dynamic body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body is Map<String, dynamic>) {
          return ModuleCreateResponse.fromJson(body);
        } else {
          throw const HttpException('Unexpected response format');
        }
      } else {
        String errorMessage = 'Failed to create module';
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'].toString();
        } else if (body is Map && body.containsKey('error')) {
          errorMessage = body['error'].toString();
        }
        throw HttpException(errorMessage);
      }
    } on SocketException {
      throw const HttpException('No internet connection');
    } on FormatException {
      throw const HttpException('Invalid response format');
    }
  }

  // 6. GET COURSE DETAIL (GET)
  Future<ApiCourse> getCourseDetail(String courseId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.courseDetail(courseId)}');

    try {
      final response = await _client.get(
        url,
        headers: _headers,
      );

      final dynamic body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (body is Map<String, dynamic> && body['data'] is Map<String, dynamic>) {
          return ApiCourse.fromJson(body['data']);
        } else {
          throw const HttpException('Unexpected response format');
        }
      } else {
        String errorMessage = 'Failed to load course details';
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'].toString();
        }
        throw HttpException(errorMessage);
      }
    } on SocketException {
      throw const HttpException('No internet connection');
    } on FormatException {
      throw const HttpException('Invalid response format');
    }
  }

  // 7. GET COURSE MODULES (GET)
  Future<List<ApiModule>> getCourseModules(String courseId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.courseModules(courseId)}');

    try {
      final response = await _client.get(
        url,
        headers: _headers,
      );

      final dynamic body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (body is Map<String, dynamic> && body['data'] is List) {
          final list = body['data'] as List;
          return list.map((e) => ApiModule.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          throw const HttpException('Unexpected response format');
        }
      } else {
        String errorMessage = 'Failed to load course modules';
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'].toString();
        }
        throw HttpException(errorMessage);
      }
    } on SocketException {
      throw const HttpException('No internet connection');
    } on FormatException {
      throw const HttpException('Invalid response format');
    }
  }
}
