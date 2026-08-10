import 'package:flutter/material.dart';
import '../../api/auth_api_service.dart';
import '../../models/auth_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApiService _apiService;

  AuthProvider({AuthApiService? apiService})
      : _apiService = apiService ?? AuthApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _token;
  String? get token => _token;

  AuthUser? _user;
  AuthUser? get user => _user;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      _token = response.token;
      _user = response.user;
      _isSuccess = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _token = null;
    _user = null;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }
}
