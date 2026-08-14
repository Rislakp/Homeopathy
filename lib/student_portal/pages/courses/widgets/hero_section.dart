import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/core/theme/app_colors.dart';

class CoursesHeroSection extends StatelessWidget {
  const CoursesHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryLight, Color(0xFFDBEAFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : (isTablet ? 40.0 : 64.0),
        vertical: isMobile ? 40.0 : 60.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.primaryBorder),
                ),
                child: Text(
                  "ONLINE COURSES",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Every course you need to\nclear your medical entrance\nexam.",
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 30 : (isTablet ? 40 : 50),
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 16),

              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  "Live cohorts, self-paced tracks and rapid-revision programs — all crafted by rank-holding faculty.",
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 15 : 17,
                    color: AppColors.textSecondary,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
