import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/courses/model/course_model.dart';
import 'package:provider/provider.dart';
import '../provider/course_provider.dart';
import 'course_card.dart';
import 'empty_state.dart';

class CourseGrid extends StatelessWidget {
  const CourseGrid({super.key, required List<CourseModel> courses});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;

    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        final filteredCourses = provider.courses;

        if (filteredCourses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: EmptyState(),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int columns = 4;
            const double imageAspectRatio = 16 / 9;
            const double cardHeightText = 245.0; // Height bounds for text, details, pricing, and enroll action

            if (isMobile) {
              columns = 1;
            } else if (isTablet) {
              columns = 2;
            }

            final double gridWidth = constraints.maxWidth;
            const double gap = 24.0;
            final double cardWidth = (gridWidth - (gap * (columns - 1))) / columns;
            final double cardHeight = (cardWidth / imageAspectRatio) + cardHeightText;
            final double childAspectRatio = cardWidth / cardHeight;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredCourses.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: gap,
                mainAxisSpacing: gap,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                final course = filteredCourses[index];
                return CourseCard(course: course);
              },
            );
          },
        );
      },
    );
  }
}
