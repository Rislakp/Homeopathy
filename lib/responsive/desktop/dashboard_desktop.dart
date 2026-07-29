import 'package:flutter/material.dart';
import 'package:homeopathy/student_portal/pages/live_classes/live_classes_page.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class DashboardDesktop extends StatelessWidget {
  const DashboardDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sided row of Hero and Demo Video on Desktop
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: HeroSection()),
                  SizedBox(width: 40),
                  Expanded(flex: 4, child: DemoClassVideo()),
                ],
              ),
              SizedBox(height: 80),
              CategoryScreen(),

              SizedBox(height: 80),
              SectionHeader(),
              SizedBox(height: 32),
              _CourseGridSection(),
              SizedBox(height: 20),
              _LiveClassesSection(),

              SizedBox(height: 80),
              FacultySection(),

              SizedBox(height: 30),
              JourneySection(),

              SizedBox(height: 80),
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

// Sub-widgets to avoid duplication and keep build methods clean
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
