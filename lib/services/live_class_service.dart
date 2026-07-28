import 'package:flutter/material.dart';
import 'package:homeopathy/admin/models/live_class_model.dart';


class LiveClassService {
  Future<List<LiveClassModel>> fetchLiveClasses() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final today = DateTime.now();

    return [
      LiveClassModel(
        id: 'lc-1',
        title: 'Materia Medica Keynotes Study',
        description: 'Analyzing essential keynotes and clinical symptoms of polychrest remedies.',
        instructor: 'Dr. Allen Kent',
        meetingLink: 'https://meet.google.com/abc-defg-hij',
        date: today.add(const Duration(days: 1)),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 30),
        duration: '1h 30m',
        enrolledStudents: 45,
        status: 'Upcoming',
        createdAt: today.subtract(const Duration(days: 2)),
      ),
      LiveClassModel(
        id: 'lc-2',
        title: 'Chronic Diseases Case Management',
        description: 'Practical live session on taking and examining chronic miasmatic cases.',
        instructor: 'Dr. Samuel Hahnemann',
        meetingLink: 'https://meet.google.com/xyz-qprs-tuv',
        date: today,
        startTime: const TimeOfDay(hour: 11, minute: 0),
        endTime: const TimeOfDay(hour: 13, minute: 0),
        duration: '2h 00m',
        enrolledStudents: 88,
        status: 'Live',
        createdAt: today.subtract(const Duration(days: 5)),
      ),
      LiveClassModel(
        id: 'lc-3',
        title: 'Organon Philosophy - Aphorisms Discussion',
        description: 'In-depth discussion on Hahnemann\'s Aphorisms 70 to 80.',
        instructor: 'Dr. J.T. Kent',
        meetingLink: 'https://meet.google.com/mno-pqrs-tuv',
        date: today.subtract(const Duration(days: 1)),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 15, minute: 15),
        duration: '1h 15m',
        enrolledStudents: 120,
        status: 'Completed',
        createdAt: today.subtract(const Duration(days: 6)),
      ),
      LiveClassModel(
        id: 'lc-4',
        title: 'Homeopathic Pharmacy Dispensing Rules',
        description: 'Reviewing the pharmacopoeia standards and preparation of potencies.',
        instructor: 'Dr. H.C. Allen',
        meetingLink: 'https://meet.google.com/jkl-mnop-qrs',
        date: today.add(const Duration(days: 3)),
        startTime: const TimeOfDay(hour: 16, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
        duration: '1h 00m',
        enrolledStudents: 0,
        status: 'Cancelled',
        createdAt: today.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
