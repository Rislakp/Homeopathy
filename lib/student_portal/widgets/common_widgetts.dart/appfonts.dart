import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/core/theme/app_colors.dart';

/// Font helper styles referencing the central Medical Blue palette.
class AppFonts {
  AppFonts._();

  // Large
  static TextStyle largeBold = GoogleFonts.inter(
    fontSize: 56,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryDark,
    letterSpacing: -1,
  );

  static TextStyle largeSemiBold = GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle largeMedium = GoogleFonts.inter(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Medium
  static TextStyle mediumBold = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle mediumSemiBold = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle mediumMedium = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Small
  static TextStyle smallBold = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle smallSemiBold = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle smallMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Extra Small
  static TextStyle extraSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}