// lib/widgets/dashboard/pricing/pricing_section.dart

import 'package:flutter/material.dart';
import 'package:homeopathy/widgets/common_widgetts.dart/size.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/provider/pricing_provider.dart';
import 'package:homeopathy/widgets/dashboard/pricing/pricing_card.dart';
import 'package:homeopathy/widgets/dashboard/pricing/section_badge.dart';

class PricingSection extends StatelessWidget {
  const PricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PricingProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionBadge(label: 'Pricing'),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text(
                    'Simple plans. Serious outcomes.',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  label: const Text('Compare all plans'),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  iconAlignment: IconAlignment.end,
                ),
              ],
            ),
         
            AppSpacing.h8,
            Text(
              'No hidden fees. Cancel anytime. 7-day money-back guarantee.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 48),
            _buildContent(context, provider),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, PricingProvider provider) {
    if (provider.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              Text('Failed to load plans: ${provider.error}'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => provider.fetchPlans(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.plans.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: Text('No pricing plans found')),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;

        final cards = provider.plans
            .map((plan) => PricingCard(plan: plan, onGetStarted: () {}))
            .toList();

        if (isNarrow) {
          return Column(
            children: cards
                .map((card) => Padding(padding: const EdgeInsets.only(bottom: 24), child: card))
                .toList(),
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cards
                .map((card) => Expanded(
                      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: card),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}