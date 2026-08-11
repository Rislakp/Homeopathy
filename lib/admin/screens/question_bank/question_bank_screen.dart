import 'package:flutter/material.dart';
import 'question_bank_body.dart';

class QuestionBankScreen extends StatelessWidget {
  const QuestionBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF1F8F6), // Light mint background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: QuestionBankBody(),
        ),
      ),
    );
  }
}
