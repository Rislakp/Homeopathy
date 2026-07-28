import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/course_model.dart';
import '../utils/app_colors.dart';
import 'delete_course_dialog.dart';
import 'edit_course_dialog.dart';


class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({
    super.key,
    required this.course,
  });

  IconData _getIconData(String key) {
    switch (key) {
      case 'menu_book': return Icons.menu_book;
      case 'auto_stories': return Icons.auto_stories;
      case 'troubleshoot': return Icons.troubleshoot;
      case 'history_edu': return Icons.history_edu;
      case 'accessibility': return Icons.accessibility;
      case 'favorite': return Icons.favorite;
      case 'biotech': return Icons.biotech;
      case 'groups': return Icons.groups;
      case 'vaccines': return Icons.vaccines;
      case 'local_hospital': return Icons.local_hospital;
      case 'content_cut': return Icons.content_cut;
      case 'gavel': return Icons.gavel;
      default: return Icons.book;
    }
  }

  Color _getStatusBg(String status) {
    switch (status.toLowerCase()) {
      case 'published': return AppColors.publishedBg;
      case 'draft': return AppColors.draftBg;
      case 'archived': return AppColors.archivedBg;
      default: return AppColors.draftBg;
    }
  }

  Color _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'published': return AppColors.publishedText;
      case 'draft': return AppColors.draftText;
      case 'archived': return AppColors.archivedText;
      default: return AppColors.draftText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Green Banner (Height 150)
          Stack(
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19),
                    topRight: Radius.circular(19),
                  ),
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Color(0xFF22C55E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Top Left Status Badge
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusBg(course.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    course.status,
                    style: TextStyle(
                      color: _getStatusText(course.status),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Top Right Icon Illustration
              Positioned(
                top: 20,
                right: 20,
                child: Opacity(
                  opacity: 0.15,
                  child: Icon(
                    _getIconData(course.image),
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 32,
                child: Icon(
                  _getIconData(course.image),
                  size: 40,
                  color: Colors.white,
                ),
              ),
              // Price Badge (White Floating Badge bottom right)
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    currencyFormat.format(course.price),
                    style: const TextStyle(
                      color: AppColors.primaryHover,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    course.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Course Title
                  Text(
                    course.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Instructor
                  Text(
                    'Instructor: ${course.instructor}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Student Count Row
                  Row(
                    children: [
                      const Icon(Icons.people_outline, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 6),
                      Text(
                        '${course.students} Enrolled Students',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Bottom Actions Row (Equal Width Rounded Buttons)
                  Row(
                    children: [
                      // View
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (_) => ViewCourseDialog(course: course),
                            // );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'View',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Edit
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => EditCourseDialog(course: course),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Delete
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => DeleteCourseDialog(course: course),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.archivedBg,
                            foregroundColor: AppColors.archivedText,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
