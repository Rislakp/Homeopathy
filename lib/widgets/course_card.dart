
import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/courses/model/course_model.dart';
import 'package:homeopathy/admin/screens/courses/widgets/delete_course_dialog.dart';
import 'package:homeopathy/admin/screens/courses/widgets/edit%20course_dialog.dart';
import 'package:homeopathy/utils/app_colors.dart';
import 'package:intl/intl.dart';

import '../admin/screens/courses/view/course_view_screen.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({
    super.key,
    required this.course,
  });

  // ============================================================
  // COURSE ICON
  // ============================================================

  IconData _getIconData(String key) {
    switch (key) {
      case 'menu_book':
        return Icons.menu_book;
      case 'auto_stories':
        return Icons.auto_stories;
      case 'troubleshoot':
        return Icons.troubleshoot;
      case 'history_edu':
        return Icons.history_edu;
      case 'accessibility':
        return Icons.accessibility;
      case 'favorite':
        return Icons.favorite;
      case 'biotech':
        return Icons.biotech;
      case 'groups':
        return Icons.groups;
      case 'vaccines':
        return Icons.vaccines;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'content_cut':
        return Icons.content_cut;
      case 'gavel':
        return Icons.gavel;
      default:
        return Icons.book;
    }
  }

  // ============================================================
  // STATUS BACKGROUND COLOR
  // ============================================================

  Color _getStatusBg(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return AppColors.successBg;

      case 'draft':
        return AppColors.draftBg;

      case 'archived':
        return AppColors.archivedBg;

      default:
        return AppColors.background;
    }
  }

  // ============================================================
  // STATUS TEXT COLOR
  // ============================================================

  Color _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return AppColors.publishedText;

      case 'draft':
        return AppColors.draftText;

      case 'archived':
        return AppColors.archivedText;

      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(
          color: AppColors.border,
        ),
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
          // ======================================================
          // TOP BANNER
          // ======================================================

          Stack(
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.success,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // ==================================================
              // STATUS BADGE
              // ==================================================

              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
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

              // ==================================================
              // BACKGROUND ICON
              // ==================================================

              Positioned(
                top: 20,
                right: 20,
                child: Opacity(
                  opacity: 0.15,
                  child: Icon(
                    _getIconData(course.image),
                    size: 80,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),

              // ==================================================
              // MAIN ICON
              // ==================================================

              Positioned(
                top: 40,
                right: 32,
                child: Icon(
                  _getIconData(course.image),
                  size: 40,
                  color: AppColors.textOnPrimary,
                ),
              ),

              // ==================================================
              // PRICE BADGE
              // ==================================================

              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    currencyFormat.format(course.price),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ======================================================
          // COURSE DETAILS
          // ======================================================

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // CATEGORY
                  // ==================================================

                  Text(
                    course.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ==================================================
                  // COURSE TITLE
                  // ==================================================

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

                  // ==================================================
                  // INSTRUCTOR
                  // ==================================================

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

                  // ==================================================
                  // STUDENT COUNT
                  // ==================================================

                  Row(
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
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

                  // ==================================================
                  // ACTION BUTTONS
                  // ==================================================

                  Row(
                    children: [
                      // ------------------------------------------------
                      // VIEW
                      // ------------------------------------------------

                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CourseViewScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.border,
                            ),
                            foregroundColor: AppColors.textSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            'View',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // ------------------------------------------------
                      // EDIT
                      // ------------------------------------------------

                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => EditCourseDialog(
                                course: course,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.primary,
                            ),
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // ------------------------------------------------
                      // DELETE
                      // ------------------------------------------------

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => DeleteCourseDialog(
                                course: course,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.archivedBg,
                            foregroundColor: AppColors.archivedText,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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

