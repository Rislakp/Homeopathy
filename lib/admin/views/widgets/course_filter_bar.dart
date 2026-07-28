// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/course_management_provider.dart';

// class CourseFilterBar extends StatelessWidget {
//   const CourseFilterBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch();
//     final isMobile = MediaQuery.of(context).size.width < 900;

//     return Container(
//       padding: const EdgeInsets.all(18),
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
//       child: isMobile
//           ? Column(
//               children: [
//                 _buildSearchInput(provider),
//                 const SizedBox(height: 12),
//                 Wrap(
//                   spacing: 10,
//                   runSpacing: 10,
//                   children: [
//                     _buildDropdown('Category', provider.selectedCategory, provider.categories, (v) => provider.setCategory(v)),
//                     _buildDropdown('Instructor', provider.selectedInstructor, provider.instructors, (v) => provider.setInstructor(v)),
//                     _buildDropdown('Status', provider.selectedStatus, provider.statuses, (v) => provider.setStatus(v)),
//                     _buildDropdown('Language', provider.selectedLanguage, provider.languages, (v) => provider.setLanguage(v)),
//                     _buildDropdown('Sort By', provider.selectedSort, provider.sortOptions, (v) => provider.setSort(v)),
//                   ],
//                 ),
//               ],
//             )
//           : Row(
//               children: [
//                 // Search Field
//                 Expanded(
//                   flex: 3,
//                   child: _buildSearchInput(provider),
//                 ),
//                 const SizedBox(width: 12),

//                 // Category Dropdown
//                 _buildDropdown('Category', provider.selectedCategory, provider.categories, (v) => provider.setCategory(v)),
//                 const SizedBox(width: 8),

//                 // Instructor Dropdown
//                 _buildDropdown('Instructor', provider.selectedInstructor, provider.instructors, (v) => provider.setInstructor(v)),
//                 const SizedBox(width: 8),

//                 // Status Dropdown
//                 _buildDropdown('Status', provider.selectedStatus, provider.statuses, (v) => provider.setStatus(v)),
//                 const SizedBox(width: 8),

//                 // Language Dropdown
//                 _buildDropdown('Language', provider.selectedLanguage, provider.languages, (v) => provider.setLanguage(v)),
//                 const SizedBox(width: 8),

//                 // Sort By Dropdown
//                 _buildDropdown('Sort By', provider.selectedSort, provider.sortOptions, (v) => provider.setSort(v)),
//               ],
//             ),
//     );
//   }

//   Widget _buildSearchInput(CourseManagementProvider provider) {
//     return SizedBox(
//       height: 42,
//       child: TextField(
//         onChanged: (v) => provider.setSearchQuery(v),
//         decoration: InputDecoration(
//           hintText: 'Search Courses...',
//           hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
//           prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
//           suffixIcon: provider.searchQuery.isNotEmpty
//               ? IconButton(
//                   icon: const Icon(Icons.clear_rounded, color: Color(0xFF94A3B8), size: 16),
//                   onPressed: () => provider.setSearchQuery(''),
//                 )
//               : null,
//           filled: true,
//           fillColor: const Color(0xFFF8FAFC),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 14),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Color(0xFF16A34A), width: 1.5),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdown(
//     String label,
//     String currentValue,
//     List<String> items,
//     ValueChanged<String> onChanged,
//   ) {
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
//           value: items.contains(currentValue) ? currentValue : items.first,
//           icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 18),
//           style: const TextStyle(
//             color: Color(0xFF334155),
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//           ),
//           items: items.map((String val) {
//             return DropdownMenuItem<String>(
//               value: val,
//               child: Text(val),
//             );
//           }).toList(),
//           onChanged: (val) {
//             if (val != null) onChanged(val);
//           },
//         ),
//       ),
//     );
//   }
// }
