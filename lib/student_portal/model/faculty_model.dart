
class Faculty {
  final String id;
  final String name;
  final String qualification;
  final double rating;
  final int experienceYears;
  final int studentsCount;
  final List<String> tags;
  final String? imageUrl;

  const Faculty({
    required this.id,
    required this.name,
    required this.qualification,
    required this.rating,
    required this.experienceYears,
    required this.studentsCount,
    required this.tags,
    this.imageUrl,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      qualification: json['qualification'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      experienceYears: json['experienceYears'] ?? 0,
      studentsCount: json['studentsCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      imageUrl: json['imageUrl'],
    );
  }
}