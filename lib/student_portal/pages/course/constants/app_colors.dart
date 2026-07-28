import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryGreen = Color(0xFF00A86B);
  static const Color buttonGreen = Color(0xFF009A63);
  static const Color background = Color(0xFFF7FBF9);
  static const Color card = Colors.white;

  // Premium text colors
  static const Color textPrimary = Color(0xFF1E293B);   // Slate 800
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textLight = Color(0xFF94A3B8);     // Slate 400
  static const Color border = Color(0xFFE2E8F0);        // Slate 200

  // Shadow specifications
  static const Color shadowColor = Color(0xFF000000);
  static const double shadowOpacity = 0.08;
  static const double shadowBlurRadius = 35.0;
  static final BoxShadow premiumShadow = BoxShadow(
    color: shadowColor.withOpacity(shadowOpacity),
    blurRadius: shadowBlurRadius,
    offset: const Offset(0, 15),
  );
}
