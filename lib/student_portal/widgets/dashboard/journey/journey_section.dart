import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class JourneySection extends StatelessWidget {
  const JourneySection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JourneyProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.primaryBorder),
            ),
            child: const Text(
              "How it works",
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          AppSpacing.h30,

          Text(
            "From enrolment to exam day — we've got you.",
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          AppSpacing.h40,

          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 4;

              if (constraints.maxWidth < 1200) {
                crossAxisCount = 2;
              }

              if (constraints.maxWidth < 700) {
                crossAxisCount = 1;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.steps.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (_, index) {
                  return JourneyCard(step: provider.steps[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
