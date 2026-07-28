// import 'package:flutter/material.dart';
// import '../../models/course_management_model.dart';

// class CourseDataTable extends StatelessWidget {
//   final List<CourseItemModel> courses;
//   final Function(CourseItemModel) onView;
//   final Function(CourseItemModel) onEdit;
//   final Function(CourseItemModel) onDelete;

//   const CourseDataTable({
//     super.key,
//     required this.courses,
//     required this.onView,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (courses.isEmpty) {
//       return Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: const Color(0xFFE2E8F0)),
//         ),
//         child: const Column(
//           children: [
//             Icon(Icons.search_off_rounded, size: 44, color: Color(0xFF94A3B8)),
//             SizedBox(height: 12),
//             Text(
//               'No Courses Found',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: Color(0xFF0F172A),
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'Try adjusting your search criteria or filter dropdowns.',
//               style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
//             ),
//           ],
//         ),
//       );
//     }

//     return Container(
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
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minWidth: MediaQuery.of(context).size.width - 320,
//             ),
//             child: DataTable(
//               headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
//               horizontalMargin: 20,
//               columnSpacing: 24,
//               dataRowMaxHeight: 68,
//               dividerThickness: 1,
//               columns: const [
//                 DataColumn(
//                   label: Text(
//                     'THUMBNAIL',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF64748B),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'COURSE NAME',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF64748B),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'CATEGORY',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF64748B),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'INSTRUCTOR',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF64748B),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'DURATION',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF64748B),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'PRICE',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF64748B),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'STUDENTS',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF64748B),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'RATING',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF64748B),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'STATUS',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF64748B),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Text(
//                     'ACTIONS',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF64748B),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//               ],
//               rows: courses.map((course) {
//                 final isPublished = course.status == 'Published';

//                 return DataRow(
//                   cells: [
//                     // Course Thumbnail
//                     DataCell(
//                       Container(
//                         width: 44,
//                         height: 44,
//                         decoration: BoxDecoration(
//                           color:
//                               course.thumbnailBgColor?.withOpacity(0.12) ??
//                               Colors.transparent,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Icon(
//                           course.thumbnailIcon,
//                           color:
//                               course.thumbnailBgColor ??
//                               const Color(0xFF64748B),
//                           size: 22,
//                         ),
//                       ),
//                     ),

//                     // Course Name
//                     DataCell(
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             course.name,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                               color: Color(0xFF0F172A),
//                             ),
//                           ),
//                           Text(
//                             course.id,
//                             style: const TextStyle(
//                               fontSize: 11,
//                               color: Color(0xFF94A3B8),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Category
//                     DataCell(
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF1F5F9),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           course.category,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Color(0xFF475569),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Instructor
//                     DataCell(
//                       Row(
//                         children: [
//                           const CircleAvatar(
//                             radius: 12,
//                             backgroundColor: Color(0xFFE2E8F0),
//                             child: Icon(
//                               Icons.person_rounded,
//                               size: 14,
//                               color: Color(0xFF64748B),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             course.instructor,
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xFF334155),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Duration
//                     DataCell(
//                       Text(
//                         course.duration ?? '',
//                         style: const TextStyle(
//                           fontSize: 13,
//                           color: Color(0xFF475569),
//                         ),
//                       ),
//                     ),

//                     // Price
//                     DataCell(
//                       Text(
//                         course.price,
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w800,
//                           color: Color(0xFF0F172A),
//                         ),
//                       ),
//                     ),

//                     // Students
//                     DataCell(
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.people_alt_outlined,
//                             size: 15,
//                             color: Color(0xFF64748B),
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             '${course.students}',
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF334155),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Rating
//                     DataCell(
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.star_rounded,
//                             size: 16,
//                             color: Color(0xFFF59E0B),
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${course.rating}',
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF0F172A),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Status (Published = Green Badge, Draft = Orange Badge)
//                     DataCell(
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isPublished
//                               ? const Color(0xFFDCFCE7)
//                               : const Color(0xFFFEF3C7),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               width: 6,
//                               height: 6,
//                               decoration: BoxDecoration(
//                                 color: isPublished
//                                     ? const Color(0xFF16A34A)
//                                     : const Color(0xFFD97706),
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               course.status,
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold,
//                                 color: isPublished
//                                     ? const Color(0xFF15803D)
//                                     : const Color(0xFFB45309),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Actions Menu (View, Edit, Delete / Three Dot)
//                     DataCell(
//                       PopupMenuButton<String>(
//                         icon: const Icon(
//                           Icons.more_vert_rounded,
//                           color: Color(0xFF64748B),
//                           size: 20,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         onSelected: (val) {
//                           if (val == 'view') onView(course);
//                           if (val == 'edit') onEdit(course);
//                           if (val == 'delete') onDelete(course);
//                         },
//                         itemBuilder: (ctx) => [
//                           const PopupMenuItem(
//                             value: 'view',
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.visibility_outlined,
//                                   size: 16,
//                                   color: Color(0xFF475569),
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'View Details',
//                                   style: TextStyle(fontSize: 13),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const PopupMenuItem(
//                             value: 'edit',
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.edit_outlined,
//                                   size: 16,
//                                   color: Color(0xFF2563EB),
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Edit Course',
//                                   style: TextStyle(fontSize: 13),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const PopupMenuItem(
//                             value: 'delete',
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.delete_outline_rounded,
//                                   size: 16,
//                                   color: Color(0xFFEF4444),
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Delete',
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Color(0xFFEF4444),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
