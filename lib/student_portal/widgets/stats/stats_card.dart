import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class StatsCard extends StatelessWidget {
  final StatsModel stat;

  const StatsCard({
    super.key,
    required this.stat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          stat.count,
          style: GoogleFonts.inter(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          stat.title,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}