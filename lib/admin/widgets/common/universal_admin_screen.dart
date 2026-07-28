// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../models/admin_data_models.dart';
// import '../../models/admin_menu_item.dart';
// import '../../providers/admin_data_provider.dart';
// import '../../theme/admin_colors.dart';
// import 'admin_breadcrumbs.dart';
// import 'admin_data_table.dart';
// import 'admin_empty_state.dart';
// import 'admin_loading_state.dart';
// import 'admin_pagination.dart';
// import 'admin_search_filter_bar.dart';
// import 'admin_stat_card.dart';

// class UniversalAdminScreen extends StatelessWidget {
//   final AdminMenuItem menuItem;
//   final Widget? customContent;

//   const UniversalAdminScreen({
//     super.key,
//     required this.menuItem,
//     this.customContent,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final dataProvider = context.watch<AdminDataProvider>();
//     final stats = MockDataGenerator.getStatsForMenu(menuItem.label);
//     final allRows = dataProvider.getRowsForMenu(menuItem);
//     final paginatedRows = dataProvider.getPaginatedRowsForMenu(menuItem);
//     final totalPages = dataProvider.getTotalPagesForMenu(menuItem);

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AdminBreadcrumbs(menuItem: menuItem),

//           if (customContent != null) ...[
//             customContent!,
//           ] else ...[
//             // 1. Metric Cards Row
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 int crossAxisCount = 4;
//                 if (constraints.maxWidth < 600) {
//                   crossAxisCount = 1;
//                 } else if (constraints.maxWidth < 1100) {
//                   crossAxisCount = 2;
//                 }

//                 return GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: crossAxisCount,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     childAspectRatio: constraints.maxWidth < 600 ? 2.2 : 1.7,
//                   ),
//                   itemCount: stats.length,
//                   itemBuilder: (context, index) {
//                     return AdminStatCard(item: stats[index]);
//                   },
//                 );
//               },
//             ),

//             const SizedBox(height: 24),

//             // 2. Toolbar (Search, Filter, Export, Add New)
//             AdminSearchFilterBar(
//               searchQuery: dataProvider.searchQuery,
//               onSearchChanged: (val) => dataProvider.setSearchQuery(val),
//               activeFilter: dataProvider.activeFilter,
//               onFilterChanged: (val) => dataProvider.setFilter(val),
//               onExportPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Exporting ${menuItem.label} records to CSV/Excel...'),
//                     backgroundColor: AdminColors.primary,
//                     duration: const Duration(seconds: 2),
//                   ),
//                 );
//               },
//               addNewLabel: 'Add ${menuItem.label}',
//               onAddNewPressed: () => _showAddDialog(context, dataProvider),
//             ),

//             const SizedBox(height: 24),

//             // 3. Main Data Area (Loading / Empty / Table)
//             if (dataProvider.isLoading) ...[
//               const AdminLoadingState(),
//             ] else if (allRows.isEmpty) ...[
//               AdminEmptyState(
//                 title: 'No ${menuItem.label} Records',
//                 message: 'No records found matching your filters. Try clearing your search.',
//                 onReset: () => dataProvider.resetFilters(),
//               ),
//             ] else ...[
//               AdminDataTable(
//                 rows: paginatedRows,
//                 onView: (row) => _showViewDialog(context, row),
//                 onDelete: (row) => dataProvider.deleteRecord(menuItem, row.id),
//               ),
//               const SizedBox(height: 16),

//               // 4. Pagination Footer
//               AdminPagination(
//                 currentPage: dataProvider.currentPage,
//                 totalPages: totalPages,
//                 totalRows: allRows.length,
//                 rowsPerPage: dataProvider.rowsPerPage,
//                 onPageChanged: (page) => dataProvider.setPage(page),
//                 onRowsPerPageChanged: (rows) => dataProvider.setRowsPerPage(rows),
//               ),
//             ],
//           ],
//         ],
//       ),
//     );
//   }

//   void _showAddDialog(BuildContext context, AdminDataProvider dataProvider) {
//     final titleController = TextEditingController();
//     final categoryController = TextEditingController(text: 'General');

//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Text('Add New ${menuItem.label}', style: const TextStyle(fontWeight: FontWeight.bold)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Title / Name',
//                   hintText: 'Enter title...',
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: categoryController,
//                 decoration: const InputDecoration(
//                   labelText: 'Category',
//                   hintText: 'Enter category...',
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (titleController.text.trim().isNotEmpty) {
//                   dataProvider.addNewRecord(
//                     menuItem,
//                     titleController.text.trim(),
//                     categoryController.text.trim(),
//                   );
//                   Navigator.pop(ctx);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Created new ${menuItem.label} successfully!'),
//                       backgroundColor: AdminColors.primary,
//                     ),
//                   );
//                 }
//               },
//               child: const Text('Create'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showViewDialog(BuildContext context, AdminTableRowData row) {
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Text(row.title, style: const TextStyle(fontWeight: FontWeight.bold)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('ID: ${row.id}', style: const TextStyle(color: AdminColors.textMuted)),
//               const SizedBox(height: 8),
//               Text('Category: ${row.category}'),
//               const SizedBox(height: 4),
//               Text('Date: ${row.date}'),
//               const SizedBox(height: 4),
//               Text('Status: ${row.status}'),
//               const SizedBox(height: 4),
//               Text('Meta: ${row.amountOrMeta}'),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
