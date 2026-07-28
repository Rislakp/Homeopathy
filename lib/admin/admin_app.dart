import 'package:flutter/material.dart';
import 'package:homeopathy/admin/providers/video_provider.dart';
import 'package:homeopathy/admin/providers/course_management_provider.dart';
import 'package:homeopathy/admin/providers/live_class_provider.dart';
import 'package:homeopathy/admin/providers/subscription_plan_provider.dart';
import 'package:provider/provider.dart';
import 'admin_shell_layout.dart';
import 'providers/admin_data_provider.dart';
import 'providers/drawer_provider.dart';
import 'theme/admin_theme.dart';

class WhiteCoatAdminPortal extends StatelessWidget {
  const WhiteCoatAdminPortal({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(create: (_) => AdminDataProvider()),
        ChangeNotifierProvider(create: (_)=> CourseManagementNotifier()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => LiveClassProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionPlanProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'White Coat Academy - Admin Portal',
        theme: AdminTheme.lightTheme,
        home: const AdminShellLayout(),
      ),
    );
  }
}
