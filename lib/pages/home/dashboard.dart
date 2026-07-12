import 'package:flutter/material.dart';
import 'package:homeopathy/provider/course_provider.dart';
import 'package:homeopathy/widgets/dashboard/course/course_card.dart';
import 'package:homeopathy/widgets/dashboard/course/section_header.dart';
import 'package:provider/provider.dart';

import 'package:homeopathy/widgets/dashboard/appbar.dart';
import 'package:homeopathy/widgets/dashboard/category_section.dart';
import 'package:homeopathy/widgets/hero_section.dart';
import 'package:homeopathy/widgets/live_class.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 60,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Hero + Live Class
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    flex: 5,
                    child: HeroSection(),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    flex: 4,
                    child: LiveClassCard(),
                  ),
                ],
              ),

              const SizedBox(height: 80),

              /// Categories
              const CategorySection(),

              const SizedBox(height: 60),

              /// Course Header
              const SectionHeader(),

              const SizedBox(height: 32),

              /// Course List
              Consumer<CourseProvider>(
                builder: (context, courseProvider, child) {
                  return SizedBox(
                    height: 460,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: courseProvider.courses.length,
                      itemBuilder: (context, index) {
                        final course =
                            courseProvider.courses[index];

                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: CourseCard(course: course),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}