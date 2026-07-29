import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onViewPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const ActionButtons({
    super.key,
    required this.onViewPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          context: context,
          icon: Icons.visibility_outlined,
          color: const Color(0xFF3B82F6), // Blue
          tooltip: 'View Profile',
          onPressed: onViewPressed,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          context: context,
          icon: Icons.edit_outlined,
          color: const Color(0xFF10B981), // Emerald
          tooltip: 'Edit Student',
          onPressed: onEditPressed,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          context: context,
          icon: Icons.delete_outline_rounded,
          color: const Color(0xFFEF4444), // Red
          tooltip: 'Delete Student',
          onPressed: onDeletePressed,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            hoverColor: color.withOpacity(0.08),
            splashColor: color.withOpacity(0.12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 18,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
