class CourseModel {
  final String title;
  final String faculty;
  final double rating;
  final int students;
  final double price;
  final double discountPrice;
  final String badge; // e.g. BESTSELLER, NEW, TRENDING
  final String category;
  final String duration;
  final String language;

  const CourseModel({
    required this.title,
    required this.faculty,
    required this.rating,
    required this.students,
    required this.price,
    required this.discountPrice,
    required this.badge,
    required this.category,
    required this.duration,
    required this.language,
  });
}
