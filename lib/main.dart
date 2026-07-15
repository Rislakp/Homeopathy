import 'package:flutter/material.dart';
import 'package:homeopathy/pages/home/dashboard.dart';
import 'package:homeopathy/provider/category_provider.dart';
import 'package:homeopathy/provider/course_provider.dart';
import 'package:homeopathy/provider/faculty_provider.dart';
import 'package:homeopathy/provider/journey_provider.dart';
import 'package:homeopathy/provider/live_classes.dart';
import 'package:homeopathy/provider/pricing_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => FacultyProvider()),
        ChangeNotifierProvider(create: (_) => PricingProvider()),
        ChangeNotifierProvider(create: (_) => JourneyProvider()),
        ChangeNotifierProvider(create: (_) => LiveClassProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AirHomoeo Academy',

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: Colors.white,

        primaryColor: const Color(0xFF2E7D32),

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),

        fontFamily: 'Poppins',
      ),

      home: const DashboardScreen(),
    );
  }
}
