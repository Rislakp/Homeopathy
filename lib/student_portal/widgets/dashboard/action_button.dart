import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';


class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Explore Courses"),
        ),
      
        AppSpacing.w20,
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.play_arrow),
          label: const Text("Watch Demo"),
        )
      ],
    );
  }
}