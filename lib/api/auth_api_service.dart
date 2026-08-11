import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/auth_model.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class AuthApiService {
  static const String baseUrl = 'https://api.whitecoatacademy.com/api';

  final http.Client _client;

  AuthApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final dynamic body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body is Map<String, dynamic>) {
          return AuthResponse.fromJson(body);
        } else {
          throw const ApiException('Unexpected response format from server');
        }
      } else {
        String errorMessage = 'Invalid email or password';
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'].toString();
        } else if (body is Map && body.containsKey('error')) {
          errorMessage = body['error'].toString();
        }
        throw ApiException(errorMessage);
      }
    } on SocketException {
      throw const ApiException('Unable to connect to server');
    } on HttpException {
      throw const ApiException('Unable to connect to server');
    } on FormatException {
      throw const ApiException('Unexpected response format');
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw const ApiException('Connection timed out. Please try again.');
      }
      throw const ApiException('Something went wrong. Please try again.');
    }
  }
}
