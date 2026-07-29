import 'package:flutter/material.dart';
import '../model/student_model.dart';
import 'status_chip.dart';
import 'action_buttons.dart';

class StudentRow {
  static Color getAvatarBgColor(String name) {
    final hash = name.hashCode;
    final colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF10B981), // Emerald
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEC4899), // Pink
      const Color(0xFF06B6D4), // Cyan
    ];
    return colors[hash.abs() % colors.length];
  }

  static DataRow buildDataRow(
    BuildContext context,
    StudentModel student, {
    required VoidCallback onView,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    final avatarColor = getAvatarBgColor(student.name);
    return DataRow(
      cells: [
        // Profile Avatar
        DataCell(
          CircleAvatar(
            radius: 18,
            backgroundColor: avatarColor.withOpacity(0.12),
            child: Text(
              student.avatarText,
              style: TextStyle(
                color: avatarColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        // Name
        DataCell(
          Text(
            student.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
              fontSize: 14,
            ),
          ),
        ),
        // Email
        DataCell(
          Text(
            student.email,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 14,
            ),
          ),
        ),
        // Phone
        DataCell(
          Text(
            student.phone,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 14,
            ),
          ),
        ),
        // Course
        DataCell(
          Text(
            student.course,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        // Subscription
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              student.subscription,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        // Status
        DataCell(
          StatusChip(status: student.status),
        ),
        // Actions
        DataCell(
          ActionButtons(
            onViewPressed: onView,
            onEditPressed: onEdit,
            onDeletePressed: onDelete,
          ),
        ),
      ],
    );
  }
}
