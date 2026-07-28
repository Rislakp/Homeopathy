// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/student_model.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_textstyles.dart';
// import 'student_avatar.dart';
// import 'student_status_chip.dart';

// class ViewStudentDialog extends StatelessWidget {
//   final StudentModel student;

//   const ViewStudentDialog({
//     super.key,
//     required this.student,
//   });

//   Widget _buildDetailRow(String label, String value, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: AppColors.inactiveBg,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, size: 18, color: AppColors.textSecondary),
//           ),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: AppTextStyles.subtitle.copyWith(fontSize: 12, color: AppColors.textLight),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: AppTextStyles.tableCellBold,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final joinedFormatted = DateFormat.yMMMMd().format(student.joinedDate);

//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 24,
//       backgroundColor: Colors.white,
//       child: Container(
//         width: 480,
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Header with Cancel Button
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Student Profile Details',
//                   style: AppTextStyles.dialogTitle,
//                 ),
//                 IconButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
//                 ),
//               ],
//             ),
//             const Divider(height: 24, color: AppColors.border),

//             // Profile Header Panel
//             Row(
//               children: [
//                 StudentAvatar(student: student, radius: 36),
//                 const SizedBox(width: 20),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         student.name,
//                         style: AppTextStyles.title.copyWith(fontSize: 20),
//                       ),
//                       const SizedBox(height: 4),
//                       StudentStatusChip(status: student.status),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Profile info grid/list
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.background,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.border),
//               ),
//               child: Column(
//                 children: [
//                   _buildDetailRow('EMAIL ADDRESS', student.email, Icons.email_outlined),
//                   const Divider(color: AppColors.border),
//                   _buildDetailRow('PHONE NUMBER', student.phone, Icons.phone_outlined),
//                   const Divider(color: AppColors.border),
//                   _buildDetailRow('ENROLLED COURSE', student.course, Icons.menu_book_outlined),
//                   const Divider(color: AppColors.border),
//                   _buildDetailRow('SUBSCRIPTION PLAN', student.subscription, Icons.card_membership_outlined),
//                   const Divider(color: AppColors.border),
//                   _buildDetailRow('JOINED DATE', joinedFormatted, Icons.calendar_month_outlined),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Bottom Actions
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 elevation: 0,
//               ),
//               child: const Text('Close Details'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
