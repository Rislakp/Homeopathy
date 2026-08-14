import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryBorder),
          ),
          child: const Text(
            "India's #1 Medical Education Platform",
            style: TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),

        AppSpacing.h25,

        Text("Master\nMedicine.",
         style: AppFonts.largeSemiBold),
        const SizedBox(height: 2),
        Text("Clear Every Exam.", style: AppFonts.largeBold),

        AppSpacing.h20,

        Text(
          "Live classes, mock tests and personal mentorship from India's top medical faculty — for AIAPGET,NHM OR NAAM,Food Safety Officer, PG, Clinical Sessions, NTET, Exit Exam, UPSC and PSC aspirants.",
          style: AppFonts.largeMedium,
        ),

        AppSpacing.h30,

        const SearchBarWidget(),

        const SizedBox(height: 25),

        const ActionButtons(),

        AppSpacing.h25,

        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLight,
              child: const Icon(Icons.person, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 4),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLight,
              child: const Icon(Icons.person, size: 16, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 4),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.star, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              "1,20,000+ learners",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
