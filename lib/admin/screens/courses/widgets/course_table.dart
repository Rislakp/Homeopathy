import 'package:flutter/material.dart';
import 'package:homeopathy/admin/providers/course_management_provider.dart';
import 'package:homeopathy/admin/screens/courses/model/course_model.dart';
import 'package:homeopathy/utils/app_colors.dart';
import 'package:homeopathy/widgets/view_course_dialog.dart';
import 'package:provider/provider.dart';

class CourseTableSection extends StatelessWidget {
  const CourseTableSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseManagementNotifier>();

    if (provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    final courses = provider.filteredCourses;

    if (courses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text(
            'No courses found',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: AppColors.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 320,
            ),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppColors.background,
              ),
              horizontalMargin: 20,
              columnSpacing: 28,
              dataRowMinHeight: 68,
              dataRowMaxHeight: 72,
              columns: const [
                DataColumn(
                  label: _TableHeader('COURSE ID'),
                ),
                DataColumn(
                  label: _TableHeader('COURSE NAME'),
                ),
                DataColumn(
                  label: _TableHeader('CATEGORY'),
                ),
                DataColumn(
                  label: _TableHeader('INSTRUCTOR'),
                ),
                DataColumn(
                  label: _TableHeader('PRICE'),
                ),
                DataColumn(
                  label: _TableHeader('CREATED DATE'),
                ),
                DataColumn(
                  label: _TableHeader('ACTIONS'),
                ),
              ],
              rows: courses.map<DataRow>((course) {
                return DataRow(
                  cells: [
                    // COURSE ID
                    DataCell(
                      Text(
                        course.courseId,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    // COURSE NAME
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.menu_book_outlined,
                              size: 21,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            course.courseTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CATEGORY
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          course.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    // INSTRUCTOR
                    DataCell(
                      Text(
                        course.instructor,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    // PRICE
                    DataCell(
                      Text(
                        '₹${course.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    // CREATED DATE
                    DataCell(
                      Text(
                        _formatDate(course.createdAt),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    // ACTIONS
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // VIEW
                          IconButton(
                            tooltip: 'View Course',
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 19,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              _showViewCourseDialog(
                                context,
                                course,
                              );
                            },
                          ),

                          // EDIT
                          IconButton(
                            tooltip: 'Edit Course',
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 19,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              debugPrint(
                                'EDIT CLICKED: ${course.courseId}',
                              );
                              // TODO:
                              // Connect your Edit Course Dialog here.
                            },
                          ),

                          // DELETE
                          IconButton(
                            tooltip: 'Delete Course',
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 19,
                              color: AppColors.danger,
                            ),
                            onPressed: () {
                              debugPrint(
                                'DELETE CLICKED: ${course.courseId}',
                              );
                              provider.deleteCourse(
                                course.id,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _showViewCourseDialog(
    BuildContext context,
    CourseModel course,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return ViewCourseDialog(
          course: course,
        );
      },
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}

class _TableHeader extends StatelessWidget {
  final String title;

  const _TableHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 11,
        color: AppColors.textMuted,
      ),
    );
  }
}