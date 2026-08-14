import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/core/theme/app_colors.dart';
import '../provider/course_provider.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  static const List<String> _filters = [
    "All",
    "AIAPGET",
    "NEET PG",
    "NTET",
    "Exit Exam",
    "UPSC",
    "Kerala PSC",
    "Organon",
    "Materia Medica",
    "Repertory",
    "Clinical",
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          ..._filters.map((cat) {
            final isSelected = provider.selectedCategory == cat;
            return ChoiceChip(
              label: Text(
                cat,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  provider.setSelectedCategory(cat);
                }
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : AppColors.border,
                ),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            );
          }),

          // Last ActionChip: Filters
          ActionChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Filters",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.tune_rounded, size: 14, color: AppColors.textSecondary),
              ],
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: AppColors.border),
            ),
            onPressed: () {},
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
        ],
      ),
    );
  }
}
