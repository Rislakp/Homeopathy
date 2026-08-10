import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/course_provider.dart';
import 'widgets/courses_appbar.dart';
import 'widgets/hero_section.dart';
import 'widgets/search_bar.dart';
import 'widgets/category_filter.dart';
import 'widgets/course_grid.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const _CoursesScreenContent(),
    );
  }
}

class _CoursesScreenContent extends StatelessWidget {
  const _CoursesScreenContent();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CoursesAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section Banner
            const CoursesHeroSection(),

            // Search Bar & Filter chips Container
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : (isTablet ? 32.0 : 64.0),
                vertical: 32.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    const CoursesSearchBar(),
                    const SizedBox(height: 24),
                    const CategoryFilter(),
                    const SizedBox(height: 32),
                    
                    // Courses Grid
                    const CourseGrid(courses: [],),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
