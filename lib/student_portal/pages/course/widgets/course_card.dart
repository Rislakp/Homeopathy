import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/course_model.dart';
import '../providers/course_provider.dart';
import 'course_image.dart';
import 'course_meta.dart';
import 'enroll_button.dart';

class CourseCard extends StatefulWidget {
  final CourseModel course;
  final double imageHeight;

  const CourseCard({
    super.key,
    required this.course,
    required this.imageHeight,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(_isHovered ? 0.12 : AppColors.shadowOpacity),
              blurRadius: _isHovered ? 45.0 : AppColors.shadowBlurRadius,
              offset: Offset(0, _isHovered ? 20 : 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Rounded top image area with gradients and overlays
              CourseImage(
                course: widget.course,
                height: widget.imageHeight,
              ),

              // Content Padding (Padding: 20, Gap: 16)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instructor Name (12pt Medium Grey)
                    Text(
                      widget.course.instructorName,
                      style: AppTextStyles.instructor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Course Title (34pt Bold, Maximum 2 lines)
                    SizedBox(
                      height: 80, // Keeps the layout grid uniform
                      child: Text(
                        widget.course.title,
                        style: AppTextStyles.courseTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Meta Data Row (Duration, Students, Rating)
                    CourseMeta(course: widget.course),
                    const SizedBox(height: 16),

                    // Divider
                    const Divider(
                      color: AppColors.border,
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(height: 16),

                    // Pricing and Enroll Button Row
                    Row(
                      children: [
                        // Pricing Block
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currencyFormatter.format(widget.course.price),
                                style: AppTextStyles.price,
                              ),
                              Text(
                                currencyFormatter.format(widget.course.oldPrice),
                                style: AppTextStyles.oldPrice,
                              ),
                            ],
                          ),
                        ),

                        // Enroll Button (Height 54, Radius 30)
                        Consumer<CourseProvider>(
                          builder: (context, provider, child) {
                            final isEnrolled = provider.isEnrolled(widget.course.id);
                            return Flexible(
                              child: EnrollButton(
                                isEnrolled: isEnrolled,
                                onTap: () {
                                  if (!isEnrolled) {
                                    provider.enrollCourse(widget.course.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Enrolled successfully in ${widget.course.title}!'),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: AppColors.primaryGreen,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
