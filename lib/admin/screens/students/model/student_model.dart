class StudentModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String course;
  final String subscription;
  final String status;
  final String avatarText;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.course,
    required this.subscription,
    required this.status,
    required this.avatarText,
  });

  StudentModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? course,
    String? subscription,
    String? status,
    String? avatarText,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      course: course ?? this.course,
      subscription: subscription ?? this.subscription,
      status: status ?? this.status,
      avatarText: avatarText ?? this.avatarText,
    );
  }
}
