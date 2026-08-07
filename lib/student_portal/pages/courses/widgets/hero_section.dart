import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          colors: [Color(0xFFF3FCF7), Color(0xFFE8F9EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : (isTablet ? 40.0 : 64.0),
        vertical: isMobile ? 40.0 : 64.0,
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
                  color: const Color(0xFF16A34A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "ONLINE COURSES",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF16A34A),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Every course you need to\nclear your homeopathy\nexam.",
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: GoogleFonts.outfit(
                  fontSize: isMobile ? 32 : (isTablet ? 44 : 54),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
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
                    color: const Color(0xFF6B7280),
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
