import 'package:flutter/material.dart';
import '../../theme/admin_colors.dart';

class AppDrawerHeader extends StatelessWidget {
  final bool isCollapsed;

  const AppDrawerHeader({
    super.key,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 12 : 20,
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        color: AdminColors.surface,
        border: Border(
          bottom: BorderSide(color: AdminColors.border, width: 1),
        ),
      ),
      child: isCollapsed
          ? Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AdminColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            )
          : Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AdminColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AdminColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'White Coat',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AdminColors.textPrimary,
                              height: 1.1,
                            ),
                      ),
                      Text(
                        'ACADEMY',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AdminColors.primary,
                              fontSize: 12,
                              letterSpacing: 1.2,
                              height: 1.1,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AdminColors.primaryLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ADMIN PORTAL',
                          style: TextStyle(
                            color: AdminColors.primaryDark,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
