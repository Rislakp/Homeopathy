import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/student_portal/pages/course/constants/app_colors.dart';


class DemoItem {
  final String title;
  final String faculty;
  final String duration;
  final double rating;
  final int studentsCount;
  final String imagePath;
  final List<Color> gradientColors;
  final bool isLive;

  const DemoItem({
    required this.title,
    required this.faculty,
    required this.duration,
    required this.rating,
    required this.studentsCount,
    required this.imagePath,
    required this.gradientColors,
    this.isLive = false,
  });
}

class DemoClassVideo extends StatefulWidget {
  const DemoClassVideo({super.key});

  @override
  State<DemoClassVideo> createState() => _DemoClassVideoState();
}

class _DemoClassVideoState extends State<DemoClassVideo> {
  final List<DemoItem> _items = const [
    DemoItem(
      title: 'AIAPGET Crash Course',
      faculty: 'Dr. Aditya Sharma (AIR 3)',
      duration: '1.5 Hours Preview',
      rating: 4.9,
      studentsCount: 1420,
      imagePath: 'assets/demo/demo1.jpg',
      gradientColors: [Color(0xFF00A86B), Color(0xFF005C3E)],
      isLive: true,
    ),
    DemoItem(
      title: 'Clinical Medicine',
      faculty: 'Dr. Sanjay Sen',
      duration: '2.0 Hours Preview',
      rating: 4.8,
      studentsCount: 980,
      imagePath: 'assets/demo/demo2.jpg',
      gradientColors: [Color(0xFF22C55E), Color(0xFF15803D)],
    ),
    DemoItem(
      title: 'Organon Masterclass',
      faculty: 'Dr. Priya Ramachandran',
      duration: '1.0 Hour Preview',
      rating: 4.9,
      studentsCount: 1250,
      imagePath: 'assets/demo/demo3.jpg',
      gradientColors: [Color(0xFF10B981), Color(0xFF065F46)],
      isLive: true,
    ),
    DemoItem(
      title: 'Materia Medica Revision',
      faculty: 'Dr. Vivek Kumar (MD)',
      duration: '2.5 Hours Preview',
      rating: 4.7,
      studentsCount: 1100,
    
      imagePath: 'assets/demo/demo4.jpg',
      gradientColors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
    ),
    DemoItem(
      title: 'Anatomy Foundation',
      faculty: 'Dr. Amit Trivedi',
      duration: '1.5 Hours Preview',
      rating: 4.6,
      studentsCount: 670,
     
      imagePath: 'assets/demo/demo5.jpg',
      gradientColors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
    ),
    DemoItem(
      title: 'Repertory Essentials',
      faculty: 'Dr. Kiran Patel',
      duration: '1.2 Hours Preview',
      rating: 4.8,
      studentsCount: 720,
     
      imagePath: 'assets/demo/demo6.jpg',
      gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    ),
  ];

  late PageController _pageController;
  int _virtualIndex = 0;
  Timer? _autoPlayTimer;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    // Large start number to support pseudo-infinite backward scrolling
    _virtualIndex = _items.length * 1000;
    _pageController = PageController(
      initialPage: _virtualIndex,
      viewportFraction: 0.85,
    );
    _startTimer();
  }

  void _startTimer() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!mounted || _isUserInteracting) return;
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _resetTimer() {
    _startTimer();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1200;

    // Responsive configurations for height and viewport coverage
    double sectionHeight = 620;
    double sliderViewportFraction = 0.55;

    if (isMobile) {
      sectionHeight = 560;
      sliderViewportFraction = 0.95;
    } else if (isTablet) {
      sectionHeight = 600;
      sliderViewportFraction = 0.80;
    }

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Title Block
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.smart_display_rounded,
                      color: AppColors.primaryGreen,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "FREE DEMO LECTURES",
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryGreen,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Featured Demo Classes",
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Watch free demo sessions from our expert faculty before enrolling.",
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),

          // 2. Carousel Slider Viewport
          SizedBox(
            height: sectionHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Adjust viewport fraction dynamically in layout contexts
                double activeViewport = sliderViewportFraction;
                if (constraints.maxWidth < 600) {
                  activeViewport = 0.95;
                } else if (constraints.maxWidth < 1000) {
                  activeViewport = 0.78;
                }

                if (_pageController.viewportFraction != activeViewport) {
                  // Re-initialize controller with new fraction
                  _pageController = PageController(
                    initialPage: _virtualIndex,
                    viewportFraction: activeViewport,
                  );
                }

                return Listener(
                  onPointerDown: (_) {
                    setState(() {
                      _isUserInteracting = true;
                    });
                  },
                  onPointerUp: (_) {
                    setState(() {
                      _isUserInteracting = false;
                      _resetTimer();
                    });
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _virtualIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final itemIndex = index % _items.length;
                      final item = _items[itemIndex];

                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * 0.08)).clamp(0.0, 1.0);
                          } else {
                            if (index != _virtualIndex) {
                              value = 0.92;
                            }
                          }
                          return Center(
                            child: Transform.scale(
                              scale: value,
                              child: Opacity(
                                opacity: value.clamp(0.5, 1.0),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: _CarouselCard(item: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // 3. Staggered Animated Page Indicators
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_items.length, (index) {
                final isSelected = (_virtualIndex % _items.length) == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: isSelected ? 24 : 8,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryGreen : AppColors.border,
                    borderRadius: BorderRadius.circular(100),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselCard extends StatefulWidget {
  final DemoItem item;

  const _CarouselCard({required this.item});

  @override
  State<_CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<_CarouselCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.05),
              blurRadius: _isHovered ? 30 : 15,
              offset: Offset(0, _isHovered ? 12 : 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // A. Netflix/Udemy Style Video Preview Area
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      // Video Thumbnail with hover zoom animation
                      Positioned.fill(
                        child: AnimatedScale(
                          scale: _isHovered ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          child: Image.asset(
                            widget.item.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: widget.item.gradientColors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.spa_outlined,
                                    size: 56,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Dark cinematic gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),

                      // Floating top badges
                      Positioned(
                        top: 14,
                        left: 14,
                        child: _GlassmorphicBadge(
                          child: Text(
                            "FREE DEMO",
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),

                      if (widget.item.isLive)
                        Positioned(
                          top: 14,
                          right: 14,
                          child: _PulseLiveBadge(),
                        ),

                      // Centered Play Button (Glows/scales on hover)
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.all(_isHovered ? 16 : 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGreen.withOpacity(0.4),
                                blurRadius: _isHovered ? 25 : 10,
                                spreadRadius: _isHovered ? 6 : 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),

                      // Bottom-left preview label
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.visibility,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Preview Session",
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom-right duration chip
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: _GlassmorphicBadge(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            widget.item.duration,
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // B. Details Block (Padding: 16)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title
                    Text(
                      widget.item.title,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Faculty Name
                    Text(
                      widget.item.faculty,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Rating & Enrolled Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Star Ratings
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFB300),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.item.rating.toString(),
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "(5-star reviews)",
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),

                        // Enrolled Students
                        Text(
                          "${widget.item.studentsCount} Students",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    const Divider(color: AppColors.border, height: 1, thickness: 1),
                    const SizedBox(height: 10),

                    // Metadata details (Duration / Language)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.play_circle_outline_rounded,
                              color: AppColors.textSecondary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.item.duration,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // C. Action Buttons
                    Row(
                      children: [
                        // Watch Demo (Primary Green)
                        Expanded(
                          child: _InteractiveActionButton(
                            text: "Watch Demo",
                            isPrimary: true,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Starting Free Demo of ${widget.item.title}...'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColors.primaryGreen,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),

                        // View Course (Outline secondary)
                        Expanded(
                          child: _InteractiveActionButton(
                            text: "View Course",
                            isPrimary: false,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening details for ${widget.item.title}...'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassmorphicBadge extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassmorphicBadge({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 0.8,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _PulseLiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.4, end: 1.0),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withOpacity(value),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withOpacity(0.4),
                blurRadius: 10 * (1 - value + 0.4),
                spreadRadius: 2,
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "LIVE",
                style: GoogleFonts.outfit(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}

class _InteractiveActionButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onTap;

  const _InteractiveActionButton({
    required this.text,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_InteractiveActionButton> createState() => _InteractiveActionButtonState();
}

class _InteractiveActionButtonState extends State<_InteractiveActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
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
            height: 48,
            decoration: BoxDecoration(
              color: widget.isPrimary
                  ? (_isHovered ? AppColors.primaryGreen : AppColors.buttonGreen)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: widget.isPrimary
                  ? null
                  : Border.all(
                      color: _isHovered ? AppColors.primaryGreen : AppColors.border,
                      width: 1.5,
                    ),
              boxShadow: [
                if (widget.isPrimary && _isHovered)
                  BoxShadow(
                    color: AppColors.buttonGreen.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: widget.isPrimary
                      ? Colors.white
                      : (_isHovered ? AppColors.primaryGreen : AppColors.textPrimary),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
