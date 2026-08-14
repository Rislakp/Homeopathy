import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class JourneyCard extends StatelessWidget {
  final JourneyStepModel step;

  const JourneyCard({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Text(
              step.number.toString().padLeft(2, "0"),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: AppColors.border,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                child: Icon(step.icon, color: Colors.white, size: 20),
              ),

              AppSpacing.h20,

              Text(
                step.title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              AppSpacing.h12,

              Text(
                step.description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
