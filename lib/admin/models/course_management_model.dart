import 'package:flutter/material.dart';

class CourseItem {
  final String id;
  final String name;
  final String category;
  final String instructor;
  final String duration;
  final String price;
  final int students;
  final double rating;
  final String status; // 'Published' or 'Draft'
  final String language;
  final IconData thumbnailIcon;
  final Color thumbnailBgColor;

  const CourseItem({
    required this.id,
    required this.name,
    required this.category,
    required this.instructor,
    required this.duration,
    required this.price,
    required this.students,
    required this.rating,
    required this.status,
    this.language = 'English',
    required this.thumbnailIcon,
    this.thumbnailBgColor = const Color(0xFF16A34A),
  });
}

class CourseStat {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const CourseStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

class ActivityLog {
  final String text;
  final String time;
  final IconData icon;

  const ActivityLog({
    required this.text,
    required this.time,
    required this.icon,
  });
}

enum LessonType {
  file,
  video,
  live,
}

class LessonDetailModel {
  final String id;
  final String title;
  final String subtitle;
  final LessonType type;
  final String status;
  final bool isLocked;

  const LessonDetailModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.status,
    required this.isLocked,
  });
}

class ModuleDetailModel {
  final String id;
  final String title;
  final List<LessonDetailModel> lessons;

  const ModuleDetailModel({
    required this.id,
    required this.title,
    required this.lessons,
  });
}

class CourseDetailModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String duration;
  final int students;
  final String price;
  final String status;
  final bool isBestseller;
  final List<ModuleDetailModel> modules;

  const CourseDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.duration,
    required this.students,
    required this.price,
    required this.status,
    required this.isBestseller,
    required this.modules,
  });
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