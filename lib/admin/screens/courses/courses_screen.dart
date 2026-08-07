import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/courses/screens/course_body.dart';
import 'package:homeopathy/admin/screens/courses/provider/course_provider.dart';
import 'package:provider/provider.dart';

class CourseManagementPage extends StatelessWidget {
  const CourseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: SafeArea(
          child: CourseBody(),
        ),
      ),
    );
  }
}
