import 'package:flutter/material.dart';
import '../models/course_model.dart';
import 'course_card.dart';

class CourseGrid extends StatelessWidget {
  final List<CourseModel> courses;

  const CourseGrid({
    super.key,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        
        // Define columns based on width
        int cols = 3;
        if (width < 640) {
          cols = 1;
        } else if (width < 1024) {
          cols = 2;
        }

        // Calculate card width and dynamic aspect ratio to target ~360px height
        final double spacingTotal = (cols - 1) * 24.0;
        final double cardWidth = (width - spacingTotal) / cols;
        final double childAspectRatio = cardWidth / 360;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            return CourseCard(course: courses[index]);
          },
        );
      },
    );
  }
}
