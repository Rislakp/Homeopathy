import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.softShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardImage(course: course),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.instructor,
                    style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13),
                  ),
                  AppSpacing.h4,
                  Text(
                    course.title,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.h12,
                  _CardStats(course: course),
                  AppSpacing.h12,
                  const Divider(height: 1),
                  AppSpacing.h12,
                  _CardPriceRow(course: course),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  final Course course;
  const _CardImage({required this.course});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDBEAFE), Color(0xFF93C5FD)],
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Row(
              children: [
                _Badge(
                  text: course.tag,
                  background: Colors.white,
                  textColor: AppColors.textPrimary,
                ),
                AppSpacing.w8,
                _Badge(
                  text: '${course.discountPercent}% OFF',
                  background: AppColors.primaryDark,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          if (course.hasVideoPreview)
            const Center(
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 28),
              ),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color background;
  final Color textColor;

  const _Badge({
    required this.text,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _CardStats extends StatelessWidget {
  final Course course;
  const _CardStats({required this.course});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded, size: 15, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          course.duration,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.people_outline_rounded, size: 15, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          course.studentsCount,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
        const SizedBox(width: 2),
        Text(
          '${course.rating}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _CardPriceRow extends StatelessWidget {
  final Course course;
  const _CardPriceRow({required this.course});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final enrolled = provider.isEnrolled(course);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₹${course.price}',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '₹${course.originalPrice}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textMuted,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: enrolled
              ? null
              : () => context.read<CourseProvider>().enroll(course),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.border,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          icon: Icon(enrolled ? Icons.check_rounded : Icons.arrow_forward_rounded, size: 16),
          label: Text(enrolled ? 'Enrolled' : 'Enroll'),
        ),
      ],
    );
  }
}
