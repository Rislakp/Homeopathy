import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/live_class_model.dart';
import 'countdown_timer_widget.dart';
import 'register_button.dart';

class LiveClassCard extends StatelessWidget {
  final LiveClassModel liveClass;
  final VoidCallback onRegister;

  const LiveClassCard({
    super.key,
    required this.liveClass,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: LIVE Badge & Time label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LIVE Red Pill Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "LIVE",
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              // Date/Time
              Text(
                liveClass.dayLabel,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Course Title
          Text(
            liveClass.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
              height: 1.3,
            ),
          ),
          SizedBox(height: 6.h),

          // Faculty Name
          Text(
            liveClass.facultyName,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 20.h),

          // Countdown timer box
          CountdownTimerWidget(targetTime: liveClass.startTime),
          SizedBox(height: 20.h),

          // Register Action Button
          RegisterButton(onPressed: onRegister),
        ],
      ),
    );
  }
}
