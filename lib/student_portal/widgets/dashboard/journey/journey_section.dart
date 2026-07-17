import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class JourneySection extends StatelessWidget {
  const JourneySection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JourneyProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: const Color(0xffFCFFFD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Text(
              "How it works",
              style: TextStyle(
                color: Color(0xff009B5A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          
          AppSpacing.h30,

          const SizedBox(
            width: 700,
            child: Text(
              "From enrolment to exam day — we've got you.",
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
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
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  childAspectRatio: 0.75,
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
