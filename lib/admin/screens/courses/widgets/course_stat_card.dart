import 'package:flutter/material.dart';
import 'package:homeopathy/admin/models/course_management_model.dart';

class CourseStatCardsSection extends StatelessWidget {
  const CourseStatCardsSection();

  @override
  Widget build(BuildContext context) {
    final stats = [
      const CourseStat(title: 'Total Courses', value: '148', icon: Icons.menu_book_rounded, iconColor: Color(0xFF16A34A), iconBgColor: Color(0xFFDCFCE7)),
      const CourseStat(title: 'Published', value: '126', icon: Icons.check_circle_rounded, iconColor: Color(0xFF2563EB), iconBgColor: Color(0xFFDBEAFE)),
      const CourseStat(title: 'Draft', value: '22', icon: Icons.description_rounded, iconColor: Color(0xFFD97706), iconBgColor: Color(0xFFFEF3C7)),
      const CourseStat(title: 'Enrollments', value: '4,875', icon: Icons.people_rounded, iconColor: Color(0xFF9333EA), iconBgColor: Color(0xFFF3E8FF)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth < 640) crossAxisCount = 1;
        else if (constraints.maxWidth < 1024) crossAxisCount = 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: constraints.maxWidth < 640 ? 2.4 : 2.0,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final s = stats[index];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: s.iconBgColor, borderRadius: BorderRadius.circular(14)),
                    child: Icon(s.icon, color: s.iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.title, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(s.value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A), letterSpacing: -0.5)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
