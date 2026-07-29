import 'package:flutter/material.dart';

class CoursesResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const CoursesResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        if (width < 600) {
          return mobile;
        } else if (width < 1024) {
          return tablet ?? mobile;
        } else {
          return desktop;
        }
      },
    );
  }
}
