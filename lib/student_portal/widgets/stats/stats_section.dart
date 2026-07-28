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

            borderRadius: BorderRadius.circular(35),

            border: Border.all(
              color: Colors.green.shade100,
            ),

            boxShadow: [

              BoxShadow(
                color: Colors.green.withOpacity(.08),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0,10),
              )

            ],
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