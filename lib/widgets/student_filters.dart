import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../utils/app_colors.dart';

class StudentFilters extends StatefulWidget {
  const StudentFilters({super.key});

  @override
  State<StudentFilters> createState() => _StudentFiltersState();
}

class _StudentFiltersState extends State<StudentFilters> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _courses = [
    'Materia Medica',
    'Repertory',
    'Organon',
    'Physiology',
    'Anatomy',
    'Pathology',
  ];

  final List<String> _statuses = [
    'Active',
    'Inactive',
    'Trial',
    'Expired',
  ];

  final List<String> _subscriptions = [
    'Monthly',
    'Quarterly',
    'Yearly',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();

    if (_searchController.text != provider.searchQuery) {
      _searchController.text = provider.searchQuery;
    }

    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 768;

    Widget buildDropdown({
      required String value,
      required String label,
      required List<String> items,
      required ValueChanged<String?> onChanged,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            items: ['All', ...items].map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            style: const TextStyle(fontSize: 13),
          ),
        ),
      );
    }

    final filterWidgets = [
      Expanded(
        flex: isMobile ? 0 : 3,
        child: Container(
          color: Colors.white,
          child: TextField(
            controller: _searchController,
            onChanged: (val) => provider.searchStudents(val),
            decoration: InputDecoration(
              hintText: 'Search by name, email, phone...',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
              prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textLight),
              suffixIcon: provider.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        provider.searchStudents('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ),
      ),
      if (isMobile) const SizedBox(height: 10) else const SizedBox(width: 10),
      buildDropdown(
        value: provider.selectedCourse,
        label: 'Course',
        items: _courses,
        onChanged: (val) {
          if (val != null) provider.filterCourse(val);
        },
      ),
      if (isMobile) const SizedBox(height: 10) else const SizedBox(width: 10),
      buildDropdown(
        value: provider.selectedStatus,
        label: 'Status',
        items: _statuses,
        onChanged: (val) {
          if (val != null) provider.filterStatus(val);
        },
      ),
      if (isMobile) const SizedBox(height: 10) else const SizedBox(width: 10),
      buildDropdown(
        value: provider.selectedSubscription,
        label: 'Subscription',
        items: _subscriptions,
        onChanged: (val) {
          if (val != null) provider.filterSubscription(val);
        },
      ),
      if (isMobile) const SizedBox(height: 10) else const SizedBox(width: 10),
      TextButton.icon(
        onPressed: () {
          _searchController.clear();
          provider.clearFilters();
        },
        icon: const Icon(Icons.refresh, size: 16, color: AppColors.textSecondary),
        label: const Text(
          'Clear Filter',
          style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: filterWidgets,
            )
          : Row(
              children: filterWidgets,
            ),
    );
  }
}
