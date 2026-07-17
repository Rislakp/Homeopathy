import 'package:homeopathy/Admin_portal/widgets/dashboard/login/side_drawe.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class Admin_Portal_Dashboard extends StatelessWidget {
  const Admin_Portal_Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Row(
    children: [
      const AppDrawer(),

      Expanded(
        child: Container(
          color: const Color(0xffF8FAFC),
          child: const Center(
            child: Text("Dashboard"),
          ),
        ),
      ),
    ],
  ),
);
  }
}