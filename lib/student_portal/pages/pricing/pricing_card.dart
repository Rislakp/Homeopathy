import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  static const Color primaryGreen = Color(0xFF0F9D58);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 0);
    final isSelected = widget.isSelected;
    final isPopular = widget.plan.isPopular;

    // Transition values based on selection & design tokens
    final Color cardBg = isSelected ? primaryGreen : Colors.white;
    final Color textColor = isSelected ? Colors.white : const Color(0xFF1E293B);
    final Color textSecColor = isSelected ? Colors.white.withOpacity(0.8) : const Color(0xFF64748B);
    
    final Color borderCol = isSelected 
        ? Colors.transparent 
        : (isPopular ? primaryGreen : const Color(0xFFE2E8F0));

    final double borderWidth = isSelected ? 0.0 : (isPopular ? 2.5 : 1.0);

    // Button states
    final Color buttonBg = isSelected
        ? Colors.white
        : (isPopular ? const Color(0xFF1E293B) : primaryGreen);

    final Color buttonTextCol = isSelected ? primaryGreen : Colors.white;

    // Hover transformation calculations
    final double scale = _isHovered ? (isPopular ? 1.05 : 1.03) : (isPopular ? 1.02 : 1.0);
    final double translationY = _isHovered ? -8.0 : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, translationY, 0),
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: isPopular ? 36 : 28,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: borderCol,
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                    ? primaryGreen.withOpacity(_isHovered ? 0.35 : 0.15)
                    : Colors.black.withOpacity(_isHovered ? 0.12 : 0.05),
                blurRadius: _isHovered ? 30 : 15,
                offset: Offset(0, _isHovered ? 12 : 6),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Floating Popular Badge
              if (isPopular)
                Positioned(
                  top: -50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        "MOST POPULAR",
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
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
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: textSecColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pricing Layout
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        currencyFormatter.format(widget.plan.price),
                        style: GoogleFonts.outfit(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '/ ${widget.plan.duration}',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textSecColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isSelected ? Colors.white24 : Colors.black12,
                  ),
                  const SizedBox(height: 20),

                  // Features check list
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.plan.features.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final feature = widget.plan.features[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: isSelected ? Colors.white : primaryGreen,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                feature,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: textColor.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Choose/Selected button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
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
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              if (_isHovered && !widget.isSelected)
                BoxShadow(
                  color: widget.backgroundColor.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isSelected) ...[
                    Icon(
                      Icons.check_rounded,
                      color: widget.textColor,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    widget.text,
                    key: ValueKey<String>(widget.text),
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
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
