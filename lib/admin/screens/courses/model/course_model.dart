class CourseModel {
  final String id;
  final String courseId;
  final String title;
  final String instructor;
  final String category;
  final double price;
  
  // Compatibility fields for the frontend UI
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
    this.description = 'Homeopathy foundational and advanced modules.',
    this.image = 'menu_book',
    this.status = 'Published',
    this.students = 0,
    this.createdAt,
    this.updatedAt,
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
      title: title ?? courseTitle ?? this.title,
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
      'courseTitle': title,
      'instructor': instructor,
      'category': category,
      'price': price,
    };
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id']?.toString() ?? '',
      courseId: json['courseId']?.toString() ?? json['_id']?.toString() ?? '',
      title: (json['courseTitle'] ?? json['title'] ?? '') as String,
      instructor: (json['instructor'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      price: (json['price'] as num? ?? 0.0).toDouble(),
      description: (json['description'] ?? 'Homeopathy foundational and advanced modules.') as String,
      image: (json['image'] ?? 'menu_book') as String,
      status: (json['status'] ?? 'Published') as String,
      students: (json['students'] as num? ?? 0).toInt(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }
}
