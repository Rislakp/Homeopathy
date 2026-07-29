import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color dotColor;

    switch (status.toLowerCase()) {
      case 'active':
        bgColor = const Color(0xFFE6FDF4); // Emerald 50
        textColor = const Color(0xFF047857); // Emerald 700
        dotColor = const Color(0xFF10B981); // Emerald 500
        break;
      case 'trial':
        bgColor = const Color(0xFFEFF6FF); // Blue 50
        textColor = const Color(0xFF1D4ED8); // Blue 700
        dotColor = const Color(0xFF3B82F6); // Blue 500
        break;
      case 'expired':
        bgColor = const Color(0xFFFEF2F2); // Red 50
        textColor = const Color(0xFFB91C1C); // Red 700
        dotColor = const Color(0xFFEF4444); // Red 500
        break;
      case 'inactive':
      default:
        bgColor = const Color(0xFFF9FAFB); // Gray 50
        textColor = const Color(0xFF4B5563); // Gray 600
        dotColor = const Color(0xFF9CA3AF); // Gray 400
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: dotColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
