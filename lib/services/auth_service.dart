import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homeopathy/core/constants/api_constants.dart';

/// Authentication Service managing student and admin login, registration,
/// session persistence with Hive, and token storage in SharedPreferences.
class AuthService {
  static const String _authTokenKey = 'auth_token';
  static const String _adminTokenKey = 'admin_token';
  static const String _userRoleKey = 'user_role';
  static const String _userDataKey = 'user_data';
  static const String _authBoxName = 'authBox';

  /// Helper to get or open the Hive [authBox].
  Future<Box> _getAuthBox() async {
    if (Hive.isBoxOpen(_authBoxName)) {
      return Hive.box(_authBoxName);
    } else {
      return await Hive.openBox(_authBoxName);
    }
  }

  /// Internal core login implementation
  Future<Map<String, dynamic>> _performLogin({
    required String endpointUrl,
    required String emailOrUsername,
    required String password,
    String? expectedRole,
  }) async {
    final Uri url = Uri.parse(endpointUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': emailOrUsername.trim(),
          'username': emailOrUsername.trim(),
          'password': password,
        }),
      );

      dynamic decoded;
      try {
        decoded = json.decode(response.body);
      } catch (_) {
        decoded = null;
      }

      final Map<String, dynamic> responseData =
          decoded is Map<String, dynamic> ? decoded : {};

      final bool isSuccessStatus =
          response.statusCode == 200 || response.statusCode == 201;
      final bool isSuccessFlag =
          responseData['success'] == true || responseData['success'] == null;

      if (isSuccessStatus && isSuccessFlag) {
        final String? token =
            responseData['token'] ?? responseData['data']?['token'];

        final dynamic userObj = responseData['user'] ??
            responseData['data']?['user'] ??
            responseData['data'] ??
            responseData['student'];

        String? studentId;
        String? role;

        if (responseData['studentId'] != null) {
          studentId = responseData['studentId'].toString();
        } else if (responseData['data']?['studentId'] != null) {
          studentId = responseData['data']['studentId'].toString();
        } else if (userObj is Map) {
          studentId = userObj['studentId']?.toString() ??
              userObj['_id']?.toString() ??
              userObj['id']?.toString();
          role = userObj['role']?.toString();
        }

        role ??= responseData['role']?.toString() ??
            responseData['data']?['role']?.toString() ??
            'student';

        role = role.toLowerCase().trim();

        if (token == null || token.isEmpty) {
          throw Exception('Token not found in login response.');
        }

        // Role verification if expectedRole was specified
        if (expectedRole != null) {
          final cleanExpected = expectedRole.toLowerCase().trim();
          if (cleanExpected == 'admin' &&
              (role != 'admin' && role != 'superadmin')) {
            throw Exception('Access denied: Admin privileges required.');
          } else if (cleanExpected == 'student' && role != 'student') {
            throw Exception('Invalid role: Student access only.');
          }
        }

        // ========================================================
        // SAVE SESSION DATA LOCALLY USING HIVE & SHAREDPREFERENCES
        // ========================================================
        final Box authBox = await _getAuthBox();
        await authBox.put('token', token);
        await authBox.put('role', role);
        await authBox.put('isLoggedIn', true);
        await authBox.put('userEmail', emailOrUsername);

        if (studentId != null && studentId.isNotEmpty) {
          await authBox.put('studentId', studentId);
        }

        if (userObj != null) {
          await authBox.put(
            'user',
            userObj is String ? userObj : jsonEncode(userObj),
          );
        }

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_authTokenKey, token);
        await prefs.setString(_userRoleKey, role);

        if (role == 'admin' || role == 'superadmin') {
          await prefs.setString(_adminTokenKey, token);
        }

        if (userObj != null) {
          await prefs.setString(
            _userDataKey,
            userObj is String ? userObj : jsonEncode(userObj),
          );
        }

        return {
          'token': token,
          'studentId': studentId,
          'role': role,
          'user': userObj,
          'raw': responseData,
        };
      } else {
        // Handle Error status codes (401 Unauthorized, 403 Forbidden, 400, 500)
        String errorMessage;
        if (responseData['message'] != null &&
            responseData['message'].toString().isNotEmpty) {
          errorMessage = responseData['message'].toString();
        } else if (responseData['error'] != null &&
            responseData['error'].toString().isNotEmpty) {
          errorMessage = responseData['error'].toString();
        } else if (responseData['msg'] != null &&
            responseData['msg'].toString().isNotEmpty) {
          errorMessage = responseData['msg'].toString();
        } else if (response.statusCode == 401) {
          errorMessage = 'Invalid email or password';
        } else if (response.statusCode == 403) {
          errorMessage = 'Access denied: Insufficient permissions.';
        } else {
          errorMessage =
              'Login failed (Status ${response.statusCode}). Please check your credentials.';
        }
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw http.ClientException(
          'Unable to reach the server. Please check your internet connection.');
    } on http.ClientException catch (e) {
      if (e.message.contains('Failed to fetch') ||
          e.message.contains('localhost') ||
          e.message.contains('SocketException')) {
        throw http.ClientException(
            'Unable to reach the server. Please check your internet connection.');
      }
      throw http.ClientException(
          'Unable to reach the server. Please check your internet connection.');
    } on FormatException {
      throw Exception('Invalid response format received from server.');
    } catch (e) {
      debugPrint('AuthService login error: $e');
      if (e is Exception || e is http.ClientException) rethrow;
      throw Exception(e.toString());
    }
  }

  /// Performs Student Login using HTTP POST to [ApiConstants.studentLogin].
  Future<Map<String, dynamic>> loginStudent({
    required String email,
    required String password,
  }) async {
    return await _performLogin(
      endpointUrl: ApiConstants.studentLogin,
      emailOrUsername: email,
      password: password,
      expectedRole: 'student',
    );
  }

  /// Performs Admin Login using HTTP POST to [ApiConstants.adminLogin].
  Future<Map<String, dynamic>> loginAdmin({
    required String email,
    required String password,
  }) async {
    return await _performLogin(
      endpointUrl: ApiConstants.adminLogin,
      emailOrUsername: email,
      password: password,
      expectedRole: 'admin',
    );
  }

  /// Universal Login: Authenticates user and returns role from backend database.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _performLogin(
      endpointUrl: ApiConstants.login,
      emailOrUsername: email,
      password: password,
    );
  }

  /// Performs Student Registration using HTTP POST request.
  Future<Map<String, dynamic>> registerStudent({
    required String name,
    required String email,
    required String password,
    required String dateOfBirth,
    required String contactNumber,
    required String qualification,
  }) async {
    final Uri url = Uri.parse(ApiConstants.register);

    final Map<String, dynamic> requestBody = {
      'name': name,
      'email': email,
      'password': password,
      'dateOfBirth': dateOfBirth,
      'contactNumber': contactNumber,
      'qualification': qualification,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      dynamic decoded;
      try {
        decoded = json.decode(response.body);
      } catch (_) {
        decoded = null;
      }

      final Map<String, dynamic> responseData =
          decoded is Map<String, dynamic> ? decoded : {};

      final bool isSuccessStatus =
          response.statusCode == 201 || response.statusCode == 200;
      final bool isSuccessFlag =
          responseData['success'] == true || responseData['success'] == null;

      if (isSuccessStatus && isSuccessFlag) {
        final String? token =
            responseData['token'] ?? responseData['data']?['token'];
        final dynamic userObj = responseData['user'] ??
            responseData['data']?['user'] ??
            responseData['student'] ??
            responseData['data'];

        String? studentId;
        if (responseData['studentId'] != null) {
          studentId = responseData['studentId'].toString();
        } else if (responseData['data']?['studentId'] != null) {
          studentId = responseData['data']['studentId'].toString();
        } else if (userObj is Map) {
          studentId = userObj['studentId']?.toString() ??
              userObj['_id']?.toString() ??
              userObj['id']?.toString();
        }

        // Save token and user data locally (Hive & SharedPreferences)
        final Box authBox = await _getAuthBox();
        if (token != null && token.isNotEmpty) {
          await authBox.put('token', token);
          await authBox.put('role', 'student');
          await authBox.put('isLoggedIn', true);
          await saveToken(token);
        }

        if (studentId != null && studentId.isNotEmpty) {
          await authBox.put('studentId', studentId);
        }

        if (userObj != null) {
          await authBox.put(
            'user',
            userObj is String ? userObj : jsonEncode(userObj),
          );
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userRoleKey, 'student');

        return responseData;
      } else {
        String errorMessage;
        if (responseData['errors'] is List &&
            (responseData['errors'] as List).isNotEmpty) {
          final List<String> errorsList = (responseData['errors'] as List)
              .map((e) => e.toString())
              .toList();
          errorMessage = errorsList.join('\n');
        } else if (responseData['message'] != null &&
            responseData['message'].toString().isNotEmpty) {
          errorMessage = responseData['message'].toString();
        } else if (responseData['error'] != null &&
            responseData['error'].toString().isNotEmpty) {
          errorMessage = responseData['error'].toString();
        } else if (responseData['msg'] != null &&
            responseData['msg'].toString().isNotEmpty) {
          errorMessage = responseData['msg'].toString();
        } else {
          errorMessage =
              'Registration failed (Status ${response.statusCode}). Please try again.';
        }
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw http.ClientException(
          'Unable to reach the server. Please check your internet connection.');
    } on http.ClientException catch (e) {
      if (e.message.contains('Failed to fetch') ||
          e.message.contains('localhost') ||
          e.message.contains('SocketException')) {
        throw http.ClientException(
            'Unable to reach the server. Please check your internet connection.');
      }
      throw http.ClientException(
          'Unable to reach the server. Please check your internet connection.');
    } on FormatException {
      throw Exception('Invalid response format received from server.');
    } catch (e) {
      debugPrint('AuthService.registerStudent error: $e');
      if (e is Exception || e is http.ClientException) rethrow;
      throw Exception(e.toString());
    }
  }

  /// Performs user registration / signup for Map input.
  Future<String> signup(Map<String, dynamic> userData) async {
    final String name = userData['name']?.toString() ?? '';
    final String email = userData['email']?.toString() ?? '';
    final String password = userData['password']?.toString() ?? '';
    final String dateOfBirth =
        (userData['dateOfBirth'] ?? userData['dob'])?.toString() ?? '';
    final String contactNumber =
        (userData['contactNumber'] ?? userData['phone'] ?? userData['contact'])
            ?.toString() ??
        '';
    final String qualification = userData['qualification']?.toString() ?? '';

    final res = await registerStudent(
      name: name,
      email: email,
      password: password,
      dateOfBirth: dateOfBirth,
      contactNumber: contactNumber,
      qualification: qualification,
    );

    final String? token = res['token'] ?? res['data']?['token'];
    return token ?? res['message'] ?? 'Signup successful.';
  }

  /// Clears saved session data from Hive & SharedPreferences and logs out.
  Future<void> logout([BuildContext? context]) async {
    try {
      final Box authBox = await _getAuthBox();
      await authBox.clear();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      await prefs.remove(_adminTokenKey);
      await prefs.remove(_userRoleKey);
      await prefs.remove(_userDataKey);

      if (context != null && context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      debugPrint('AuthService.logout error: $e');
      rethrow;
    }
  }

  /// Retrieves the saved JWT token from Hive or SharedPreferences.
  Future<String?> getToken() async {
    try {
      final Box authBox = await _getAuthBox();
      final String? token = authBox.get('token');
      if (token != null && token.isNotEmpty) return token;

      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_authTokenKey) ?? prefs.getString(_adminTokenKey);
    } catch (e) {
      debugPrint('AuthService.getToken error: $e');
      return null;
    }
  }

  /// Retrieves the current authenticated user's role.
  Future<String?> getUserRole() async {
    try {
      final Box authBox = await _getAuthBox();
      final String? role = authBox.get('role');
      if (role != null && role.isNotEmpty) return role.toLowerCase().trim();

      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userRoleKey)?.toLowerCase().trim();
    } catch (e) {
      debugPrint('AuthService.getUserRole error: $e');
      return null;
    }
  }

  /// Checks if current session belongs to an Admin user.
  Future<bool> isAdmin() async {
    final role = await getUserRole();
    return role == 'admin' || role == 'superadmin';
  }

  /// Checks if current session belongs to a Student user.
  Future<bool> isStudent() async {
    final role = await getUserRole();
    return role == 'student';
  }

  /// Helper to save JWT token to SharedPreferences.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }
}
