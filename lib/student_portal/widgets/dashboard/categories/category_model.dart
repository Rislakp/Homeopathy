import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String title;
  final String subtitle;
  final int courseCount;
  final IconData icon;
  final String? testCountText;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.courseCount,
    required this.icon,
    this.testCountText,
  });
}
