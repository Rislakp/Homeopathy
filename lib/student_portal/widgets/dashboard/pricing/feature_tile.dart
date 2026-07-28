import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class FeatureTile extends StatelessWidget {
  final String text;

  const FeatureTile({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [

          const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}