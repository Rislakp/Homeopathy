class StudentModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String course;
  final String subscription;
  final String status; // 'Active', 'Inactive', 'Trial', 'Expired'
  final DateTime joinedDate;

  const StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.course,
    required this.subscription,
    required this.status,
    required this.joinedDate,
  });

  String get initials {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    final filtered = parts.where((part) {
      final norm = part.toLowerCase();
      return norm != 'dr.' && norm != 'dr' && norm != 'mr.' && norm != 'mr' && norm != 'ms.' && norm != 'ms';
    }).toList();
    
    final toUse = filtered.isNotEmpty ? filtered : parts;
    if (toUse.length >= 2) {
      return (toUse[0][0] + toUse[1][0]).toUpperCase();
    }
    return toUse[0][0].toUpperCase();
  }

  StudentModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? course,
    String? subscription,
    String? status,
    DateTime? joinedDate,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      course: course ?? this.course,
      subscription: subscription ?? this.subscription,
      status: status ?? this.status,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'course': course,
      'subscription': subscription,
      'status': status,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      course: json['course'] as String,
      subscription: json['subscription'] as String,
      status: json['status'] as String,
      joinedDate: DateTime.parse(json['joinedDate'] as String),
    );
  }
}
