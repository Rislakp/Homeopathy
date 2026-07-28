import 'package:flutter/material.dart';
import '../models/course_model.dart';
import 'badge_chip.dart';

class CourseImage extends StatelessWidget {
  final CourseModel course;
  final double height;

  const CourseImage({
    super.key,
    required this.course,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        gradient: LinearGradient(
          colors: course.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Elegant decorative abstract blobs for premium aesthetic
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // Water drop / Homeopathy inspired icon placeholder in center
          Center(
            child: Icon(
              Icons.water_drop,
              size: 80,
              color: const Color(0xFF009A63).withOpacity(0.18),
            ),
          ),

          // Floating Top-Left Badge (Bestseller, New, etc.)
          Positioned(
            top: 20,
            left: 20,
            child: BadgeChip(badge: course.badge),
          ),

          // Floating White Rounded Badge (Top-Right Category Badge)
          Positioned(
            top: 20,
            right: 20,
            child: CategoryBadge(text: course.category),
          ),
        ],
      ),
    );
  }
}
