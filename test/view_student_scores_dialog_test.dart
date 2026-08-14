import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homeopathy/admin/screens/students/model/student_model.dart';
import 'package:homeopathy/admin/screens/students/widgets/view_student_scores_dialog.dart';
import 'package:homeopathy/admin/screens/students/widgets/student_row.dart';

void main() {
  testWidgets('ViewStudentScoresDialog displays exam score cards and status chips', (WidgetTester tester) async {
    final student = StudentModel(
      id: '1',
      name: 'Dr. Clara Bow',
      email: 'clara.bow@example.com',
      phone: '+1 (555) 021-9876',
      enrolledCourse: const EnrolledCourse(title: 'Homeopathy Advanced Therapeutics'),
      subscriptionDetails: const StudentSubscription(status: 'Active', type: 'VIP'),
      attendedExams: [
        const ExamScore(
          title: 'Organon & Philosophy Grand Mock',
          score: 40,
          totalMarks: 50,
          percentage: 80,
          status: 'Passed',
        ),
        const ExamScore(
          title: 'Materia Medica Clinical Mock',
          score: 16,
          totalMarks: 40,
          percentage: 40,
          status: 'Failed',
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ViewStudentScoresDialog(student: student),
        ),
      ),
    );

    // Verify student header
    expect(find.text('Dr. Clara Bow - Exam Scores'), findsOneWidget);

    // Verify exam titles
    expect(find.text('Organon & Philosophy Grand Mock'), findsOneWidget);
    expect(find.text('Materia Medica Clinical Mock'), findsOneWidget);

    // Verify status chips (found in summary banner and exam card)
    expect(find.text('Passed'), findsNWidgets(2));
    expect(find.text('Failed'), findsOneWidget);

    // Verify percentages
    expect(find.text('80.0%'), findsOneWidget);
    expect(find.text('40.0%'), findsOneWidget);
  });

  testWidgets('ViewStudentScoresDialog displays empty state when attendedExams is empty', (WidgetTester tester) async {
    final student = StudentModel(
      id: '2',
      name: 'John Doe',
      email: 'john@example.com',
      phone: '+1 (555) 000-1111',
      attendedExams: const [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ViewStudentScoresDialog(student: student),
        ),
      ),
    );

    expect(find.text('John Doe - Exam Scores'), findsOneWidget);
    expect(find.text('No exams attended yet.'), findsOneWidget);
  });

  testWidgets('StudentTable renders Score column and tapping View opens the dialog with student scores', (WidgetTester tester) async {
    final student = StudentModel(
      id: '3',
      name: 'Dr. Clara Bow',
      email: 'clara.bow@example.com',
      phone: '+1 (555) 021-9876',
      enrolledCourse: const EnrolledCourse(title: 'Organon & Philosophy'),
      subscriptionDetails: const StudentSubscription(status: 'Active', type: 'VIP'),
      attendedExams: [
        const ExamScore(
          title: 'Organon Midterm Exam',
          score: 45,
          totalMarks: 50,
          percentage: 90,
          status: 'Passed',
        ),
      ],
    );

    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Profile')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Course')),
                    DataColumn(label: Text('Score')),
                    DataColumn(label: Text('Subscription')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: [
                    StudentRow.buildDataRow(
                      context,
                      student,
                      onView: () {},
                      onEdit: () {},
                      onDelete: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    // Verify Score column is present
    expect(find.text('Score'), findsOneWidget);

    // Verify View button in Score column is present
    final viewButtonFinder = find.widgetWithText(OutlinedButton, 'View');
    expect(viewButtonFinder, findsOneWidget);

    // Tap View button
    await tester.tap(viewButtonFinder);
    await tester.pumpAndSettle();

    // Verify dialog opened displaying Clara's exam scores
    expect(find.text('Dr. Clara Bow - Exam Scores'), findsOneWidget);
    expect(find.text('Organon Midterm Exam'), findsOneWidget);
    expect(find.text('90.0%'), findsOneWidget);
  });
}
