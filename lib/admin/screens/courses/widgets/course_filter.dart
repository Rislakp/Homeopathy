// import 'package:flutter/material.dart';
// import 'package:homeopathy/admin/providers/course_management_provider.dart';
// import 'package:provider/provider.dart';

// class CourseFilterBarSection extends StatelessWidget {
//   const CourseFilterBarSection();

//   @override
//   Widget build(BuildContext context) {
//     final notifier = context.watch<CourseManagementNotifier>();
//     final isMobile = MediaQuery.of(context).size.width < 900;

//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
//       ),
//       child: isMobile
//           ? Column(
//               children: [
//                 _buildSearch(notifier),
//                 const SizedBox(height: 12),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     _buildDrop('Category', notifier.selectedCategory, notifier.categories, notifier.setCategory),
//                     _buildDrop('Instructor', notifier.selectedInstructor, notifier.instructors, notifier.setInstructor),
//                     _buildDrop('Status', notifier.selectedStatus, notifier.statuses, notifier.setStatus),
//                     _buildDrop('Language', notifier.selectedLanguage, notifier.languages, notifier.setLanguage),
//                     _buildDrop('Sort By', notifier.selectedSort, notifier.sortOptions, notifier.setSort),
//                   ],
//                 ),
//               ],
//             )
//           : Row(
//               children: [
//                 Expanded(flex: 3, child: _buildSearch(notifier)),
//                 const SizedBox(width: 12),
//                 _buildDrop('Category', notifier.selectedCategory, notifier.categories, notifier.setCategory),
//                 const SizedBox(width: 8),
//                 _buildDrop('Instructor', notifier.selectedInstructor, notifier.instructors, notifier.setInstructor),
//                 const SizedBox(width: 8),
//                 _buildDrop('Status', notifier.selectedStatus, notifier.statuses, notifier.setStatus),
//                 const SizedBox(width: 8),
//                 _buildDrop('Language', notifier.selectedLanguage, notifier.languages, notifier.setLanguage),
//                 const SizedBox(width: 8),
//                 _buildDrop('Sort By', notifier.selectedSort, notifier.sortOptions, notifier.setSort),
//               ],
//             ),
//     );
//   }

//   Widget _buildSearch(CourseManagementNotifier notifier) {
//     return SizedBox(
//       height: 42,
//       child: TextField(
//         onChanged: notifier.setSearch,
//         decoration: InputDecoration(
//           hintText: 'Search Courses...',
//           hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
//           prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
//           filled: true,
//           fillColor: const Color(0xFFF8FAFC),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 14),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
//           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
//           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF16A34A), width: 1.5)),
//         ),
//       ),
//     );
//   }

//   Widget _buildDrop(String label, String value, List<String> items, ValueChanged<String> onChanged) {
//     return Container(
//       height: 42,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: items.contains(value) ? value : items.first,
//           icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 18),
//           style: const TextStyle(color: Color(0xFF334155), fontSize: 13, fontWeight: FontWeight.w600),
//           items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
//           onChanged: (v) { if (v != null) onChanged(v); },
//         ),
//       ),
//     );
//   }
// }