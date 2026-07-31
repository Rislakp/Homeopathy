import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/courses/provider/course_provider.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/app_colour.dart';
import 'package:provider/provider.dart';


import 'add_course_dialog.dart';

class CourseSearchFilter extends StatefulWidget {
  const CourseSearchFilter({super.key});

  @override
  State<CourseSearchFilter> createState() => _CourseSearchFilterState();
}

class _CourseSearchFilterState extends State<CourseSearchFilter> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Anatomy',
    'Physiology',
    'Pathology',
    'Materia Medica',
    'Repertory',
    'Organon',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    
    // Keep search field text synchronized
    if (_searchController.text != provider.searchQuery) {
      _searchController.text = provider.searchQuery;
    }

    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 768;

    Widget buildDropdown() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: provider.selectedCategory,
            items: ['All Categories', ..._categories].map((String cat) {
              return DropdownMenuItem<String>(
                value: cat,
                child: Text(
                  cat,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                provider.filterCategory(val);
              }
            },
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            style: const TextStyle(fontSize: 13),
          ),
        ),
      );
    }

    final List<Widget> filterWidgets = [
      // Search TextField
      Expanded(
        flex: isMobile ? 0 : 4,
        child: Container(
          color: Colors.white,
          child: TextField(
            controller: _searchController,
            onChanged: (val) => provider.searchCourses(val),
            decoration: InputDecoration(
              hintText: 'Search courses...',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
              prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textLight),
              suffixIcon: provider.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        provider.searchCourses('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ),
      ),
      if (isMobile) const SizedBox(height: 12) else const SizedBox(width: 12),

      // Category Dropdown
      buildDropdown(),
      if (isMobile) const SizedBox(height: 12) else const SizedBox(width: 12),

      // Add Course Button
      ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const AddCourseDialog(),
          );
        },
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Course', style: TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: filterWidgets,
            )
          : Row(
              children: filterWidgets,
            ),
    );
  }
}
