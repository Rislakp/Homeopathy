import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class LoginButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF08B653);
    const Color hoverColor = Color(0xFF07A24A); 
    const Color pressedColor = Color(0xFF068E40); 

    // Define colors & shadows dynamically based on interaction states
    Color buttonColor = primaryColor;
    double scale = 1.0;
    List<BoxShadow> shadows = [
      BoxShadow(
        color: primaryColor.withOpacity(0.24),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];

    if (_isPressed) {
      buttonColor = pressedColor;
      scale = 0.97;
      shadows = [
        BoxShadow(
          color: primaryColor.withOpacity(0.16),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
    } else if (_isHovered) {
      buttonColor = hoverColor;
      scale = 1.02;
      shadows = [
        BoxShadow(
          color: primaryColor.withOpacity(0.35),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          transform: Matrix4.diagonal3Values(scale, scale, 1.0),
          transformAlignment: Alignment.center,
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: shadows,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
