class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'student', 'admin', 'superadmin', etc.
  final String? phone;
  final String? contactNumber;
  final String? qualification;
  final String? dateOfBirth;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.contactNumber,
    this.qualification,
    this.dateOfBirth,
  });

  bool get isAdmin => role.toLowerCase() == 'admin' || role.toLowerCase() == 'superadmin';
  bool get isStudent => role.toLowerCase() == 'student';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['username'] ?? json['displayName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? 'student').toString().toLowerCase().trim(),
      phone: (json['phone'] ?? json['contactNumber'])?.toString(),
      contactNumber: (json['contactNumber'] ?? json['phone'])?.toString(),
      qualification: json['qualification']?.toString(),
      dateOfBirth: (json['dateOfBirth'] ?? json['dob'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      if (phone != null) 'phone': phone,
      if (contactNumber != null) 'contactNumber': contactNumber,
      if (qualification != null) 'qualification': qualification,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
    };
  }
}

class AuthResponse {
  final bool success;
  final String? token;
  final UserModel? user;
  final String? role;
  final String? message;

  const AuthResponse({
    required this.success,
    this.token,
    this.user,
    this.role,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final bool isSuccess = json['success'] == true ||
        json['status'] == true ||
        json['status'] == 'success' ||
        json['token'] != null ||
        json['data']?['token'] != null;

    final token = json['token'] ??
        json['data']?['token'] ??
        json['accessToken'] ??
        (isSuccess ? 'authenticated_session' : null);

    Map<String, dynamic>? userData;
    if (json['user'] is Map<String, dynamic>) {
      userData = json['user'];
    } else if (json['data'] is Map<String, dynamic> &&
        json['data']['user'] is Map<String, dynamic>) {
      userData = json['data']['user'];
    } else if (json['data'] is Map<String, dynamic>) {
      userData = json['data'];
    }

    final user = userData != null ? UserModel.fromJson(userData) : null;
    final role = (json['role'] ?? json['data']?['role'] ?? user?.role)
        ?.toString()
        .toLowerCase()
        .trim();
    final message = json['message'] ?? json['msg'] ?? json['error'];

    return AuthResponse(
      success: isSuccess,
      token: token?.toString(),
      user: user,
      role: role,
      message: message?.toString(),
    );
  }
}
