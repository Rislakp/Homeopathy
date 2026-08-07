import 'package:flutter/material.dart';
import 'package:homeopathy/utils/app_colors.dart';
import '../../theme/admin_colors.dart';

class AdminPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalRows;
  final int rowsPerPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onRowsPerPageChanged;

  const AdminPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalRows,
    required this.rowsPerPage,
    required this.onPageChanged,
    required this.onRowsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final startRow = totalRows == 0 ? 0 : (currentPage - 1) * rowsPerPage + 1;
    final endRow = (currentPage * rowsPerPage).clamp(0, totalRows);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: isMobile
          ? Column(
              children: [
                Text(
                  'Showing $startRow-$endRow of $totalRows entries',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 10),
                _buildPageButtons(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Rows per page: ',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: rowsPerPage,
                        items: [5, 8, 10, 20, 50].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value', style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) onRowsPerPageChanged(val);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Showing $startRow to $endRow of $totalRows entries',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                _buildPageButtons(),
              ],
            ),
    );
  }

  Widget _buildPageButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 20),
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Page $currentPage of $totalPages',
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded, size: 20),
          onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }
}
