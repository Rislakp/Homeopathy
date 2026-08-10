import 'package:flutter/material.dart';
import 'package:homeopathy/utils/app_colors.dart';
import '../../models/admin_menu_item.dart';
import '../../theme/admin_colors.dart';

class DrawerItemTile extends StatefulWidget {
  final AdminMenuItem item;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const DrawerItemTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<DrawerItemTile> createState() => _DrawerItemTileState();
}

class _DrawerItemTileState extends State<DrawerItemTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final isCollapsed = widget.isCollapsed;

    final tileColor = isSelected
        ? AppColors.primary
        : (_isHovered ? AppColors.primaryHover : Colors.transparent);

    final iconColor = isSelected
        ? Colors.white
        : (_isHovered ? AppColors.primary : AppColors.textSecondary);

    final textColor = isSelected
        ? Colors.white
        : (_isHovered ? AppColors.primary : AppColors.textPrimary);

    Widget content = InkWell(
      onTap: widget.onTap,
      onHover: (hovered) => setState(() => _isHovered = hovered),
      borderRadius: BorderRadius.circular(AppColors.borderRadius),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        padding: EdgeInsets.symmetric(
          horizontal: isCollapsed ? 0 : 12,
        ),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(AppColors.borderRadius),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: isCollapsed
            ? Center(
                child: Icon(
                  widget.item.icon,
                  color: iconColor,
                  size: 20,
                ),
              )
            : Row(
                children: [
                  Icon(
                    widget.item.icon,
                    color: iconColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.item.label,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );

    if (isCollapsed) {
      return Tooltip(
        message: widget.item.label,
        //preferredDirection: AxisDirection.right,
        child: content,
      );
    }

    return content;
  }
}
