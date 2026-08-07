import 'package:flutter/material.dart';
import 'package:homeopathy/utils/app_colors.dart';
import '../../models/admin_menu_item.dart';
import '../../theme/admin_colors.dart';

class DrawerSectionHeader extends StatelessWidget {
  final AdminMenuSection section;
  final bool isExpanded;
  final bool isCollapsed;
  final VoidCallback onTap;

  const DrawerSectionHeader({
    super.key,
    required this.section,
    required this.isExpanded,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Divider(height: 1, color: AppColors.border),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 12, top: 16, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              section.title,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
