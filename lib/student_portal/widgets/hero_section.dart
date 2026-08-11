import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Text(
            "India's #1 Homeopathy Learning Platform",
             style: 
            TextStyle(
              color: Color.fromARGB(255, 10, 5, 100),
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),

        AppSpacing.h25,

        Text("Master\nHomeopathy.",
         style: AppFonts.largeSemiBold),
        SizedBox(height: 2),
        Text("Clear Every Exam.", style: AppFonts.largeBold),

        AppSpacing.w20,

        Text(
          "Live classes, mock tests and personal mentorship from India's top homeopathy faculty — for AIAPGET, NEET PG, NTET, Exit Exam, UPSC and PSC aspirants.",
          style: AppFonts.largeMedium,
        ),

        AppSpacing.h30,

        const SearchBarWidget(),

        const SizedBox(height: 25),

        const ActionButtons(),

        AppSpacing.h25,

        Row(
          children: const [
            CircleAvatar(radius: 16),
            CircleAvatar(radius: 16),
            CircleAvatar(radius: 16),
            SizedBox(width: 10),
            Text(
              "1,20,000+ learners",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
