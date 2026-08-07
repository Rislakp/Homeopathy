// import 'dart:convert';
// import 'package:homeopathy/core/constants/api_constants.dart';
// import 'package:http/http.dart' as http;

// class AuthService {
//  // static const String baseUrl = 'http://10.0.2.2:5000/api';
//   final url = '${ApiConstants.baseUrl}/auth/login';

//   static Future<Map<String, dynamic>> login({
//     required String email,
//     required String password,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$url'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email.trim(), 'password': password}),
//     );

//     print('STATUS CODE: ${response.statusCode}');
//     print('RESPONSE: ${response.body}');
 
//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       return data;
//     }

//     throw Exception(data['message'] ?? 'Login failed');
//   }
// }
