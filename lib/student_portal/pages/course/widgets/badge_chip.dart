import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/course_model.dart';

class BadgeChip extends StatelessWidget {
  final CourseBadge badge;

  const BadgeChip({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (badge) {
      case CourseBadge.bestseller:
        backgroundColor = const Color(0xFFD32F2F); // Crimson Red
        break;
      case CourseBadge.newBadge:
        backgroundColor = const Color(0xFF1976D2); // Deep Blue
        break;
      case CourseBadge.trending:
        backgroundColor = const Color(0xFFED6C02); // Orange/Amber
        break;
      case CourseBadge.popular:
        backgroundColor = const Color(0xFF7B1FA2); // Purple
        break;
      case CourseBadge.featured:
        backgroundColor = AppColors.primaryGreen; // Primary Green
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        badge.label,
        style: AppTextStyles.badgeText.copyWith(color: textColor),
      ),
    );
  }
}

class CategoryBadge extends StatelessWidget {
  final String text;

  const CategoryBadge({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: AppTextStyles.badgeText.copyWith(
          color: AppColors.primaryGreen,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
