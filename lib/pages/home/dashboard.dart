import 'package:flutter/material.dart';
import 'package:homeopathy/pages/live_classes/live_class.dart';
import 'package:homeopathy/widgets/dashboard/faculty/faculty_card.dart';
import 'package:homeopathy/widgets/dashboard/journey/journey_section.dart';
import 'package:homeopathy/widgets/dashboard/pricing/pricing_section.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/provider/course_provider.dart';
import 'package:homeopathy/provider/faculty_provider.dart';
import 'package:homeopathy/widgets/dashboard/course/course_card.dart';
import 'package:homeopathy/widgets/dashboard/course/section_header.dart';
import 'package:homeopathy/widgets/dashboard/appbar.dart';
import 'package:homeopathy/widgets/dashboard/category_section.dart';
import 'package:homeopathy/widgets/hero_section.dart';
import 'package:homeopathy/widgets/live_class.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FacultyProvider>().fetchFaculties();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(flex: 5, child: HeroSection()),
                  SizedBox(width: 40),
                  Expanded(flex: 4, child: LiveClassCard()),
                ],
              ),
              const SizedBox(height: 80),
              const CategorySection(),
              const SizedBox(height: 60),
              const SectionHeader(),
              const SizedBox(height: 32),
              Consumer<CourseProvider>(
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
              ),
              const SizedBox(height: 80),

              // Faculty section (badge + heading + button + grid)
              Consumer<FacultyProvider>(
                builder: (context, provider, child) {
                  if (provider.faculties.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.faculties.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (context, index) {
                      return FacultyCard(faculty: provider.faculties[index]);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              const LiveClassSection(),

              const SizedBox(height: 30),
              const JourneySection(),

              // pricing section
              const SizedBox(height: 60),
              const PricingSection(),
            ],
          ),
        ),
      ),
    );
  }
}
