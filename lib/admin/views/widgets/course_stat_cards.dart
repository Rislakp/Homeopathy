import 'package:flutter/material.dart';


class CourseStatModel {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const CourseStatModel({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

class CourseStatCards extends StatelessWidget {
  const CourseStatCards({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      const CourseStatModel(
        title: 'Total Courses',
        value: '148',
        icon: Icons.menu_book_rounded,
        iconColor: Color(0xFF16A34A),
        iconBgColor: Color(0xFFDCFCE7),
      ),
      const CourseStatModel(
        title: 'Published',
        value: '126',
        icon: Icons.check_circle_rounded,
        iconColor: Color(0xFF2563EB),
        iconBgColor: Color(0xFFDBEAFE),
      ),
      const CourseStatModel(
        title: 'Draft',
        value: '22',
        icon: Icons.description_rounded,
        iconColor: Color(0xFFD97706),
        iconBgColor: Color(0xFFFEF3C7),
      ),
      const CourseStatModel(
        title: 'Enrollments',
        value: '4,875',
        icon: Icons.people_rounded,
        iconColor: Color(0xFF9333EA),
        iconBgColor: Color(0xFFF3E8FF),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth < 640) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1024) {
          crossAxisCount = 2;
        }

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
            final stat = stats[index];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: stat.iconBgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      stat.icon,
                      color: stat.iconColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          stat.title,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stat.value,
                          style:  TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
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
