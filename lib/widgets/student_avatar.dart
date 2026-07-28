import 'package:flutter/material.dart';
import '../models/student_model.dart';

class StudentAvatar extends StatelessWidget {
  final StudentModel student;
  final double radius;

  const StudentAvatar({
    super.key,
    required this.student,
    this.radius = 20,
  });

  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFFEF4444), // red
      const Color(0xFFF97316), // orange
      const Color(0xFFF59E0B), // amber
      const Color(0xFF10B981), // emerald
      const Color(0xFF06B6D4), // cyan
      const Color(0xFF3B82F6), // blue
      const Color(0xFF6366F1), // indigo
      const Color(0xFF8B5CF6), // violet
      const Color(0xFFEC4899), // pink
    ];
    
    if (name.isEmpty) return colors[0];
    final hash = name.codeUnits.fold(0, (prev, element) => prev + element);
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final initials = student.initials;
    final color = _getAvatarColor(student.name);

    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withOpacity(0.15),
      child: Text(
        initials,
        style: TextStyle(
          color: color,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
