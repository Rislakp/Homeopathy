import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/core/theme/app_colors.dart';
import '../models/course_model.dart';
import 'badge_chip.dart';

class CourseCard extends StatefulWidget {
  final CourseModel course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isHovered = false;
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final double originalPrice = widget.course.price;
    final double discountPrice = widget.course.discountPrice;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -6.0 : 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: _isHovered ? 0.08 : 0.03),
              blurRadius: _isHovered ? 20 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Image Container with Medical Blue Gradient
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: 40,
                              color: AppColors.primary.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        // Badge Chip top-left
                        if (widget.course.badge.isNotEmpty)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: BadgeChip(label: widget.course.badge),
                          ),
                        // Bookmark icon top-right
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 1,
                            shadowColor: Colors.black26,
                            child: IconButton(
                              icon: Icon(
                                _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                                color: _isBookmarked ? AppColors.primary : AppColors.textMuted,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isBookmarked = !_isBookmarked;
                                });
                              },
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Card Metadata Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.course.category,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.schedule_rounded, size: 12, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.course.duration,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Text(
                            widget.course.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),

                          Text(
                            widget.course.faculty,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),

                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                widget.course.rating.toStringAsFixed(1),
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "(${widget.course.students}+)",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                widget.course.language,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, color: AppColors.border),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹${originalPrice.toInt()}",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Text(
                                    "₹${discountPrice.toInt()}",
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Enroll",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
