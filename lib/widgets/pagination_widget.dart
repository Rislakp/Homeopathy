import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_textstyles.dart';

class PaginationWidget extends StatelessWidget {
  const PaginationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
  //  final total = provider.totalStudentsCount;
    final rowsPerPage = provider.rowsPerPage;
    final current = provider.currentPage;
    final totalPages = provider.totalPages;

    // final startIdx = total == 0 ? 0 : (current - 1) * rowsPerPage + 1;
    // var endIdx = current * rowsPerPage;
    // if (endIdx > total) endIdx = total;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total items range
          // Text(
          //   'Showing $startIdx to $endIdx of $total students',
          //   style: AppTextStyles.subtitle,
          // ),

          // Pagination buttons and rows count selector
          Row(
            children: [
              // Rows Per Page Selector
              Text(
                'Rows per page: ',
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<int>(
                  value: rowsPerPage,
                  items: [10, 25, 50, 100].map((int val) {
                    return DropdownMenuItem<int>(
                      value: val,
                      child: Text('$val', style: AppTextStyles.tableCell),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      provider.setRowsPerPage(val);
                    }
                  },
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, size: 18),
                ),
              ),
              const SizedBox(width: 24),

              // Previous Page Button
              OutlinedButton(
                onPressed: current > 1 ? () => provider.previousPage() : null,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.chevron_left, size: 16),
                    const SizedBox(width: 4),
                    Text('Previous', style: AppTextStyles.tableCell),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Page indicators (e.g. "Page 1 of 5")
              Text(
                'Page $current of $totalPages',
                style: AppTextStyles.tableCellBold,
              ),
              const SizedBox(width: 8),

              // Next Page Button
              OutlinedButton(
                onPressed: current < totalPages ? () => provider.nextPage() : null,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  children: [
                    Text('Next', style: AppTextStyles.tableCell),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
