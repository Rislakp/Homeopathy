import 'package:flutter/material.dart';

enum LessonType {
  video,
  live,
  pdf,
}

class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final LessonType type;
  final String status;
  final bool isLocked;

  const Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.status,
    required this.isLocked,
  });

  Lesson copyWith({
    String? id,
    String? title,
    String? subtitle,
    LessonType? type,
    String? status,
    bool? isLocked,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      status: status ?? this.status,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class Module {
  final String id;
  final String title;
  final List<Lesson> lessons;

  const Module({
    required this.id,
    required this.title,
    required this.lessons,
  });

  Module copyWith({
    String? id,
    String? title,
    List<Lesson>? lessons,
  }) {
    return Module(
      id: id ?? this.id,
      title: title ?? this.title,
      lessons: lessons ?? this.lessons,
    );
  }
}

class Course {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String instructorName;
  final String instructorAvatar;
  final String duration;
  final int students;
  final double price;
  final String status;
  final bool isBestseller;
  final String category;
  final List<Module> modules;

  const Course({
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

  Course copyWith({
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
    List<Module>? modules,
  }) {
    return Course(
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

class VersionHistory {
  final String id;
  final String action;
  final String author;
  final String timestamp;

  const VersionHistory({
    required this.id,
    required this.action,
    required this.author,
    required this.timestamp,
  });
}
