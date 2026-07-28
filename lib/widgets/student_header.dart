// import 'package:flutter/material.dart';
// import '../utils/app_colors.dart';
// import 'student_form_dialog.dart';

// class StudentHeader extends StatelessWidget {
//   const StudentHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Students',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 'Manage enrolled students.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//             ],
//           ),
//           ElevatedButton.icon(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (_) => const StudentFormDialog(student: null),
//               );
//             },
//             icon: const Icon(Icons.add, size: 18),
//             label: const Text('Add Student', style: TextStyle(fontWeight: FontWeight.bold)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//               elevation: 0,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
