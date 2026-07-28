import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin_menu_item.dart';
import '../../providers/drawer_provider.dart';
import '../../theme/admin_colors.dart';
import 'drawer_footer.dart';
import 'drawer_header.dart';
import 'drawer_item.dart';
import 'drawer_section.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerProvider = context.watch<DrawerProvider>();
    final isCollapsed = drawerProvider.isCollapsed;
    final width = isCollapsed ? 80.0 : 280.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      width: width,
      decoration: const BoxDecoration(
        color: AdminColors.drawerBackground,
        border: Border(
          right: BorderSide(color: AdminColors.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          // 1. Top Section Header
          AppDrawerHeader(isCollapsed: isCollapsed),

          // 2. Drawer Search (Expanded view only)
          if (!isCollapsed)
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 38,
                child: TextField(
                  onChanged: (val) => drawerProvider.setDrawerSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Filter menu...',
                    hintStyle: const TextStyle(fontSize: 12, color: AdminColors.textMuted),
                    prefixIcon: const Icon(Icons.search_rounded, size: 16, color: AdminColors.textMuted),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    fillColor: AdminColors.background,
                  ),
                ),
              ),
            ),

          // 3. Middle Scrollable Navigation List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _buildNavSections(context, drawerProvider),
            ),
          ),

          // 4. Bottom Footer
          AppDrawerFooter(
            isCollapsed: isCollapsed,
            onToggleCollapse: () => drawerProvider.toggleCollapse(),
            onSelectMenu: (menu) => drawerProvider.selectMenu(menu),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNavSections(BuildContext context, DrawerProvider drawerProvider) {
    final isCollapsed = drawerProvider.isCollapsed;
    final query = drawerProvider.drawerSearchQuery.toLowerCase();
    final List<Widget> widgets = [];

    for (final section in AdminMenuSection.values) {
      final sectionItems = AdminMenuItem.values
          .where((item) => item.section == section)
          .where((item) => query.isEmpty || item.label.toLowerCase().contains(query))
          .toList();

      if (sectionItems.isEmpty) continue;

      final isExpanded = drawerProvider.isSectionExpanded(section) || query.isNotEmpty;

      widgets.add(
        DrawerSectionHeader(
          section: section,
          isExpanded: isExpanded,
          isCollapsed: isCollapsed,
          onTap: () => drawerProvider.toggleSection(section),
        ),
      );

      if (isExpanded || isCollapsed) {
        for (final item in sectionItems) {
          widgets.add(
            DrawerItemTile(
              item: item,
              isSelected: drawerProvider.selectedMenu == item,
              isCollapsed: isCollapsed,
              onTap: () {
                drawerProvider.selectMenu(item);
                // Close mobile drawer if open
                if (Scaffold.of(context).isDrawerOpen) {
                  Navigator.pop(context);
                }
              },
            ),
          );
        }
      }
    }

    return widgets;
  }
}
