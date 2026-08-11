import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';


class FooterText extends StatelessWidget {
  const FooterText({super.key});

  @override
  Widget build(BuildContext context) {
    const Color textGrey = Color(0xFF667085);

    return Text(
      'Protected by enterprise-grade encryption 🔒',
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textGrey,
      ),
      textAlign: TextAlign.center,
    );
  }
}
