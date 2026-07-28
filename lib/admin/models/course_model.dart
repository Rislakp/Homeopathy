// import 'package:flutter/material.dart';

// class CourseModel {
//   final String id;
//   final String title;
//   final String teacherName;
//   final int studentsCount;
//   final String price;
//   final String status; // 'Published' or 'Draft'
//   final String category;
//   final IconData iconData;
//   final List<Color> gradientColors;

//   const CourseModel({
//     required this.id,
//     required this.title,
//     required this.teacherName,
//     required this.studentsCount,
//     required this.price,
//     required this.status,
//     required this.category,
//     required this.iconData,
//     this.gradientColors = const [Color(0xFF10B981), Color(0xFF059669)],
//   });

//   CourseModel copyWith({
//     String? id,
//     String? title,
//     String? teacherName,
//     int? studentsCount,
//     String? price,
//     String? status,
//     String? category,
//     IconData? iconData,
//     List<Color>? gradientColors,
//   }) {
//     return CourseModel(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       teacherName: teacherName ?? this.teacherName,
//       studentsCount: studentsCount ?? this.studentsCount,
//       price: price ?? this.price,
//       status: status ?? this.status,
//       category: category ?? this.category,
//       iconData: iconData ?? this.iconData,
//       gradientColors: gradientColors ?? this.gradientColors,
//     );
//   }
// }
