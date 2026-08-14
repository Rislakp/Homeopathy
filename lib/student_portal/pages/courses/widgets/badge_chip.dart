import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/core/theme/app_colors.dart';

class BadgeChip extends StatelessWidget {
  final String label;

  const BadgeChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();

    Color bgColor = AppColors.primary;
    Color textColor = Colors.white;

    if (label.toUpperCase() == "BESTSELLER") {
      bgColor = const Color(0xFFF59E0B); // Amber
    } else if (label.toUpperCase() == "TRENDING") {
      bgColor = const Color(0xFF6366F1); // Indigo
    } else if (label.toUpperCase() == "NEW") {
      bgColor = AppColors.primaryDark; // Navy
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
