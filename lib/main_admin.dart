/// ─────────────────────────────────────────────────────────────────
/// Admin Portal Entry Point — White Coat Academy
/// ─────────────────────────────────────────────────────────────────
/// This is the ONLY new file added. It does NOT rewrite, duplicate,
/// or modify any existing Admin Portal code.
///
/// It simply bootstraps the already-existing [WhiteCoatAdminPortal]
/// widget from lib/admin/admin_app.dart as a standalone Flutter app.
///
/// Run command:
///   flutter run -d chrome -t lib/main_admin.dart --web-port 3000
///
/// URL: http://localhost:3000
/// 


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:homeopathy/admin/admin_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Same Hive initialization as the main app
  await Hive.initFlutter();

  runApp(
    ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => const WhiteCoatAdminPortal(),
    ),
  );
}
