import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Top badge chip
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F9EE),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F9D58),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                "Live Classes",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F9D58),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Heading
        Text(
          "Learn live. Ask questions. Get answers.",
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
            height: 1.2,
          ),
        ),
        SizedBox(height: 10.h),

        // Subtext
        Text(
          "Daily interactive sessions with recordings you can rewatch any time.",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
