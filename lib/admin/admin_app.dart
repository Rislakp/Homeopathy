import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

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
        home: const LoginScreen(),
      ),
    );
  }
}
