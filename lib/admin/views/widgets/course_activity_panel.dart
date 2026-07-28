// import 'package:flutter/material.dart';
// import '../../models/course_management_model.dart';

// class CourseActivityPanel extends StatelessWidget {
//   final List<RecentActivityItem> activities;

//   const CourseActivityPanel({
//     super.key,
//     required this.activities,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Recent Activity',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF0F172A),
//                 ),
//               ),
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF16A34A),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           const Divider(height: 1, color: Color(0xFFF1F5F9)),
//           const SizedBox(height: 12),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: activities.length,
//             separatorBuilder: (_, __) => const Padding(
//               padding: EdgeInsets.symmetric(vertical: 8),
//               child: Divider(height: 1, color: Color(0xFFF8FAFC)),
//             ),
//             itemBuilder: (context, index) {
//               final item = activities[index];
//               return Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF1F5F9),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(item.icon, size: 16, color: const Color(0xFF16A34A)),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.text,
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xFF334155),
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           item.time,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             color: Color(0xFF94A3B8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
