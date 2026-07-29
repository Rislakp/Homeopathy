import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
                  color: isSelected ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  provider.setSelectedCategory(cat);
                }
              },
              selectedColor: const Color(0xFF16A34A),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
                ),
              ),
              elevation: isSelected ? 2 : 0,
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
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.tune_rounded, size: 14, color: Color(0xFF6B7280)),
              ],
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Advanced filters dialog placeholder"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
        ],
      ),
    );
  }
}
