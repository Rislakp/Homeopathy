import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/course_model.dart';

class CourseMeta extends StatelessWidget {
  final CourseModel course;

  const CourseMeta({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Duration info
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.schedule_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              course.duration,
              style: AppTextStyles.metaData,
            ),
          ],
        ),

        // Student count
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.people_outline_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              '${formatter.format(course.studentCount)} Students',
              style: AppTextStyles.metaData,
            ),
          ],
        ),

        // Rating
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star_rounded,
              size: 18,
              color: Color(0xFFFFB300), // Rich Golden Yellow
            ),
            const SizedBox(width: 4),
            Text(
              course.rating.toString(),
              style: AppTextStyles.metaData.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
