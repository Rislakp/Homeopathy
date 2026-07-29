import 'package:flutter/material.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';
import 'package:homeopathy/responsive/responsive_layout.dart';
import 'package:homeopathy/responsive/mobile/dashboard_mobile.dart';
import 'package:homeopathy/responsive/tablet/dashboard_tablet.dart';
import 'package:homeopathy/responsive/desktop/dashboard_desktop.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => StudentDashboardScreenState();
}

class StudentDashboardScreenState extends State<StudentDashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FacultyProvider>().fetchFaculties();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: DashboardMobile(),
      tablet: DashboardTablet(),
      desktop: DashboardDesktop(),
    );
  }
}
