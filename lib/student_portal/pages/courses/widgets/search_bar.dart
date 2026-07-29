import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/course_provider.dart';

class CoursesSearchBar extends StatefulWidget {
  const CoursesSearchBar({super.key});

  @override
  State<CoursesSearchBar> createState() => _CoursesSearchBarState();
}

class _CoursesSearchBarState extends State<CoursesSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CourseProvider>();
    _controller = TextEditingController(text: provider.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuery = context.select((CourseProvider p) => p.searchQuery);
    if (_controller.text != currentQuery) {
      _controller.text = currentQuery;
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.search_rounded, color: Color(0xFF6B7280)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (val) {
                    context.read<CourseProvider>().setSearchQuery(val);
                  },
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: const Color(0xFF111827),
                  ),
                  decoration: InputDecoration(
                    hintText: "Search courses, subjects, faculty...",
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CourseProvider>().setSearchQuery(_controller.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Search",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
