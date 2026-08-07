import 'package:flutter/material.dart';

class CourseTreeItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int depth;
  final bool hasChildren;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback? onToggle;

  const CourseTreeItem({
    required this.label,
    required this.isSelected,
    required this.depth,
    this.hasChildren = false,
    this.isExpanded = false,
    required this.onTap,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF08A653);
    final Color lightGreen = const Color(0xFFDDF7E8);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? lightGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(width: depth * 14.0),
            if (hasChildren)
              GestureDetector(
                onTap: onToggle,
                child: Icon(
                  isExpanded ? Icons.expand_more_rounded : Icons.chevron_right_rounded,
                  size: 18,
                  color: isSelected ? primaryGreen : const Color(0xFF667085),
                ),
              )
            else
              const SizedBox(width: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? primaryGreen : const Color(0xFF172033),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}