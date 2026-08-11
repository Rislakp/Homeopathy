import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/question_bank/widget/course_tree_item.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667085),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

