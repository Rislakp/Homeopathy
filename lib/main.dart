import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homeopathy/admin/admin_app.dart';
import 'package:homeopathy/student_portal/student_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ScreenUtilInit(
      designSize: const Size(1440, 900), // Change if your Figma uses another size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const RootApp();
      },
    ),
  );
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    const bool isAdmin = true;

    return isAdmin
        ? const WhiteCoatAdminPortal()
        : const WhiteCoatStudentPortal();
  }
}