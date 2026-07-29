import 'package:flutter/material.dart';
import 'package:homeopathy/student_portal/pages/live_classes/live_classes_page.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class DashboardTablet extends StatelessWidget {
  const DashboardTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: HeroSection()),
                  SizedBox(width: 24),
                  Expanded(flex: 4, child: DemoClassVideo()),
                ],
              ),
              SizedBox(height: 60),
              CategoryScreen(),
              
              SizedBox(height: 60),
              SectionHeader(),
              SizedBox(height: 24),
              _CourseGridSection(),
              SizedBox(height: 30),
              _LiveClassesSection(),
              
              SizedBox(height: 60),
              FacultySection(),
              
              SizedBox(height: 30),
              JourneySection(),
              
              SizedBox(height: 60),
              StatsSection(),
              
              SizedBox(height: 60),
              PricingSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseGridSection extends StatelessWidget {
  const _CourseGridSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (courseProvider.courses.isEmpty) {
          return const Text("No courses found");
        }
        return SizedBox(
          height: 460,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courseProvider.courses.length,
            itemBuilder: (context, index) {
              final course = courseProvider.courses[index];
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CourseCard(course: course),
              );
            },
          ),
        );
      },
    );
  }
}

class _LiveClassesSection extends StatelessWidget {
  const _LiveClassesSection();

  @override
  Widget build(BuildContext context) {
    return LiveClassesSection();
  }
}
