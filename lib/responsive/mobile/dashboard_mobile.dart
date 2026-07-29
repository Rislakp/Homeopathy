import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/student_portal/pages/courses/courses_screen.dart';
import 'package:homeopathy/student_portal/pages/live_classes/live_classes_page.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class DashboardMobile extends StatelessWidget {
  const DashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xff1F7A3D),
              child: Icon(Icons.water_drop, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              "White Coat",
              style: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xff1F7A3D)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.water_drop, color: Color(0xff1F7A3D), size: 28),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "White Coat Academy",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _drawerTile(context, Icons.dashboard_rounded, "Dashboard", null),
            _drawerTile(context, Icons.menu_book_rounded, "Courses", const CoursesScreen()),
            _drawerTile(context, Icons.live_tv_rounded, "Live Classes", LiveClassesSection()),
            _drawerTile(context, Icons.quiz_rounded, "Mock Tests", const MockTest()),
            _drawerTile(context, Icons.school_rounded, "Faculty", const FacultyScreen()),
            _drawerTile(context, Icons.monetization_on_rounded, "Pricing", const PricingScreen()),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeroSection(),
              const SizedBox(height: 24),
              const DemoClassVideo(),
              
              const SizedBox(height: 40),
              const CategoryScreen(),
              
              const SizedBox(height: 40),
              const SectionHeader(),
              const SizedBox(height: 20),
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
                          padding: const EdgeInsets.only(right: 16),
                          child: SizedBox(
                            width: 320,
                            child: CourseCard(course: course),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              LiveClassesSection(),
              
              const SizedBox(height: 40),
              const FacultySection(),
              
              const SizedBox(height: 30),
              const JourneySection(),
              
              const SizedBox(height: 40),
              const StatsSection(),
              
              const SizedBox(height: 40),
              const PricingSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerTile(BuildContext context, IconData icon, String title, Widget? targetScreen) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff1F7A3D)),
      title: Text(
        title,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer
        if (targetScreen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => targetScreen),
          );
        }
      },
    );
  }
}
