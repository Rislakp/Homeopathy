import 'package:flutter/material.dart';
import 'package:homeopathy/utils/app_colors.dart';
import '../../models/admin_menu_item.dart';
import '../../theme/admin_colors.dart';

class AdminBreadcrumbs extends StatelessWidget {
  final AdminMenuItem menuItem;

  const AdminBreadcrumbs({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(
            Icons.home_outlined,
            size: 16,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: 6),
          Text(
            'Portal',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            menuItem.section.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            menuItem.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
