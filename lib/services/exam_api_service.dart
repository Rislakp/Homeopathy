import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homeopathy/core/constants/api_constants.dart';

class ExamApiService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_token') ?? prefs.getString('auth_token');
  }

  // Extract MCQs from PDF
  Future<Map<String, dynamic>> extractMcqs(PlatformFile pdfFile) async {
    final url = Uri.parse(ApiConstants.extractMcqs);
    debugPrint('API URL (POST Multipart): $url');

    String fileName = pdfFile.name;
    if (!fileName.toLowerCase().endsWith('.pdf')) {
      fileName = '$fileName.pdf';
    }

    final extension = pdfFile.extension ??
        (fileName.contains('.') ? fileName.split('.').last : 'pdf');
    final bytes = pdfFile.bytes;
    final byteLength = bytes?.length ?? pdfFile.size;
    final mimeType = 'application/pdf';

    debugPrint('========== PDF UPLOAD DETAILS ==========');
    debugPrint('Selected File Name : $fileName');
    debugPrint('Extension          : $extension');
    debugPrint('MIME Type          : $mimeType');
    debugPrint('Byte Length        : $byteLength bytes');
    debugPrint('Is Flutter Web     : $kIsWeb');
    debugPrint('========================================');

    try {
      final request = http.MultipartRequest('POST', url);

      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      if (kIsWeb || bytes != null) {
        if (bytes == null) {
          throw Exception('File bytes are not available for web upload.');
        }
        request.files.add(
          http.MultipartFile.fromBytes(
            'pdf',
            bytes,
            filename: fileName,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      } else {
        if (pdfFile.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'pdf',
              pdfFile.path!,
              filename: fileName,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        } else {
          throw Exception('Neither file path nor file bytes are available.');
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('STATUS (POST Multipart): ${streamedResponse.statusCode}');
      debugPrint('RAW RESPONSE (POST Multipart): ${response.body}');

      Map<String, dynamic> responseData = {};
      try {
        if (response.body.isNotEmpty) {
          final decoded = json.decode(response.body);
          if (decoded is Map<String, dynamic>) {
            responseData = decoded;
          }
        }
      } catch (e) {
        debugPrint('Error decoding response JSON: $e');
      }

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        if (responseData['success'] == true) {
          return responseData;
        } else {
          final errorMessage = responseData['message'] ??
              responseData['error'] ??
              'Failed to extract MCQs from PDF';
          throw Exception(errorMessage);
        }
      } else {
        final errorMessage = responseData['message'] ??
            responseData['error'] ??
            (response.body.isNotEmpty
                ? response.body
                : 'Server error (${streamedResponse.statusCode})');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in extractMcqs: $e');
      rethrow;
    }
  }

  // Save Grand Mock Exam
  Future<Map<String, dynamic>> saveGrandMock({
    required String title,
    required double marksPerQuestion,
    required int durationMinutes,
    required int totalQuestions,
    required List<Map<String, dynamic>> questions,
  }) async {
    final url = Uri.parse(ApiConstants.grandMock);

    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'title': title,
      'marksPerQuestion': marksPerQuestion,
      'durationMinutes': durationMinutes,
      'totalQuestions': totalQuestions,
      'questions': questions,
    });

    debugPrint('API URL (POST JSON): $url');
    debugPrint('BODY (POST JSON): $body');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      debugPrint('STATUS (POST JSON): ${response.statusCode}');
      debugPrint('RAW RESPONSE (POST JSON): ${response.body}');

      Map<String, dynamic> responseData = {};
      try {
        if (response.body.isNotEmpty) {
          final decoded = json.decode(response.body);
          if (decoded is Map<String, dynamic>) {
            responseData = decoded;
          }
        }
      } catch (e) {
        debugPrint('Error parsing saveGrandMock response: $e');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData.isNotEmpty && responseData['success'] == false) {
          final msg = responseData['message'] ??
              responseData['error'] ??
              'Failed to save exam';
          throw Exception(msg);
        }
        return responseData;
      } else {
        final errorMessage = responseData['message'] ??
            responseData['error'] ??
            (response.body.isNotEmpty
                ? response.body
                : 'Server error (${response.statusCode})');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in saveGrandMock: $e');
      rethrow;
    }
  }
}
