import 'package:flutter/material.dart';

enum CourseBadge {
  bestseller,
  newBadge,
  trending,
  popular,
  featured,
}

extension CourseBadgeExtension on CourseBadge {
  String get label {
    switch (this) {
      case CourseBadge.bestseller:
        return 'BESTSELLER';
      case CourseBadge.newBadge:
        return 'NEW';
      case CourseBadge.trending:
        return 'TRENDING';
      case CourseBadge.popular:
        return 'POPULAR';
      case CourseBadge.featured:
        return 'FEATURED';
    }
  }
}

class CourseModel {
  final String id;
  final String title;
  final String instructorName;
  final CourseBadge badge;
  final String category; // Used for the white rounded badge
  final double rating;
  final String duration;
  final int studentCount;
  final double price;
  final double oldPrice;
  final List<Color> gradientColors; // Custom soft green gradient colors

  const CourseModel({
    required this.id,
    required this.title,
    required this.instructorName,
    required this.badge,
    required this.category,
    required this.rating,
    required this.duration,
    required this.studentCount,
    required this.price,
    required this.oldPrice,
    required this.gradientColors,
  });
}
