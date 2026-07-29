import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/student_provider.dart';
import 'student_body.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentProvider(),
      child: const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: SafeArea(
          child: StudentBody(),
        ),
      ),
    );
  }
}
