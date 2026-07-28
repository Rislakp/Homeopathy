// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/student_model.dart';
// import '../utils/app_colors.dart';
// import 'delete_dialog.dart';
// import 'status_chip.dart';
// import 'student_form_dialog.dart';
// import 'student_view_dialog.dart';

// class StudentRow {
//   static Color _getAvatarColor(String name) {
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

//   static DataRow build({
//     required BuildContext context,
//     required StudentModel student,
//   }) {
//     final dateFormat = DateFormat.yMMMd();
//     final avatarColor = _getAvatarColor(student.name);

//     return DataRow(
//       cells: [
//         // Profile
//         DataCell(
//           Center(
//             child: CircleAvatar(
//               radius: 16,
//               backgroundColor: avatarColor.withOpacity(0.15),
//               child: Text(
//                 student.initials,
//                 style: TextStyle(
//                   color: avatarColor,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         // Name
//         DataCell(
//           Text(
//             student.name,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//           ),
//         ),
//         // Email
//         DataCell(
//           Text(
//             student.email,
//             style: const TextStyle(fontSize: 13),
//           ),
//         ),
//         // Phone
//         DataCell(
//           Text(
//             student.phone,
//             style: const TextStyle(fontSize: 13),
//           ),
//         ),
//         // Course
//         DataCell(
//           Text(
//             student.course,
//             style: const TextStyle(fontSize: 13),
//           ),
//         ),
//         // Subscription
//         DataCell(
//           Text(
//             student.subscription,
//             style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
//           ),
//         ),
//         // Joined Date
//         DataCell(
//           Text(
//             dateFormat.format(student.joinedDate),
//             style: const TextStyle(fontSize: 13),
//           ),
//         ),
//         // Status
//         DataCell(
//           StatusChip(status: student.status),
//         ),
//         // Actions
//         DataCell(
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.primary),
//                 tooltip: 'View Profile',
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (_) => StudentViewDialog(student: student),
//                   );
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFFD97706)),
//                 tooltip: 'Edit Student',
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (_) => StudentFormDialog(student: student),
//                   );
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.expiredText),
//                 tooltip: 'Delete Student',
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (_) => DeleteDialog(student: student),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
