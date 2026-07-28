import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/course_grid.dart';
import '../widgets/course_header.dart';
import '../widgets/course_search_filter.dart';
import '../widgets/empty_course_widget.dart';
import '../widgets/loading_widget.dart';

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
            // Top title and subtitle description
            const CourseHeader(),

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
