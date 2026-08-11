import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/course_management_model.dart';

class CourseHeroCard extends StatelessWidget {
  final CourseDetailModel course;

  const CourseHeroCard({
    super.key,
    required this.course,
  });

  Widget _buildMetaChip({
    required IconData icon,
    required String text,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: iconColor.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 640;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00A86B), Color(0xFF15803D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.medical_services_outlined,
                    size: 80,
                    color: Colors.white24,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: course.status.toLowerCase() == 'published'
                                    ? Colors.green
                                    : Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              course.status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: course.status.toLowerCase() == 'published'
                                    ? Colors.green[800]
                                    : Colors.orange[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (course.isBestseller) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3CD),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFFEBAA)),
                          ),
                          child: const Text(
                            '★ Bestseller',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF856404),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'MATERIA MEDICA',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  course.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475569),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF1F5F9), height: 1),
                const SizedBox(height: 24),
                if (isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.teal.withOpacity(0.2),
                            child: const Text(
                              'DR',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            course.instructor,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildMetaChip(
                            icon: Icons.access_time_rounded,
                            text: course.duration,
                            iconColor: const Color(0xFF2563EB),
                            bgColor: const Color(0xFFEFF6FF),
                          ),
                          _buildMetaChip(
                            icon: Icons.people_outline_rounded,
                            text: '${course.students} Enrolled',
                            iconColor: const Color(0xFF7C3AED),
                            bgColor: const Color(0xFFF5F3FF),
                          ),
                          _buildMetaChip(
                            icon: Icons.currency_rupee_rounded,
                            text: course.price,
                            iconColor: const Color(0xFF059669),
                            bgColor: const Color(0xFFECFDF5),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.teal.withOpacity(0.15),
                            child: const Text(
                              'DR',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'INSTRUCTOR',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                course.instructor,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 12,
                        children: [
                          _buildMetaChip(
                            icon: Icons.access_time_rounded,
                            text: course.duration,
                            iconColor: const Color(0xFF2563EB),
                            bgColor: const Color(0xFFEFF6FF),
                          ),
                          _buildMetaChip(
                            icon: Icons.people_outline_rounded,
                            text: '${course.students} Enrolled',
                            iconColor: const Color(0xFF7C3AED),
                            bgColor: const Color(0xFFF5F3FF),
                          ),
                          _buildMetaChip(
                            icon: Icons.currency_rupee_rounded,
                            text: course.price,
                            iconColor: const Color(0xFF059669),
                            bgColor: const Color(0xFFECFDF5),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
