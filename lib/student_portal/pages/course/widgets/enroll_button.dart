import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class EnrollButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isEnrolled;

  const EnrollButton({
    super.key,
    required this.onTap,
    this.isEnrolled = false,
  });

  @override
  State<EnrollButton> createState() => _EnrollButtonState();
}

class _EnrollButtonState extends State<EnrollButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.isEnrolled ? "Enrolled" : "Enroll Now";
    final Color baseColor = widget.isEnrolled ? AppColors.textSecondary : AppColors.buttonGreen;
    final Color hoverColor = widget.isEnrolled ? AppColors.textSecondary : AppColors.primaryGreen;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 54,
            decoration: BoxDecoration(
              color: _isHovered ? hoverColor : baseColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                if (_isHovered && !widget.isEnrolled)
                  BoxShadow(
                    color: AppColors.buttonGreen.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: AppTextStyles.enrollButton,
                ),
                const SizedBox(width: 8),
                AnimatedSlide(
                  offset: _isHovered && !widget.isEnrolled ? const Offset(0.2, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.isEnrolled ? Icons.done : Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
