import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:homeopathy/core/theme/app_colors.dart';
import 'pricing_model.dart';

class PricingCard extends StatefulWidget {
  final PricingPlanModel plan;
  final bool isSelected;
  final VoidCallback onSelect;

  const PricingCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<PricingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 0);
    final isSelected = widget.isSelected;
    final isPopular = widget.plan.isPopular;

    final Color cardBg = isSelected ? AppColors.primary : Colors.white;
    final Color textColor = isSelected ? Colors.white : AppColors.textPrimary;
    final Color textSecColor = isSelected ? Colors.white.withValues(alpha: 0.85) : AppColors.textSecondary;

    final Color borderCol = isSelected
        ? Colors.transparent
        : (isPopular ? AppColors.primary : AppColors.border);

    final double borderWidth = isSelected ? 0.0 : (isPopular ? 2.0 : 1.0);

    final Color buttonBg = isSelected
        ? Colors.white
        : (isPopular ? AppColors.secondary : AppColors.primary);

    final Color buttonTextCol = isSelected ? AppColors.primary : Colors.white;

    final double scale = _isHovered ? (isPopular ? 1.03 : 1.02) : (isPopular ? 1.01 : 1.0);
    final double translationY = _isHovered ? -6.0 : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, translationY, 0),
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: isPopular ? 34 : 26,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderCol,
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: _isHovered ? 0.35 : 0.15)
                    : const Color(0xFF0F172A).withValues(alpha: _isHovered ? 0.10 : 0.04),
                blurRadius: _isHovered ? 24 : 12,
                offset: Offset(0, _isHovered ? 10 : 4),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Floating Popular Badge
              if (isPopular)
                Positioned(
                  top: -46,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        "MOST POPULAR",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),

              // Card details structure
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan Level Title
                  Text(
                    widget.plan.name.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: textSecColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Pricing Layout
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        currencyFormatter.format(widget.plan.price),
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '/ ${widget.plan.duration}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textSecColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isSelected ? Colors.white24 : AppColors.border,
                  ),
                  const SizedBox(height: 16),

                  // Features check list
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.plan.features.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final feature = widget.plan.features[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: isSelected ? Colors.white : AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: textColor.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Choose/Selected button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: _CardActionButton(
                      text: isSelected ? "Selected" : "Choose Plan",
                      backgroundColor: buttonBg,
                      textColor: buttonTextCol,
                      onTap: widget.onSelect,
                      isSelected: isSelected,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardActionButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;
  final bool isSelected;

  const _CardActionButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<_CardActionButton> createState() => _CardActionButtonState();
}

class _CardActionButtonState extends State<_CardActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              if (_isHovered && !widget.isSelected)
                BoxShadow(
                  color: widget.backgroundColor.withValues(alpha: 0.30),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isSelected) ...[
                  Icon(
                    Icons.check_rounded,
                    color: widget.textColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  widget.text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
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
