import 'package:flutter/material.dart';

enum LessonType {
  video,
  live,
  pdf,
}

class LessonDetail {
  final String id;
  final String title;
  final String subtitle;
  final LessonType type;
  final String status; // "Published", "Draft"
  final bool isLocked;

  const LessonDetail({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.status,
    required this.isLocked,
  });

  LessonDetail copyWith({
    String? id,
    String? title,
    String? subtitle,
    LessonType? type,
    String? status,
    bool? isLocked,
  }) {
    return LessonDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      status: status ?? this.status,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class ModuleDetail {
  final String id;
  final String title;
  final List<LessonDetail> lessons;

  const ModuleDetail({
    required this.id,
    required this.title,
    required this.lessons,
  });

  ModuleDetail copyWith({
    String? id,
    String? title,
    List<LessonDetail>? lessons,
  }) {
    return ModuleDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      lessons: lessons ?? this.lessons,
    );
  }
}

class CourseDetail {
  final String id;
  final String courseId; // e.g. "CRS-000012"
  final String title;
  final String description;
  final String instructorName;
  final String instructorAvatar;
  final String duration;
  final int students;
  final double price;
  final String status; // 'Published', 'Draft', 'Archived'
  final bool isBestseller;
  final String category;
  final List<ModuleDetail> modules;

  const CourseDetail({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.instructorName,
    required this.instructorAvatar,
    required this.duration,
    required this.students,
    required this.price,
    required this.status,
    required this.isBestseller,
    required this.category,
    required this.modules,
  });

  CourseDetail copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    String? instructorName,
    String? instructorAvatar,
    String? duration,
    int? students,
    double? price,
    String? status,
    bool? isBestseller,
    String? category,
    List<ModuleDetail>? modules,
  }) {
    return CourseDetail(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      instructorName: instructorName ?? this.instructorName,
      instructorAvatar: instructorAvatar ?? this.instructorAvatar,
      duration: duration ?? this.duration,
      students: students ?? this.students,
      price: price ?? this.price,
      status: status ?? this.status,
      isBestseller: isBestseller ?? this.isBestseller,
      category: category ?? this.category,
      modules: modules ?? this.modules,
    );
  }
}

class VersionHistoryItem {
  final String id;
  final String action;
  final String author;
  final String timestamp;

  const VersionHistoryItem({
    required this.id,
    required this.action,
    required this.author,
    required this.timestamp,
  });
}
