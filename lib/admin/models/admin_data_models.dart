import 'package:flutter/material.dart';

class AdminStatItem {
  final String title;
  final String value;
  final String changePercentage;
  final bool isPositive;
  final IconData icon;
  final Color color;

  const AdminStatItem({
    required this.title,
    required this.value,
    required this.changePercentage,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
}

class AdminTableRowData {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String date;
  final String status;
  final String amountOrMeta;
  final Color statusColor;
  final Map<String, dynamic> rawData;

  const AdminTableRowData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.date,
    required this.status,
    required this.amountOrMeta,
    required this.statusColor,
    this.rawData = const {},
  });
}

class MockDataGenerator {
  static List<AdminStatItem> getStatsForMenu(String menuTitle) {
    return [
      AdminStatItem(
        title: 'Total $menuTitle',
        value: '2,845',
        changePercentage: '+14.2%',
        isPositive: true,
        icon: Icons.analytics_rounded,
        color: const Color(0xFF10B981),
      ),
      AdminStatItem(
        title: 'Active $menuTitle',
        value: '2,120',
        changePercentage: '+8.4%',
        isPositive: true,
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF3B82F6),
      ),
      AdminStatItem(
        title: 'Pending Review',
        value: '342',
        changePercentage: '-2.1%',
        isPositive: false,
        icon: Icons.pending_actions_rounded,
        color: const Color(0xFFF59E0B),
      ),
      AdminStatItem(
        title: 'Completion Rate',
        value: '94.8%',
        changePercentage: '+5.6%',
        isPositive: true,
        icon: Icons.stars_rounded,
        color: const Color(0xFF8B5CF6),
      ),
    ];
  }

  static List<AdminTableRowData> getTableRowsForMenu(String menuTitle) {
    final List<String> statuses = ['Active', 'Completed', 'Pending', 'In Progress', 'Scheduled'];
    final List<Color> colors = [
      const Color(0xFF10B981),
      const Color(0xFF3B82F6),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFF6B7280),
    ];

    return List.generate(25, (index) {
      final statusIndex = index % statuses.length;
      return AdminTableRowData(
        id: 'WCA-${1000 + index}',
        title: '$menuTitle Record #${index + 1}',
        subtitle: 'Secondary details for record #${index + 1}',
        category: 'Section ${(index % 4) + 1}',
        date: '2026-07-${(10 + index).toString().padLeft(2, '0')}',
        status: statuses[statusIndex],
        amountOrMeta: index % 2 == 0 ? '\$${(index + 1) * 150}' : '${(index + 1) * 12} Users',
        statusColor: colors[statusIndex],
      );
    });
  }
}
