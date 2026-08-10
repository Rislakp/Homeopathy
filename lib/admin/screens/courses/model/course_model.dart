class CourseModel {
  final String id; // Internal MongoDB _id (e.g. "64e5c7...")
  final String courseId; // Custom display ID (e.g. "CRS-000012")
  final String title;
  final String instructor;
  final String category;
  final double price;
  final int students;

  final String status; // 'Published', 'Draft', 'Archived'
  final String description;
  final String image;
  final String status;
  final int students;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Compatibility getter
  String get courseTitle => title;

  const CourseModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.instructor,
    required this.category,
    required this.price,
    this.students = 0,
    required this.status,
    required this.description,
    required this.image,
  });

  CourseModel copyWith({
    String? id,
    String? courseId,
    String? title,
    String? courseTitle,
    String? instructor,
    String? category,
    double? price,
    String? description,
    String? image,
    String? status,
    int? students,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      status: status ?? this.status,
      students: students ?? this.students,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // toJson ONLY sends the backend-required fields to prevent validation failures
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'instructor': instructor,
      'category': category,
      'price': price,
    };
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      instructor: json['instructor'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0, 
      students: json['students'] as int? ?? 0,
      status: json['status'] as String? ?? 'Published',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? 'menu_book',
    );
  }
}
