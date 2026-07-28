// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/course_model.dart';
// import '../utils/app_colors.dart';

// class ViewCourseDialog extends StatelessWidget {
//   final CourseModel course;

//   const ViewCourseDialog({
//     super.key,
//     required this.course,
//   });

//   IconData _getIconData(String key) {
//     switch (key) {
//       case 'menu_book': return Icons.menu_book;
//       case 'auto_stories': return Icons.auto_stories;
//       case 'troubleshoot': return Icons.troubleshoot;
//       case 'history_edu': return Icons.history_edu;
//       case 'accessibility': return Icons.accessibility;
//       case 'favorite': return Icons.favorite;
//       case 'biotech': return Icons.biotech;
//       case 'groups': return Icons.groups;
//       case 'vaccines': return Icons.vaccines;
//       case 'local_hospital': return Icons.local_hospital;
//       case 'content_cut': return Icons.content_cut;
//       case 'gavel': return Icons.gavel;
//       default: return Icons.book;
//     }
//   }

//   Widget _buildMetaBlock(String label, String value, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.background,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: AppColors.primary),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label.toUpperCase(),
//                   style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textLight),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       clipBehavior: Clip.antiAlias,
//       child: SizedBox(
//         width: 520,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Top Large Banner
//             Container(
//               height: 140,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppColors.primary, AppColors.primaryHover],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               padding: const EdgeInsets.all(20),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 32,
//                     backgroundColor: Colors.white.withOpacity(0.2),
//                     child: Icon(_getIconData(course.image), size: 36, color: Colors.white),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           course.title,
//                           style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'by ${course.instructor}',
//                           style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Content details
//             Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Meta Info Grid
//                   GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 12,
//                     crossAxisSpacing: 12,
//                     childAspectRatio: 2.8,
//                     children: [
//                       _buildMetaBlock('Category', course.category, Icons.category_outlined),
//                       _buildMetaBlock('Status', course.status, Icons.verified_outlined),
//                       _buildMetaBlock('Price', currencyFormat.format(course.price), Icons.currency_rupee),
//                       _buildMetaBlock('Enrollments', '${course.students} Students', Icons.people_outline),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // Description label & text
//                   const Text(
//                     'COURSE DESCRIPTION',
//                     style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight),
//                   ),
//                   const SizedBox(height: 6),
//                   Container(
//                     maxHeight: 120,
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: AppColors.background,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: AppColors.border),
//                     ),
//                     child: SingleChildScrollView(
//                       child: Text(
//                         course.description,
//                         style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // Close button
//                   ElevatedButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       elevation: 0,
//                     ),
//                     child: const Text('Close Button', style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
