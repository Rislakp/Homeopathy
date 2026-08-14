import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class SectionHeader extends StatelessWidget {
 // final VoidCallback onFilterPressed;

  const SectionHeader({super.key, 
  //required this.onFilterPressed
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FeaturedBadge(),
                const SizedBox(height: 12),
                Text(
                  'Popular Courses',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Explore top-rated medical entrance preparation courses',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 13 : 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (!isMobile)
              OutlinedButton.icon(
                onPressed: (){},
                icon: const Icon(Icons.filter_list_rounded, size: 18),
                label: const Text('Filters'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  const _FeaturedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryBorder),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: AppColors.primary),
          SizedBox(width: 6),
          Text(
            'Featured Courses',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}