
import 'package:flutter/material.dart';

class AppColors {
  // ============================================================
  // Primary Palette
  // ============================================================

  static const Color primary = Color.fromARGB(255, 10, 5, 100);
  static const Color primaryDark = Color.fromARGB(255, 10, 5, 100);
  static const Color primaryLight = Color.fromARGB(255, 209, 250, 229);
  static const Color primaryHover = Color.fromARGB(255, 236, 253, 245);

  
  // Neutral Colors
  // ============================================================

  static const Color background = Color.fromARGB(255, 245, 247, 250);
  static const Color surface = Color.fromARGB(255, 255, 255, 255);
  static const Color drawerBackground = Color.fromARGB(255, 255, 255, 255);
  static const Color cardBackground = Color.fromARGB(255, 255, 255, 255);

  // ============================================================
  // Text Colors
  // ============================================================

  static const Color textPrimary = Color.fromARGB(255, 17, 24, 39);
  static const Color textSecondary = Color.fromARGB(255, 75, 85, 99);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Used by CourseCard
  static const Color textLight = Color(0xFF6B7280);

  // ============================================================
  // Borders & Dividers
  // ============================================================

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Admin Login Screen Blue + White Theme
  static const Color adminBlue = Color(0xFF1E40AF); // Primary Blue (Blue 800)
  static const Color adminBlueHover = Color(0xFF1D4ED8); // Blue 700
  static const Color adminBlueLight = Color(0xFFEFF6FF); // Very light blue background (Blue 50)
  static const Color adminBlueBorder = Color(0xFFBFDBFE); // Light blue border (Blue 200)

  static const Color background = Color(0xFFF8FAFC); // Very light grey background
  static const Color cardBackground = Colors.white;
  static const Color border = Color(0xFFE2E8F0); // Light grey border

  // Success / Published
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFD1FAE5);

  // Warning / Draft
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);

  // Danger / Archived
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerBg = Color(0xFFFEE2E2);

  // Info
  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0xFFDBEAFE);

  // ============================================================
  // Course Status Colors
  // ============================================================

  // Published
  static const Color publishedText = Color(0xFF047857);

  // Draft
  static const Color draftBg = Color(0xFFFEF3C7);
  static const Color draftText = Color(0xFFB45309);

  // Archived
  static const Color archivedBg = Color(0xFFFEE2E2);
  static const Color archivedText = Color(0xFFB91C1C);

  static Color? get primaryGreen => null;
}

