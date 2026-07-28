import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class PricingSection extends StatelessWidget {
  const PricingSection({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<PricingProvider>();

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Simple plans. Serious outcomes.",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "No hidden fees. Cancel anytime. 7-day money-back guarantee.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 40),

          Row(
            children: provider.plans.map((plan) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 520,
                    child: PricingCard(plan: plan),
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}