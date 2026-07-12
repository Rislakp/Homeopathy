// A simple data model that represents one course card.
// Keeping this as a plain Dart class makes it easy to understand
// and reuse — no business logic lives here, just data.
class Course {
  final String instructor;
  final String title;
  final String duration;
  final String studentsCount;
  final double rating;
  final int ratingCount;
  final int price;
  final int originalPrice;
  final int discountPercent;
  final String tag; 
  final bool hasVideoPreview;

  const Course({
    required this.instructor,
    required this.title,
    required this.duration,
    required this.studentsCount,
    required this.rating,
    required this.ratingCount,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.tag,
    this.hasVideoPreview = false,
  });
}