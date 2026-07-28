import 'package:flutter/material.dart';

class CourseManagementHeader extends StatelessWidget {
  final VoidCallback onAddCoursePressed;
  final VoidCallback onImportPressed;
  final VoidCallback onExportPressed;

  const CourseManagementHeader({
    super.key,
    required this.onAddCoursePressed,
    required this.onImportPressed,
    required this.onExportPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(),
                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildTitleSection()),
                _buildActionButtons(),
              ],
            ),
    );
  }

  Widget _buildTitleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course Management',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.6,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Manage all academy courses, pricing, instructors, and publishing.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Export Button (Outlined)
        OutlinedButton.icon(
          onPressed: onExportPressed,
          icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFF475569)),
          label: const Text('Export', style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w600, fontSize: 13)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),

        // Import Courses Button (Outlined)
        OutlinedButton.icon(
          onPressed: onImportPressed,
          icon: const Icon(Icons.file_upload_outlined, size: 18, color: Color(0xFF475569)),
          label: const Text('Import Courses', style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w600, fontSize: 13)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),

        // + Add Course (Primary Green Button #16A34A)
        ElevatedButton.icon(
          onPressed: onAddCoursePressed,
          icon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
          label: const Text('+ Add Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF16A34A),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
