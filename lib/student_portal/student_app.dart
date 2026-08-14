import 'package:flutter/material.dart';
import 'package:homeopathy/student_portal/provider/journey_provider.dart';
import 'package:homeopathy/student_portal/provider/pricing_provider.dart';
import 'package:homeopathy/student_portal/provider/stats_provider.dart';
import 'package:homeopathy/student_portal/provider/student_result_provider.dart';
import 'package:homeopathy/student_portal/provider/subscription/Subscription_Provider.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/core/theme/app_theme.dart';
import 'pages/home/dashboard.dart';
import 'provider/course_provider.dart';
import 'provider/faculty_provider.dart';

class WhiteCoatStudentPortal extends StatelessWidget {
  const WhiteCoatStudentPortal({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => FacultyProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => JourneyProvider()),
        ChangeNotifierProvider(create: (_) => PricingProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
        ChangeNotifierProvider(create: (_) => StudentResultProvider()),
       // ChangeNotifierProvider.value(value: context.read<AuthProvider>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'White Coat Academy - Student Portal',
        theme: AppTheme.studentTheme,
        home: const StudentDashboardScreen(),
        routes: {
          '/dashboard': (context) => const StudentDashboardScreen(),
        },
      ),
    );
  }
}
