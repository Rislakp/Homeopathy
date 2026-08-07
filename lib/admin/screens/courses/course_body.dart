import 'package:flutter/material.dart';
import 'package:homeopathy/providers/course_provider.dart';
import 'package:homeopathy/admin/screens/live_classes/widgets/loading_widget.dart';
import 'package:homeopathy/widgets/course_grid.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/app_colour.dart';
import 'package:homeopathy/widgets/course_search_filter.dart';
import 'package:homeopathy/widgets/empty_course_widget.dart';
import 'package:provider/provider.dart';

class CourseBody extends StatelessWidget {
  const CourseBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 768;

    return Container(
      color: AppColors.background,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
         

            // Search input field, category drop-down, and add button
            const CourseSearchFilter(),

            // Loader or Empty catalog illustration or the responsive GridView
            Expanded(
              child: _buildMainContent(provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(CourseProvider provider) {
    if (provider.isLoading) {
      return const LoadingWidget();
    }

    if (provider.courses.isEmpty) {
      return EmptyCourseWidget(onClear: provider.clearFilters);
    }

    return SingleChildScrollView(
      child: CourseGrid(courses: provider.courses),
    );
  }
}
