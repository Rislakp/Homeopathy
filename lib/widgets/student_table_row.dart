// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/student_model.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_textstyles.dart';
// import 'delete_dialog.dart';
// import 'edit_student_dialog.dart';
// import 'student_avatar.dart';
// import 'student_status_chip.dart';
// import 'view_student_dialog.dart';

// class StudentTableRow {
//   static DataRow buildRow(BuildContext context, StudentModel student) {
//     final dateFormat = DateFormat.yMMMd();
    
//     void viewStudent() {
//       showDialog(
//         context: context,
//         builder: (_) => ViewStudentDialog(student: student),
//       );
//     }

//     void editStudent() {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => EditStudentDialog(student: student),
//       );
//     }

//     void deleteStudent() {
//       showDialog(
//         context: context,
//         builder: (_) => DeleteDialog(student: student),
//       );
//     }

//     return DataRow(
//       cells: [
//         // Profile Avatar
//         DataCell(
//           Center(
//             child: StudentAvatar(student: student, radius: 18),
//           ),
//         ),

//         // Student Name
//         DataCell(
//           Text(
//             student.name,
//             style: AppTextStyles.tableCellBold,
//           ),
//         ),

//         // Email
//         DataCell(
//           Text(
//             student.email,
//             style: AppTextStyles.tableCell,
//           ),
//         ),

//         // Phone
//         DataCell(
//           Text(
//             student.phone,
//             style: AppTextStyles.tableCell,
//           ),
//         ),

//         // Course
//         DataCell(
//           Text(
//             student.course,
//             style: AppTextStyles.tableCell,
//           ),
//         ),

//         // Subscription
//         DataCell(
//           Text(
//             student.subscription,
//             style: AppTextStyles.tableCellBold.copyWith(color: AppColors.primary),
//           ),
//         ),

//         // Joined Date
//         DataCell(
//           Text(
//             dateFormat.format(student.joinedDate),
//             style: AppTextStyles.tableCell,
//           ),
//         ),

//         // Status Chip
//         DataCell(
//           StudentStatusChip(status: student.status),
//         ),

//         // Actions Row
//         DataCell(
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // View
//               IconButton(
//                 icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.primary),
//                 tooltip: 'View Details',
//                 onPressed: viewStudent,
//                 hoverColor: AppColors.primaryLight,
//               ),

//               // Edit
//               // IconButton(
//               //   icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.infoText),
//               //   tooltip: 'Edit Student',
//               //   onPressed: editStudent,
//               // //  hoverColor: AppColors.infoBg,
//               // ),

//               // Delete
//               IconButton(
//                 icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.expiredText),
//                 tooltip: 'Delete Student',
//                 onPressed: deleteStudent,
//                 hoverColor: AppColors.expiredBg,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
