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
          style: const TextStyle(
            fontSize: 54,
            fontWeight: FontWeight.bold,
            color: Color(0xff0AA06E),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          stat.title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),

      ],
    );
  }
}