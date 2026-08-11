import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _token;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      final Map<String, dynamic> resData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle various response layouts
        final success = resData['success'] == true;
        final fetchedToken = resData['token'] ?? resData['data']?['token'] ?? (success ? 'authenticated_token' : null);
        
        if (fetchedToken != null) {
          _token = fetchedToken;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('admin_token', _token!);
          return true;
        } else {
          throw Exception(resData['message'] ?? 'Invalid credentials');
        }
      } else {
        throw Exception(resData['message'] ?? 'Failed to authenticate: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_token');
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('admin_token')) {
      _token = prefs.getString('admin_token');
      notifyListeners();
      return true;
    }
    return false;
  }
}
