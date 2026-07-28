import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Text;
  final String? hintText;
  final double? width;
  final double? height;

  final Color? textColor;
  final Color? borderColor;
  final Color? focusedBorderColor;

  final double fontSize;
  final FontWeight fontWeight;
  final bool isPassword;

  const CommonTextField({
    super.key,
    this.controller,
    this.Text,
    this.hintText,
    this.width,
    this.height,
    this.textColor,
    this.borderColor,
    this.focusedBorderColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: focusedBorderColor ?? Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
