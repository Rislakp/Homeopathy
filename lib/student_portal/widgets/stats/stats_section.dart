import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsProvider>(
      builder: (_, provider, __) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 45,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.softShadow,
          ),
          child: Row(
            children: List.generate(
              provider.stats.length,
              (index) {
                return Expanded(
                  child: StatsCard(
                    stat: provider.stats[index],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}