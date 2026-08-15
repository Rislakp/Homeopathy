import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:homeopathy/admin/admin_app.dart';
import 'package:homeopathy/services/auth_service.dart';
import 'package:homeopathy/student_portal/student_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(
    ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'White Coat Academy',
          routes: {
            '/': (context) => const RootApp(),
            '/admin': (context) => const WhiteCoatAdminPortal(),
            '/admin/login': (context) => const WhiteCoatAdminPortal(),
            '/student': (context) => const WhiteCoatStudentPortal(),
          },
          initialRoute: '/',
        );
      },
    ),
  );
}

/// Dynamic RootApp that initializes the application portal based on the authenticated user's role.
class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _initializeUserRole();
  }

  Future<void> _initializeUserRole() async {
    try {
      final token = await _authService.getToken();
      final role = await _authService.getUserRole();

      if (mounted) {
        setState(() {
          _userRole = (token != null && token.isNotEmpty) ? role : null;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _userRole = null;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3B82F6),
          ),
        ),
      );
    }

    // Role-based portal rendering
    final cleanRole = (_userRole ?? '').toLowerCase().trim();
    if (cleanRole == 'admin' || cleanRole == 'superadmin') {
      return const WhiteCoatAdminPortal();
    }

    // Default to Student Portal (Guest / Student mode)
    return const WhiteCoatStudentPortal();
  }
}