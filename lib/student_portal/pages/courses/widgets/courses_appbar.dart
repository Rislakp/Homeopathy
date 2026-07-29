import 'package:flutter/material.dart';
import 'package:homeopathy/student_portal/widgets/dashboard/appbar.dart';

class CoursesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CoursesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomAppBar();
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
