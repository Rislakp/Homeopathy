import 'package:flutter/material.dart';
import 'package:homeopathy/admin/admin_app.dart';
import 'package:homeopathy/student_portal/student_app.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
      bool isAdmin = false
      ;

    return isAdmin
        ? const WhiteCoatAdminPortal()
        : const WhiteCoatStudentPortal();
  }
}