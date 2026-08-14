import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable Custom Text Field matching the app's design system.
/// Positioned labels, white fill, thin border, prefix & suffix icons, light grey placeholders.
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;

  final IconData? trailingIcon;
  final Widget? suffix;
  final VoidCallback? onTrailingTap;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  final TextInputType keyboardType;

  final bool isPassword;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool isSmallScreen;
  final double borderRadius;

  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.trailingIcon,
    this.suffix,
    this.onTrailingTap,
    this.onTap,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.isSmallScreen = false,
    this.borderRadius = 8.0,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = BorderRadius.circular(borderRadius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label above text field
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isSmallScreen ? 12 : 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),

        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && obscureText,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: isSmallScreen ? 13 : 14,
            color: const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF8FAFC),
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: isSmallScreen ? 12 : 13,
              color: const Color(0xFF94A3B8),
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: const Color(0xFF94A3B8),
              size: isSmallScreen ? 18 : 20,
            ),
            suffixIcon: suffix ??
                (trailingIcon != null
                    ? GestureDetector(
                        onTap: onTrailingTap ?? onTap,
                        child: Icon(
                          trailingIcon,
                          color: const Color(0xFF94A3B8),
                          size: isSmallScreen ? 18 : 20,
                        ),
                      )
                    : null),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 14,
              vertical: isSmallScreen ? 12 : 14,
            ),
            border: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(
                color: Color(0xFF0D3B8E),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Backward compatibility alias for CustomTextFormField
typedef CustomTextFormField = CustomTextField;
