import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homeopathy/models/auth_model.dart';
import 'package:homeopathy/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _token;
  String? _userRole;
  UserModel? _currentUser;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get userRole => _userRole;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAdmin => _userRole == 'admin' || _userRole == 'superadmin';
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String emailOrUsername, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _authService.loginAdmin(
        email: emailOrUsername,
        password: password,
      );

      _token = res['token']?.toString();
      _userRole = res['role']?.toString();
      final userObj = res['user'];
      if (userObj is Map<String, dynamic>) {
        _currentUser = UserModel.fromJson(userObj);
      } else if (userObj is String) {
        try {
          _currentUser = UserModel.fromJson(json.decode(userObj));
        } catch (_) {}
      }

      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '').trim();
      if (_errorMessage == null || _errorMessage!.isEmpty) {
        _errorMessage = 'Login failed. Please check your credentials.';
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _userRole = null;
    _currentUser = null;
    _errorMessage = null;
    await _authService.logout();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRole = prefs.getString('user_role')?.toLowerCase().trim();

    if (prefs.containsKey('admin_token') || (savedRole == 'admin' || savedRole == 'superadmin')) {
      _token = prefs.getString('admin_token') ?? prefs.getString('auth_token');
      _userRole = savedRole ?? 'admin';
      final userDataStr = prefs.getString('user_data');
      if (userDataStr != null) {
        try {
          _currentUser = UserModel.fromJson(json.decode(userDataStr));
        } catch (_) {}
      }
      notifyListeners();
      return _token != null && _token!.isNotEmpty;
    }
    return false;
  }
}