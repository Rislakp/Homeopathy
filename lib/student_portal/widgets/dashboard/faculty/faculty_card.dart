import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class FacultyCard extends StatelessWidget {
  final Faculty faculty;

  const FacultyCard({super.key, required this.faculty});

  String _formatStudents(int count) {
    if (count >= 1000) {
      final k = count / 1000;
      return '${k % 1 == 0 ? k.toInt() : k.toStringAsFixed(1)}k+';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDBEAFE), Color(0xFF93C5FD)],
              ),
              image: faculty.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(faculty.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: faculty.imageUrl == null
                ? const Icon(Icons.person, color: AppColors.primary, size: 40)
                : null,
          ),
          AppSpacing.h16,
          Text(
            faculty.name,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.h4,
          Text(
            faculty.qualification,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.h12,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < faculty.rating.round()
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 18,
                  color: Colors.amber,
                );
              }),
              AppSpacing.w8,
              Text(
                faculty.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          AppSpacing.h16,
          const Divider(color: AppColors.border),
          AppSpacing.h12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '${faculty.experienceYears} yrs',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Experience',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    _formatStudents(faculty.studentsCount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Students',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.h12,
          Text(
            faculty.tags.join(' · '),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
