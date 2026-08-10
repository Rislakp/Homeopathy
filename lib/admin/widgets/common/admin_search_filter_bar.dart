import 'package:flutter/material.dart';
import 'package:homeopathy/utils/app_colors.dart';
import '../../theme/admin_colors.dart';

class AdminSearchFilterBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onExportPressed;
  final VoidCallback? onAddNewPressed;
  final String addNewLabel;

  const AdminSearchFilterBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.activeFilter,
    required this.onFilterChanged,
    required this.onExportPressed,
    this.onAddNewPressed,
    this.addNewLabel = 'Add New',
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchInput(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildFilterDropdown()),
                    const SizedBox(width: 8),
                    _buildExportButton(),
                  ],
                ),
                if (onAddNewPressed != null) ...[
                  const SizedBox(height: 12),
                  _buildAddNewButton(),
                ],
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildSearchInput()),
                const SizedBox(width: 12),
                _buildFilterDropdown(),
                const SizedBox(width: 12),
                _buildExportButton(),
                if (onAddNewPressed != null) ...[
                  const SizedBox(width: 12),
                  _buildAddNewButton(),
                ],
              ],
            ),
    );
  }

  Widget _buildSearchInput() {
    return SizedBox(
      height: 44,
      child: TextField(
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search records...',
          hintStyle: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColors.textMuted,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () => onSearchChanged(''),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    final filters = ['All', 'Active', 'Completed', 'Pending', 'In Progress'];
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: filters.contains(activeFilter) ? activeFilter : 'All',
          icon: const Icon(
            Icons.filter_list_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          items: filters.map((f) {
            return DropdownMenuItem<String>(value: f, child: Text(f));
          }).toList(),
          onChanged: (val) {
            if (val != null) onFilterChanged(val);
          },
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return OutlinedButton.icon(
      onPressed: onExportPressed,
      icon: const Icon(Icons.download_rounded, size: 18),
      label: const Text('Export'),
      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
    );
  }

  Widget _buildAddNewButton() {
    return ElevatedButton.icon(
      onPressed: onAddNewPressed,
      icon: const Icon(Icons.add_rounded, size: 20),
      label: Text(addNewLabel),
      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 44)),
    );
  }
}
