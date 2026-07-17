import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search AIAPGET, Organon...",
              hintStyle: (
                AppFonts.mediumMedium
                ),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ),
        AppSpacing.w20,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:  Color(0xff009B5A),
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: Text(
            "Find Courses",
            style: AppFonts.mediumMedium,
          ),
        ),
      ],
    );
  }
}
