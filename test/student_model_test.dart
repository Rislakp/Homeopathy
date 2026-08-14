import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:homeopathy/admin/screens/students/model/student_model.dart';

void main() {
  group('StudentModel JSON Parsing Tests', () {
    const rawJsonString = '''
    {
      "id": "67ad10e53a29b4e72352fa10",
      "student_id": "67ad10e53a29b4e72352fa10",
      "name": "Dr. Clara Bow",
      "email": "clara.bow@example.com",
      "phone": "+1 (555) 021-9876",
      "contact_number": "+1 (555) 021-9876",
      "date_of_birth": "1995-05-12",
      "qualification": "BHMS Graduate",
      "profile_image": "https://example.com/uploads/clara.png",
      "avatar": "https://example.com/uploads/clara.png",
      "enrolled_course": {
        "id": "CRS-000001",
        "title": "Homeopathy Advanced Therapeutics",
        "category": "Homeopathy",
        "price": 4999
      },
      "subscription": {
        "status": "Active",
        "type": "VIP",
        "joined_date": "2025-11-01T00:00:00.000Z"
      },
      "stats": {
        "total_exams_attended": 2,
        "average_score": 60,
        "passed_exams": 1
      },
      "attended_exams": [
        {
          "exam_id": "67ad10e53a29b4e72352fa15",
          "title": "Organon & Philosophy Grand Mock",
          "score": 40,
          "total_marks": 50,
          "total_attempted": 25,
          "total_correct": 20,
          "total_wrong": 5,
          "percentage": 80,
          "status": "Passed",
          "submitted_at": "2026-02-14T06:00:00.000Z"
        },
        {
          "exam_id": "67ad10e53a29b4e72352fa16",
          "title": "Materia Medica Clinical Mock",
          "score": 16,
          "total_marks": 40,
          "total_attempted": 10,
          "total_correct": 4,
          "total_wrong": 6,
          "percentage": 40,
          "status": "Failed",
          "submitted_at": "2026-02-12T14:30:00.000Z"
        }
      ],
      "created_at": "2025-11-01T00:00:00.000Z",
      "updated_at": "2026-02-14T06:00:00.000Z"
    }
    ''';

    test('Parses full student response with all nested fields', () {
      final jsonMap = json.decode(rawJsonString) as Map<String, dynamic>;
      final student = StudentModel.fromJson(jsonMap);

      expect(student.id, '67ad10e53a29b4e72352fa10');
      expect(student.name, 'Dr. Clara Bow');
      expect(student.email, 'clara.bow@example.com');
      expect(student.phone, '+1 (555) 021-9876');
      expect(student.initials, 'CB');
      expect(student.avatarText, 'CB');

      // Course checks
      expect(student.course, 'Homeopathy Advanced Therapeutics');
      expect(student.enrolledCourse.id, 'CRS-000001');
      expect(student.enrolledCourse.price, 4999.0);

      // Subscription checks
      expect(student.subscription, 'VIP');
      expect(student.status, 'Active');
      expect(student.subscriptionDetails.joinedDate, isNotNull);

      // Stats checks
      expect(student.stats.totalExamsAttended, 2);
      expect(student.stats.averageScore, 60.0);
      expect(student.stats.passedExams, 1);

      // Attended exams checks
      expect(student.attendedExams.length, 2);
      final exam1 = student.attendedExams[0];
      expect(exam1.title, 'Organon & Philosophy Grand Mock');
      expect(exam1.score, 40.0);
      expect(exam1.totalMarks, 50.0);
      expect(exam1.percentage, 80.0);
      expect(exam1.status, 'Passed');
      expect(exam1.totalAttempted, 25);
      expect(exam1.totalCorrect, 20);
      expect(exam1.totalWrong, 5);

      final exam2 = student.attendedExams[1];
      expect(exam2.title, 'Materia Medica Clinical Mock');
      expect(exam2.score, 16.0);
      expect(exam2.totalMarks, 40.0);
      expect(exam2.percentage, 40.0);
      expect(exam2.status, 'Failed');
    });

    test('Handles fallback when optional nested structures are null or strings', () {
      final minimalJson = {
        'id': '101',
        'name': 'Amit Kumar',
        'email': 'amit@test.com',
        'phone': '9876543210',
        'course': 'Classical Homeopathy',
        'subscription': 'Monthly',
        'status': 'Trial',
      };

      final student = StudentModel.fromJson(minimalJson);
      expect(student.id, '101');
      expect(student.name, 'Amit Kumar');
      expect(student.course, 'Classical Homeopathy');
      expect(student.subscription, 'Monthly');
      expect(student.status, 'Trial');
      expect(student.attendedExams, isEmpty);
      expect(student.initials, 'AK');
    });
  });
}
