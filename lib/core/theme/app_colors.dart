import 'package:flutter/material.dart';

/// Centralized color palette for White Coat Academy.
/// Professional Medical Blue + Navy + White theme.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Primary Medical Blue Palette
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF2563EB); // Royal Medical Blue
  static const Color primaryDark = Color(0xFF1E40AF); // Deep Navy Blue
  static const Color primaryLight = Color(0xFFEFF6FF); // Very light blue tint
  static const Color primaryHover = Color(0xFF1D4ED8); // Blue 700 on hover
  static const Color primaryBorder = Color(0xFFBFDBFE); // Light blue border

  // ---------------------------------------------------------------------------
  // Secondary & Neutral Navy Palette
  // ---------------------------------------------------------------------------
  static const Color secondary = Color(0xFF0F172A); // Dark Slate / Navy
  static const Color secondaryLight = Color(0xFF1E293B); // Slate 800
  static const Color navy = Color(0xFF0A0564); // Dark Academy Navy

  // ---------------------------------------------------------------------------
  // Backgrounds & Surfaces
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFFF8FAFC); // Clean light background
  static const Color surface = Color(0xFFFFFFFF); // Clean white card surface
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color drawerBackground = Color(0xFFFFFFFF);
  static const Color scaffoldBg = Color(0xFFF8FAFC);

  // ---------------------------------------------------------------------------
  // Typography Colors
  // ---------------------------------------------------------------------------
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Borders, Lines & Dividers
  // ---------------------------------------------------------------------------
  static const Color border = Color(0xFFE2E8F0); // Subtle Slate border
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFF1F5F9);

  // ---------------------------------------------------------------------------
  // Semantic Status Colors (Used ONLY where semantically appropriate)
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color successText = Color(0xFF15803D);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningText = Color(0xFFB45309);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color dangerText = Color(0xFFB91C1C);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0xFFEFF6FF);

  // Status mapping aliases
  static const Color publishedBg = Color(0xFFEFF6FF);
  static const Color publishedText = Color(0xFF1E40AF);
  static const Color draftBg = Color(0xFFFEF3C7);
  static const Color draftText = Color(0xFFB45309);
  static const Color archivedBg = Color(0xFFFEE2E2);
  static const Color archivedText = Color(0xFFB91C1C);

  // Admin portal aliases for full backwards compatibility
  static const Color adminBlue = primaryDark;
  static const Color adminBlueHover = Color(0xFF172554);
  static const Color adminBlueLight = primaryLight;
  static const Color adminBlueBorder = primaryBorder;

  // Legacy alias redirected to primary Medical Blue
  static const Color primaryGreen = primary;

  // ---------------------------------------------------------------------------
  // Radius & Shadows
  // ---------------------------------------------------------------------------
  static const double borderRadius = 12.0;
  static const double cardRadius = 16.0;

  static final List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> hoverShadow = [
    BoxShadow(
      color: const Color(0xFF1E40AF).withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
