import 'package:flutter/material.dart';
import 'package:homeopathy/admin/models/course_management_model.dart';
import 'package:homeopathy/admin/providers/course_management_provider.dart';
import 'package:provider/provider.dart';

class CourseHeaderSection extends StatelessWidget {
  const CourseHeaderSection();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CourseManagementNotifier>();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 16),
              _buildActions(context, notifier),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildTitle()),
              _buildActions(context, notifier),
            ],
          );
  }

  Widget _buildTitle() {
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
        SizedBox(height: 4),
        Text(
          'Manage all academy courses, pricing, instructors, and publishing.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, CourseManagementNotifier notifier) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton.icon(
          onPressed: () {},
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
        OutlinedButton.icon(
          onPressed: () {},
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
        ElevatedButton.icon(
          onPressed: () => _showAddCourseDialog(context, notifier),
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

  void _showAddCourseDialog(BuildContext context, CourseManagementNotifier notifier) {
    final titleCtrl = TextEditingController();
    final instCtrl = TextEditingController(text: 'Dr. Renu Sharma');
    final durCtrl = TextEditingController(text: '30 Hours');
    final priceCtrl = TextEditingController(text: '₹2,499');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Add New Course', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Course Name')),
            const SizedBox(height: 10),
            TextField(controller: instCtrl, decoration: const InputDecoration(labelText: 'Instructor')),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: durCtrl, decoration: const InputDecoration(labelText: 'Duration'))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price'))),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A)),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                notifier.addCourse(CourseItem(
                  id: 'WCA-${DateTime.now().millisecondsSinceEpoch}',
                  name: titleCtrl.text.trim(),
                  category: 'Materia Medica',
                  instructor: instCtrl.text.trim(),
                  duration: durCtrl.text.trim(),
                  price: priceCtrl.text.trim(),
                  students: 120,
                  rating: 5.0,
                  status: 'Published',
                  thumbnailIcon: Icons.menu_book_rounded,
                  thumbnailBgColor: const Color(0xFF16A34A),
                ));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}