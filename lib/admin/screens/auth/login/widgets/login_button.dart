import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/utils/app_colors.dart';

class LoginButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = AppColors.adminBlue;
    final Color hoverColor = AppColors.adminBlueHover;
    final Color pressedColor = AppColors.adminBlue.withOpacity(0.85);

    // Define colors & shadows dynamically based on interaction states
    Color buttonColor = primaryColor;
    double scale = 1.0;
    List<BoxShadow> shadows = [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.24),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];

    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    if (isDisabled) {
      buttonColor = primaryColor.withValues(alpha: 0.6);
      shadows = [];
    } else if (_isPressed) {
      buttonColor = pressedColor;
      scale = 0.97;
      shadows = [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.16),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
    } else if (_isHovered) {
      buttonColor = hoverColor;
      scale = 1.02;
      shadows = [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.35),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];
    }

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (!isDisabled) {
          setState(() => _isHovered = false);
        }
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (!isDisabled) {
            setState(() => _isPressed = true);
          }
        },
        onTapUp: (_) {
          if (!isDisabled) {
            setState(() => _isPressed = false);
          }
        },
        onTapCancel: () {
          if (!isDisabled) {
            setState(() => _isPressed = false);
          }
        },
        onTap: isDisabled ? null : widget.onPressed,
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
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
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