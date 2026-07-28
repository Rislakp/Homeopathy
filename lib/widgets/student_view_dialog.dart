// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/student_model.dart';
// import '../utils/app_colors.dart';
// import 'status_chip.dart';

// class StudentViewDialog extends StatelessWidget {
//   final StudentModel student;

//   const StudentViewDialog({
//     super.key,
//     required this.student,
//   });

//   Widget _buildFieldRow(String label, String value, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: AppColors.background,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, size: 18, color: AppColors.textSecondary),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label.toUpperCase(),
//                   style: const TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textLight,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getAvatarColor(String name) {
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
//     if (name.isEmpty) return colors[0];
//     final hash = name.codeUnits.fold(0, (sum, val) => sum + val);
//     return colors[hash % colors.length];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final joinedFormatted = DateFormat.yMMMMd().format(student.joinedDate);
//     final avatarColor = _getAvatarColor(student.name);

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 440,
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Student Profile Details',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
//                 ),
//               ],
//             ),
//             const Divider(height: 24, color: AppColors.border),
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: avatarColor.withOpacity(0.15),
//                   child: Text(
//                     student.initials,
//                     style: TextStyle(
//                       color: avatarColor,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         student.name,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       StatusChip(status: student.status),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.border),
//               ),
//               child: Column(
//                 children: [
//                   _buildFieldRow('Email', student.email, Icons.email_outlined),
//                   const Divider(height: 1, color: AppColors.border),
//                   _buildFieldRow('Phone', student.phone, Icons.phone_outlined),
//                   const Divider(height: 1, color: AppColors.border),
//                   _buildFieldRow('Enrolled Course', student.course, Icons.book_outlined),
//                   const Divider(height: 1, color: AppColors.border),
//                   _buildFieldRow('Subscription', student.subscription, Icons.payment_outlined),
//                   const Divider(height: 1, color: AppColors.border),
//                   _buildFieldRow('Joined Date', joinedFormatted, Icons.calendar_month_outlined),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 elevation: 0,
//               ),
//               child: const Text('Close Button', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
