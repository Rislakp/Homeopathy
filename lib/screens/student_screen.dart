// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/student_model.dart';
// import '../providers/student_provider.dart';
// import '../utils/app_colors.dart';
// import '../widgets/delete_dialog.dart';
// import '../widgets/empty_widget.dart';
// import '../widgets/status_chip.dart';
// import '../widgets/student_filters.dart';
// import '../widgets/student_form_dialog.dart';
// import '../widgets/student_header.dart';
// import '../widgets/student_table.dart';
// import '../widgets/student_view_dialog.dart';

// class StudentScreen extends StatelessWidget {
//   const StudentScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<StudentProvider>();
//     final double width = MediaQuery.of(context).size.width;
//     final bool isMobile = width < 768;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const StudentHeader(),
//               const StudentFilters(),
//               Expanded(
//                 child: _buildBody(context, provider, isMobile),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(BuildContext context, StudentProvider provider, bool isMobile) {
//     if (provider.isLoading) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//             ),
//             SizedBox(height: 12),
//             Text(
//               'Loading Student Database...',
//               style: TextStyle(
//                 color: AppColors.textSecondary,
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (provider.students.isEmpty) {
//       return EmptyWidget(onClear: provider.clearFilters);
//     }

//     Widget mainContent;
//     if (isMobile) {
//       mainContent = _buildMobileCardList(context, provider);
//     } else {
//       mainContent = LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minWidth: constraints.maxWidth,
//               ),
//               child: const StudentTable(),
//             ),
//           );
//         },
//       );
//     }

//     return Container(
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(
//         color: AppColors.cardBackground,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(child: mainContent),
//           const Divider(height: 1, color: AppColors.border),
//           _buildPaginationRow(provider),
//         ],
//       ),
//     );
//   }

//   Widget _buildMobileCardList(BuildContext context, StudentProvider provider) {
//     final list = provider.paginatedStudents;
//     return ListView.separated(
//       padding: const EdgeInsets.all(12),
//       itemCount: list.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 10),
//       itemBuilder: (context, index) {
//         return _buildMobileCard(context, list[index]);
//       },
//     );
//   }

//   Widget _buildMobileCard(BuildContext context, StudentModel student) {
//     final colors = [
//       const Color(0xFFEF4444),
//       const Color(0xFFF97316),
//       const Color(0xFFF59E0B),
//       const Color(0xFF10B981),
//       const Color(0xFF06B6D4),
//       const Color(0xFF3B82F6),
//       const Color(0xFF6366F1),
//       const Color(0xFF8B5CF6),
//       const Color(0xFFEC4899),
//     ];
//     final hash = student.name.codeUnits.fold(0, (sum, val) => sum + val);
//     final avatarColor = colors[hash % colors.length];

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 18,
//                 backgroundColor: avatarColor.withOpacity(0.15),
//                 child: Text(
//                   student.initials,
//                   style: TextStyle(color: avatarColor, fontSize: 13, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       student.name,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       student.email,
//                       style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
//                     ),
//                   ],
//                 ),
//               ),
//               StatusChip(status: student.status),
//             ],
//           ),
//           const SizedBox(height: 12),
//           const Divider(height: 1, color: AppColors.border),
//           const SizedBox(height: 10),
//           _buildDetailLabel('Phone', student.phone),
//           _buildDetailLabel('Course', student.course),
//           _buildDetailLabel('Subscription', student.subscription, isSub: true),
//           const SizedBox(height: 8),
//           const Divider(height: 1, color: AppColors.border),
//           const SizedBox(height: 6),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton.icon(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (_) => StudentViewDialog(student: student),
//                   );
//                 },
//                 icon: const Icon(Icons.visibility_outlined, size: 16),
//                 label: const Text('View', style: TextStyle(fontSize: 12)),
//                 style: TextButton.styleFrom(foregroundColor: AppColors.primary),
//               ),
//               const SizedBox(width: 4),
//               TextButton.icon(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (_) => StudentFormDialog(student: student),
//                   );
//                 },
//                 icon: const Icon(Icons.edit_outlined, size: 16),
//                 label: const Text('Edit', style: TextStyle(fontSize: 12)),
//                 style: TextButton.styleFrom(foregroundColor: const Color(0xFFD97706)),
//               ),
//               const SizedBox(width: 4),
//               TextButton.icon(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (_) => DeleteDialog(student: student),
//                   );
//                 },
//                 icon: const Icon(Icons.delete_outline, size: 16),
//                 label: const Text('Delete', style: TextStyle(fontSize: 12)),
//                 style: TextButton.styleFrom(foregroundColor: AppColors.expiredText),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailLabel(String label, String value, {bool isSub = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: isSub ? AppColors.primary : AppColors.textPrimary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaginationRow(StudentProvider provider) {
//     final int total = provider.filteredStudents.length;
//     final int rows = provider.rowsPerPage;
//     final int current = provider.currentPage;
//     final int pages = provider.totalPages;

//     final startIdx = total == 0 ? 0 : (current - 1) * rows + 1;
//     var endIdx = current * rows;
//     if (endIdx > total) endIdx = total;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Showing $startIdx-$endIdx of $total students',
//             style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
//           ),
//           Row(
//             children: [
//               const Text('Rows: ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: AppColors.border),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<int>(
//                     value: rows,
//                     items: [10, 25, 50, 100].map((int val) {
//                       return DropdownMenuItem<int>(
//                         value: val,
//                         child: Text('$val', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//                       );
//                     }).toList(),
//                     onChanged: (val) {
//                       if (val != null) provider.setRowsPerPage(val);
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               IconButton(
//                 icon: const Icon(Icons.chevron_left, size: 20),
//                 onPressed: current > 1 ? () => provider.previousPage() : null,
//               ),
//               Text(
//                 'Page $current / $pages',
//                 style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.chevron_right, size: 20),
//                 onPressed: current < pages ? () => provider.nextPage() : null,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
