import 'package:flutter/material.dart';
import '../../models/admin_data_models.dart';
import '../../theme/admin_colors.dart';

class AdminDataTable extends StatelessWidget {
  final List<AdminTableRowData> rows;
  final Function(AdminTableRowData) onDelete;
  final Function(AdminTableRowData) onView;

  const AdminDataTable({
    super.key,
    required this.rows,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminColors.cardRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AdminColors.cardRadius),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 340,
            ),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AdminColors.background),
              horizontalMargin: 20,
              columnSpacing: 28,
              dataRowMaxHeight: 64,
              columns: const [
                DataColumn(
                  label: Text(
                    'ID',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'RECORD / TITLE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'CATEGORY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'DATE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'STATUS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'VALUE / META',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ACTIONS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ),
              ],
              rows: rows.map((row) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        row.id,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            row.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AdminColors.textPrimary,
                            ),
                          ),
                          Text(
                            row.subtitle,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AdminColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AdminColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          row.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        row.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AdminColors.textSecondary,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: row.statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          row.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: row.statusColor,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        row.amountOrMeta,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.visibility_rounded,
                              size: 18,
                              color: AdminColors.textSecondary,
                            ),
                            onPressed: () => onView(row),
                            tooltip: 'View Details',
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: AdminColors.info,
                            ),
                            onPressed: () {},
                            tooltip: 'Edit Record',
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: AdminColors.danger,
                            ),
                            onPressed: () => onDelete(row),
                            tooltip: 'Delete Record',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
