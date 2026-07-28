class CourseModel {
  final String id;
  final String title;
  final String instructor;
  final String category;
  final double price;
  final int students;
  final String status; // 'Published', 'Draft', 'Archived'
  final String description;
  final String image; // Icon or illustration code/identifier

  const CourseModel({
    required this.id,
    required this.title,
    required this.instructor,
    required this.category,
    required this.price,
    required this.students,
    required this.status,
    required this.description,
    required this.image,
  });

  CourseModel copyWith({
    String? id,
    String? title,
    String? instructor,
    String? category,
    double? price,
    int? students,
    String? status,
    String? description,
    String? image,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      category: category ?? this.category,
      price: price ?? this.price,
      students: students ?? this.students,
      status: status ?? this.status,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'category': category,
      'price': price,
      'students': students,
      'status': status,
      'description': description,
      'image': image,
    };
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      students: json['students'] as int,
      status: json['status'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
    );
  }
}
