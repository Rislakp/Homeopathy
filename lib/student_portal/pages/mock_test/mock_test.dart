import 'package:flutter/material.dart';
import 'package:homeopathy/student_portal/pages/mock_test/student_mock_test_screen.dart';

export 'package:homeopathy/student_portal/pages/mock_test/student_mock_test_screen.dart';

/// Legacy alias for [StudentMockTestScreen] to maintain backwards compatibility.
class MockTest extends StatelessWidget {
  const MockTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const StudentMockTestScreen();
  }
}