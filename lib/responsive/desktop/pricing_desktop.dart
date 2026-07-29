import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/student_portal/pages/courses/courses_screen.dart';
import 'package:homeopathy/student_portal/pages/live_classes/live_classes_page.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class PricingDesktop extends StatelessWidget {
  final Widget body;

  const PricingDesktop({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 250,
            color: const Color(0xFFF7FBF9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xff1F7A3D),
                        child: Icon(Icons.water_drop, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "White Coat",
                            style: GoogleFonts.outfit(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "ACADEMY",
                            style: GoogleFonts.outfit(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _sidebarTile(context, Icons.dashboard_rounded, "Dashboard", null),
                      _sidebarTile(context, Icons.menu_book_rounded, "Courses", const CoursesScreen()),
                      _sidebarTile(context, Icons.live_tv_rounded, "Live Classes", LiveClassesSection()),
                      _sidebarTile(context, Icons.quiz_rounded, "Mock Tests", const MockTest()),
                      _sidebarTile(context, Icons.school_rounded, "Faculty", const FacultyScreen()),
                      _sidebarTile(context, Icons.monetization_on_rounded, "Pricing", null, isSelected: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Color(0xFFE2E8F0)),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _sidebarTile(BuildContext context, IconData icon, String title, Widget? targetScreen, {bool isSelected = false}) {
    final activeColor = const Color(0xff1F7A3D);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? activeColor.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? activeColor : Colors.grey[700]),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? activeColor : Colors.grey[800],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () {
          if (isSelected) return;
          if (targetScreen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => targetScreen),
            );
          } else {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }
}
