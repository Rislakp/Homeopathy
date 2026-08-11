import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/course_management_model.dart';
import '../../../../providers/course_management_provider.dart';

class LessonListTile extends StatelessWidget {
  final String moduleId;
  final LessonDetailModel lesson;

  const LessonListTile({
    super.key,
    required this.moduleId,
    required this.lesson,
  });

  IconData _getIconData(LessonType type) {
    switch (type) {
      case LessonType.video:
        return Icons.play_circle_outline_rounded;
      case LessonType.live:
        return Icons.sensors_rounded;
      case LessonType.file:
        return Icons.picture_as_pdf_outlined;
    }
  }

  Color _getIconColor(LessonType type) {
    switch (type) {
      case LessonType.video:
        return Colors.teal;
      case LessonType.live:
        return const Color(0xFFEF4444); // Red for live
      case LessonType.file:
        return const Color(0xFF3B82F6); // Blue for File
    }
  }

  Color _getStatusBg(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return const Color(0xFFD1FAE5);
      case 'draft':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return const Color(0xFF065F46);
      case 'draft':
        return const Color(0xFF92400E);
      default:
        return const Color(0xFF374151);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CourseManagementNotifier>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          // Drag handle/indicator (subtle line)
          Container(
            width: 3,
            height: 32,
            decoration: BoxDecoration(
              color: _getIconColor(lesson.type).withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),

          // Lesson Type Icon
          Icon(
            _getIconData(lesson.type),
            color: _getIconColor(lesson.type),
            size: 20,
          ),
          const SizedBox(width: 16),

          // Lesson Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lesson.subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Status Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusBg(lesson.status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              lesson.status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _getStatusText(lesson.status),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Lock Status
          Icon(
            lesson.isLocked ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
            size: 16,
            color: lesson.isLocked ? const Color(0xFF94A3B8) : Colors.teal,
          ),

          const SizedBox(width: 16),

          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Previewing lesson: ${lesson.title}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                tooltip: 'Preview Lesson',
                icon: const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF64748B)),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Edit feature space for: ${lesson.title}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                tooltip: 'Edit Lesson',
                icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF64748B)),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
              ),
              IconButton(
                onPressed: () async {
                  // Confirm delete
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Lesson'),
                      content: Text('Are you sure you want to delete "${lesson.title}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    provider.deleteLesson(moduleId, lesson.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lesson deleted successfully.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
                tooltip: 'Delete Lesson',
                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
