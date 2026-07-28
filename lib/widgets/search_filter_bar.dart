import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_textstyles.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({super.key});

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    
    // Sync text controller with provider query (e.g. if cleared from outside)
    if (_searchController.text != provider.searchQuery) {
      _searchController.text = provider.searchQuery;
    }

    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 768;

    Widget buildDropdown({
      required String? value,
      required String hint,
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
            value: value ?? 'All',
            hint: Text(hint, style: AppTextStyles.subtitle),
            items: ['All', ...items].map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: AppTextStyles.tableCell),
              );
            }).toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            style: AppTextStyles.tableCell,
          ),
        ),
      );
    }

    final List<Widget> filterWidgets = [
      // Search Box
      Expanded(
        flex: isMobile ? 0 : 3,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => provider.searchStudents(val),
            decoration: InputDecoration(
              hintText: 'Search by name, email or phone...',
              hintStyle: AppTextStyles.subtitle,
              prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textLight),
              suffixIcon: provider.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        provider.searchStudents('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
          ),
        ),
      ),
      if (isMobile) const SizedBox(height: 12) else const SizedBox(width: 12),

      // Course Filter
      // buildDropdown(
      //   value: provider.filterCourse,
      //   hint: 'Course',
      //   items: AppConstants.courses,
      //   onChanged: (val) => provider.filterStudents(course: val),
      // ),
      // if (isMobile) const SizedBox(height: 12) else const SizedBox(width: 12),

      // // Subscription Filter
      // buildDropdown(
      //   value: provider.filterSubscription,
      //   hint: 'Subscription',
      //   items: AppConstants.subscriptions,
      //   onChanged: (val) => provider.filterStudents(subscription: val),
      // ),
      // if (isMobile) const SizedBox(height: 12) else const SizedBox(width: 12),

      // Status Filter
      // buildDropdown(
      //   value: provider.filterStatus,
      //   hint: 'Status',
      //   items: AppConstants.statuses,
      //   onChanged: (val) => provider.filterStudents(status: val),
      // ),
      // if (isMobile) const SizedBox(height: 12) else const SizedBox(width: 12),

      // Reset Button
      TextButton.icon(
        onPressed: () {
          _searchController.clear();
          provider.clearFilters();
        },
        icon: const Icon(Icons.refresh, size: 16, color: AppColors.textSecondary),
        label: Text('Reset', style: AppTextStyles.tableCellBold.copyWith(color: AppColors.textSecondary)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
