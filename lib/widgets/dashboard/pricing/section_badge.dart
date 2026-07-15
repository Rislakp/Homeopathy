// lib/widgets/dashboard/pricing/section_badge.dart

import 'package:flutter/material.dart';
import 'package:homeopathy/widgets/common_widgetts.dart/size.dart';

class SectionBadge extends StatelessWidget {
  final String label;
  const SectionBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
          ),
          AppSpacing.w8,
          Text(
            label,
            style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}