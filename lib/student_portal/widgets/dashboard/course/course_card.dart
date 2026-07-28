import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';


class CourseCard extends StatelessWidget {
  final Course course;
  final isSelected = false;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D4F) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
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
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                 //CommonTextField(controller: controller)
                  AppSpacing.h4,
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                
                  AppSpacing.w10,
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
      height: 200,
      child: Stack(
        children: [
          // Placeholder gradient standing in for a course thumbnail.
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB9E4C9), Color(0xFF6FAE8A)],
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
                  textColor: Colors.black87,
                ),
               
                AppSpacing.w10,
                _Badge(
                  text: '${course.discountPercent}% OFF',
                  background: const Color(0xFF1E5631),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          if (course.hasVideoPreview)
            const Center(
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(Icons.play_arrow, color: Colors.black87, size: 30),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
        const Icon(Icons.access_time, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        AppSpacing.w4,
        Text(
          course.duration,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(width: 14),
        const Icon(Icons.people_outline, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          course.studentsCount,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(width: 14),
        const Icon(Icons.star, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          '${course.rating} (${course.ratingCount})',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
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
    // context.watch rebuilds this widget whenever CourseProvider changes,
    // so the button can reflect the enrolled state.
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '₹${course.originalPrice}',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
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
            backgroundColor: const Color(0xFF2E7D4F),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
          icon: Icon(enrolled ? Icons.check : Icons.arrow_forward, size: 18),
          label: Text(enrolled ? 'Enrolled' : 'Enroll'),
        ),
      ],
    );
  }
}
