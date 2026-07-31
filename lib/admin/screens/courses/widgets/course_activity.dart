// import 'package:flutter/material.dart';
// import 'package:homeopathy/admin/providers/course_management_provider.dart';
// import 'package:provider/provider.dart';

// class CourseActivityFeedSection extends StatelessWidget {
//   const CourseActivityFeedSection();

//   @override
//   Widget build(BuildContext context) {
//     final notifier = context.watch<CourseManagementNotifier>();

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
//           const SizedBox(height: 16),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: notifier.activities.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final act = notifier.activities[index];
//               return Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
//                     child: Icon(act.icon, size: 16, color: const Color(0xFF16A34A)),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(act.text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
//                         Text(act.time, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
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
