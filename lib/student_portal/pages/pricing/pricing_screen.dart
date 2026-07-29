import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pricing_provider.dart';
import 'pricing_card.dart';
import 'package:homeopathy/responsive/responsive_layout.dart';
import 'package:homeopathy/responsive/mobile/pricing_mobile.dart';
import 'package:homeopathy/responsive/tablet/pricing_tablet.dart';
import 'package:homeopathy/responsive/desktop/pricing_desktop.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PricingProvider(),
      child: const _PricingScreenContent(),
    );
  }
}

class _PricingScreenContent extends StatelessWidget {
  const _PricingScreenContent();

  static const Color primaryGreen = Color(0xFF0F9D58);
  static const Color scaffoldBg = Color(0xFFF7FBF9);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1200;

    final mainBody = Container(
      color: scaffoldBg,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeaderSection(isMobile),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : (isTablet ? 24 : 40),
                vertical: 30,
              ),
              child: Consumer<PricingProvider>(
                builder: (context, provider, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = 5;
                      double cardHeight = 440;

                      if (isMobile) {
                        columns = 1;
                        cardHeight = 390;
                      } else if (isTablet) {
                        columns = 2;
                        cardHeight = 410;
                      }

                      final double gridWidth = constraints.maxWidth;
                      final double gap = 20.0;
                      final double cardWidth = (gridWidth - (gap * (columns - 1))) / columns;
                      final double childAspectRatio = cardWidth / cardHeight;

                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1400),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.plans.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              mainAxisSpacing: 36,
                              crossAxisSpacing: gap,
                              childAspectRatio: childAspectRatio,
                            ),
                            itemBuilder: (context, index) {
                              final plan = provider.plans[index];
                              final isSelected = provider.selectedPlanId == plan.id;

                              return _FadeInStaggered(
                                index: index,
                                child: PricingCard(
                                  plan: plan,
                                  isSelected: isSelected,
                                  onSelect: () {
                                    provider.selectPlan(plan.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Plan selected: ${plan.name}'),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: primaryGreen,
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );

    return ResponsiveLayout(
      mobile: PricingMobile(body: mainBody),
      tablet: PricingTablet(body: mainBody),
      desktop: PricingDesktop(body: mainBody),
    );
  }

  Widget _buildHeaderSection(bool isMobile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : 48.0,
        vertical: 40.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "PRICING PLANS",
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: primaryGreen,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Simple plans.\nSerious outcomes.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: isMobile ? 32 : 44,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E293B),
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Choose the best plan for your learning journey.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FadeInStaggered extends StatelessWidget {
  final Widget child;
  final int index;

  const _FadeInStaggered({
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0.0, 30.0 * (1.0 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
