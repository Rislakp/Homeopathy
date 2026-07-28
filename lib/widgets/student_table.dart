// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/student_provider.dart';
// import '../utils/app_colors.dart';
// import 'student_row.dart';

// class StudentTable extends StatelessWidget {
//   const StudentTable({super.key});

//   int _getSortIndex(String column) {
//     if (column == 'name') return 1;
//     if (column == 'date') return 6;
//     if (column == 'status') return 7;
//     return 1;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<StudentProvider>();
//     final students = provider.paginatedStudents;

//     DataColumn buildSortableHeader(String label, {required VoidCallback onSort, required String sortKey}) {
//       final isCurrent = provider.sortColumn == sortKey;
//       return DataColumn(
//         onSort: (_, __) => onSort(),
//         label: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary),
//             ),
//             if (!isCurrent) ...[
//               const SizedBox(width: 4),
//               const Icon(Icons.arrow_upward, size: 12, color: AppColors.textLight),
//             ]
//           ],
//         ),
//       );
//     }

//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.cardBackground,
//         border: Border(
//           top: BorderSide(color: AppColors.border),
//           left: BorderSide(color: AppColors.border),
//           right: BorderSide(color: AppColors.border),
//         ),
//       ),
//       width: double.infinity,
//       child: Theme(
//         data: Theme.of(context).copyWith(dividerColor: AppColors.border),
//         child: DataTable(
//           headingRowColor: WidgetStateProperty.all(AppColors.background),
//           dataRowMaxHeight: 64,
//           dataRowMinHeight: 56,
//           columnSpacing: 20,
//           horizontalMargin: 20,
//           sortColumnIndex: _getSortIndex(provider.sortColumn),
//           sortAscending: provider.sortAscending,
//           columns: [
//             const DataColumn(
//               label: Center(
//                 child: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary)),
//               ),
//             ),
//             buildSortableHeader('Name', sortKey: 'name', onSort: provider.sortByName),
//             const DataColumn(
//               label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary)),
//             ),
//             const DataColumn(
//               label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary)),
//             ),
//             const DataColumn(
//               label: Text('Course', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary)),
//             ),
//             const DataColumn(
//               label: Text('Subscription', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary)),
//             ),
//             buildSortableHeader('Joined Date', sortKey: 'date', onSort: provider.sortByDate),
//             buildSortableHeader('Status', sortKey: 'status', onSort: provider.sortByStatus),
//             const DataColumn(
//               label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary)),
//             ),
//           ],
//           rows: students
//               .map((student) => StudentRow.build(context: context, student: student))
//               .toList(),
//         ),
//       ),
//     );
//   }
// }
