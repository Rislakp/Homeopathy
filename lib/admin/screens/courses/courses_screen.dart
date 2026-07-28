import 'package:flutter/material.dart';
import 'package:homeopathy/providers/course_provider.dart';
import 'package:homeopathy/screens/course_body.dart';
import 'package:provider/provider.dart';

class CourseManagementPage extends StatelessWidget {
  const CourseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider()..loadCourses(),
      child: const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: SafeArea(
          child: CourseBody(),
        ),
      ),
    );
  }
}
