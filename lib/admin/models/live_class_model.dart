import 'package:flutter/material.dart';

class LiveClassModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String meetingLink;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String duration;
  final int enrolledStudents;
  final String status; // 'Upcoming', 'Live', 'Completed', 'Cancelled'
  final DateTime createdAt;

  const LiveClassModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.meetingLink,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.enrolledStudents,
    required this.status,
    required this.createdAt,
  });

  LiveClassModel copyWith({
    String? id,
    String? title,
    String? description,
    String? instructor,
    String? meetingLink,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? duration,
    int? enrolledStudents,
    String? status,
    DateTime? createdAt,
  }) {
    return LiveClassModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      meetingLink: meetingLink ?? this.meetingLink,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      enrolledStudents: enrolledStudents ?? this.enrolledStudents,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
