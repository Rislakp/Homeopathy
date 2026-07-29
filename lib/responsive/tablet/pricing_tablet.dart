import 'package:flutter/material.dart';
import 'package:homeopathy/student_portal/pages/courses/courses_screen.dart';
import 'package:homeopathy/student_portal/pages/live_classes/live_classes_page.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class PricingTablet extends StatelessWidget {
  final Widget body;

  const PricingTablet({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: const Color(0xFFF7FBF9),
            selectedIndex: 5, // Pricing index is 5
            onDestinationSelected: (index) {
              if (index == 5) return;
              if (index == 0) {
                Navigator.popUntil(context, (route) => route.isFirst);
                return;
              }
              final screens = [
                null,
                const CoursesScreen(),
                LiveClassesSection(),
                const MockTest(),
                const FacultyScreen(),
                null,
              ];
              final target = screens[index];
              if (target != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => target),
                );
              }
            },
            labelType: NavigationRailLabelType.none,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_rounded, color: Color(0xff1F7A3D)),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.menu_book_rounded, color: Color(0xff1F7A3D)),
                label: Text('Courses'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.live_tv_rounded, color: Color(0xff1F7A3D)),
                label: Text('Live'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.quiz_rounded, color: Color(0xff1F7A3D)),
                label: Text('Tests'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.school_rounded, color: Color(0xff1F7A3D)),
                label: Text('Faculty'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.monetization_on_rounded, color: Color(0xff1F7A3D)),
                label: Text('Pricing'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Color(0xFFE2E8F0)),
          Expanded(child: body),
        ],
      ),
    );
  }
}
