import 'package:flutter/material.dart';
import 'package:homeopathy/utils/app_colors.dart';
import '../../models/admin_data_models.dart';
import '../../models/admin_menu_item.dart';
import '../../theme/admin_colors.dart';
import '../../widgets/common/admin_breadcrumbs.dart';
import '../../widgets/common/admin_stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminBreadcrumbs(menuItem: AdminMenuItem.dashboard),

          // Welcome Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 10, 5, 100),Color.fromARGB(255, 139, 137, 175),],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppColors.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 126, 123, 182).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back, Dr. Sarah! 👋',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Here is what is happening across White Coat Academy today.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (MediaQuery.of(context).size.width > 768)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Overview Stat Cards
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 4;
              if (constraints.maxWidth < 600) {
                crossAxisCount = 1;
              } else if (constraints.maxWidth < 1100) {
                crossAxisCount = 2;
              }

              final stats = [
                const AdminStatItem(
                  title: 'Total Enrolled Students',
                  value: '14,250',
                  changePercentage: '+18.5%',
                  isPositive: true,
                  icon: Icons.people_alt_rounded,
                  color: Color(0xFF10B981),
                ),
                const AdminStatItem(
                  title: 'Active Medical Courses',
                  value: '184',
                  changePercentage: '+6.2%',
                  isPositive: true,
                  icon: Icons.menu_book_rounded,
                  color: Color(0xFF3B82F6),
                ),
                const AdminStatItem(
                  title: 'Monthly Revenue',
                  value: '\$84,920',
                  changePercentage: '+24.1%',
                  isPositive: true,
                  icon: Icons.attach_money_rounded,
                  color: Color(0xFF8B5CF6),
                ),
                const AdminStatItem(
                  title: 'Live Webinars Completed',
                  value: '312',
                  changePercentage: '-1.4%',
                  isPositive: false,
                  icon: Icons.video_camera_front_rounded,
                  color: Color(0xFFF59E0B),
                ),
              ];

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: constraints.maxWidth < 600 ? 3.0 : 2.2,
                ),
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  return AdminStatCard(item: stats[index]);
                },
              );
            },
          ),
          const SizedBox(height: 24),

          // Recent Activity & Quick Action Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppColors.cardRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Platform Activities',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildActivityTile(
                        'New student registration',
                        'Dr. Aris Thorne joined Materia Medica 101',
                        '5 mins ago',
                        Icons.person_add_rounded,
                        AppColors.primary,
                      ),
                      _buildActivityTile(
                        'Webinar live session',
                        'Live case study session started by Prof. Smith',
                        '24 mins ago',
                        Icons.live_tv_rounded,
                        AppColors.info,
                      ),
                      _buildActivityTile(
                        'Payment received',
                        'Course fee \$450 processed for Homeopathy Fundamentals',
                        '1 hour ago',
                        Icons.payments_rounded,
                        AppColors.warning,
                      ),
                      _buildActivityTile(
                        'Exam published',
                        'Final Pathology Mock Exam published by Admin',
                        '3 hours ago',
                        Icons.assignment_turned_in_rounded,
                        AppColors.primaryDark,
                      ),
                    ],
                  ),
                ),
              ),
              if (MediaQuery.of(context).size.width > 900) ...[
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppColors.cardRadius,
                      ),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Administrative Actions',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildQuickActionButton(
                          context,
                          'Add New Student',
                          Icons.person_add_alt_1_rounded,
                        ),
                        _buildQuickActionButton(
                          context,
                          'Schedule Live Class',
                          Icons.video_call_rounded,
                        ),
                        _buildQuickActionButton(
                          context,
                          'Publish Announcement',
                          Icons.campaign_rounded,
                        ),
                        _buildQuickActionButton(
                          context,
                          'Generate Financial Report',
                          Icons.assessment_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(
    String title,
    String desc,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Action: $label triggered.')));
        },
        icon: Icon(icon, size: 18, color: AppColors.primary),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 44),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
