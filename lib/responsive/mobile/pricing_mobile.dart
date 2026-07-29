import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/student_portal/pages/courses/courses_screen.dart';
import 'package:homeopathy/student_portal/pages/live_classes/live_classes_page.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class PricingMobile extends StatelessWidget {
  final Widget body;

  const PricingMobile({super.key, required this.body});

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
        title: Text(
          "Pricing",
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
            _drawerTile(context, Icons.monetization_on_rounded, "Pricing", null, isCurrent: true),
          ],
        ),
      ),
      body: SafeArea(child: body),
    );
  }

  Widget _drawerTile(BuildContext context, IconData icon, String title, Widget? targetScreen, {bool isCurrent = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff1F7A3D)),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
          color: isCurrent ? const Color(0xff1F7A3D) : Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (isCurrent) return;
        if (targetScreen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => targetScreen),
          );
        } else {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
    );
  }
}
