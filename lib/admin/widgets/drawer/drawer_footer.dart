import 'package:flutter/material.dart';
import '../../models/admin_menu_item.dart';
import '../../theme/admin_colors.dart';

class AppDrawerFooter extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;
  final ValueChanged<AdminMenuItem> onSelectMenu;

  const AppDrawerFooter({
    super.key,
    required this.isCollapsed,
    required this.onToggleCollapse,
    required this.onSelectMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AdminColors.surface,
        border: Border(
          top: BorderSide(color: AdminColors.border, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Collapse Toggle Button
          InkWell(
            onTap: onToggleCollapse,
            borderRadius: BorderRadius.circular(AdminColors.borderRadius),
            child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 12),
              decoration: BoxDecoration(
                color: AdminColors.background,
                borderRadius: BorderRadius.circular(AdminColors.borderRadius),
              ),
              child: isCollapsed
                  ? const Center(
                      child: Icon(Icons.chevron_right_rounded, color: AdminColors.textPrimary, size: 20),
                    )
                  : const Row(
                      children: [
                        Icon(Icons.chevron_left_rounded, color: AdminColors.textPrimary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Collapse Sidebar',
                          style: TextStyle(
                            color: AdminColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 8),

          // Quick Settings & Logout
          if (!isCollapsed)
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => onSelectMenu(AdminMenuItem.generalSettings),
                    icon: const Icon(Icons.settings_outlined, size: 16, color: AdminColors.textSecondary),
                    label: const Text('Settings', style: TextStyle(color: AdminColors.textSecondary, fontSize: 12)),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _confirmLogout(context),
                    icon: const Icon(Icons.logout_rounded, size: 16, color: AdminColors.danger),
                    label: const Text('Logout', style: TextStyle(color: AdminColors.danger, fontSize: 12)),
                  ),
                ),
              ],
            ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.logout_rounded, size: 18, color: AdminColors.danger),
                  onPressed: () => _confirmLogout(context),
                  tooltip: 'Logout',
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out of White Coat Academy Admin Portal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.danger),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully.')),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
