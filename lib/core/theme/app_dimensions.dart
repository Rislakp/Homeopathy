import 'package:flutter/material.dart';

/// Standard spacing, radius, and elevation dimensions for White Coat Academy.
class AppDimensions {
  AppDimensions._();

  // Spacing Units
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s64 = 64.0;

  // Border Radii
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 20.0;
  static const double radiusPill = 999.0;

  // BorderRadius objects
  static final BorderRadius r8 = BorderRadius.circular(radiusSmall);
  static final BorderRadius r12 = BorderRadius.circular(radiusMedium);
  static final BorderRadius r16 = BorderRadius.circular(radiusLarge);
  static final BorderRadius r20 = BorderRadius.circular(radiusExtraLarge);
  static final BorderRadius rPill = BorderRadius.circular(radiusPill);

  // Common SizedBox Helpers (Height)
  static const Widget h4 = SizedBox(height: 4);
  static const Widget h8 = SizedBox(height: 8);
  static const Widget h12 = SizedBox(height: 12);
  static const Widget h16 = SizedBox(height: 16);
  static const Widget h20 = SizedBox(height: 20);
  static const Widget h24 = SizedBox(height: 24);
  static const Widget h32 = SizedBox(height: 32);
  static const Widget h40 = SizedBox(height: 40);
  static const Widget h48 = SizedBox(height: 48);

  // Common SizedBox Helpers (Width)
  static const Widget w4 = SizedBox(width: 4);
  static const Widget w8 = SizedBox(width: 8);
  static const Widget w12 = SizedBox(width: 12);
  static const Widget w16 = SizedBox(width: 16);
  static const Widget w20 = SizedBox(width: 20);
  static const Widget w24 = SizedBox(width: 24);
  static const Widget w32 = SizedBox(width: 32);

  // Content Max Widths
  static const double maxContentWidth = 1240.0;
}
