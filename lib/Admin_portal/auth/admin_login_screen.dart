import 'package:flutter/material.dart';
import 'package:homeopathy/Admin_portal/widgets/dashboard/login/left_panel.dart';
import 'package:homeopathy/Admin_portal/widgets/dashboard/login/login_panel.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool desktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: desktop
          ? Row(
              children: const [
                Expanded(flex: 5, child: LeftPanel()),
                Expanded(flex: 4, child: LoginPanel()),
              ],
            )
          : const LoginPanel(),
    );
  }
}
