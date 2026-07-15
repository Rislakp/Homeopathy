// lib/widgets/dashboard/pricing/pricing_card.dart

import 'package:flutter/material.dart';
import 'package:homeopathy/model/pricingPlan.dart';
import 'package:homeopathy/widgets/common_widgetts.dart/size.dart';


class PricingCard extends StatelessWidget {
  final PricingPlan plan;
  final VoidCallback? onGetStarted;

  const PricingCard({super.key, required this.plan, this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final isPopular = plan.isPopular;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPopular ? Colors.teal : Colors.grey.shade200,
              width: isPopular ? 1.5 : 1,
            ),
            boxShadow: isPopular
                ? [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                plan.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.teal),
              ),
             AppSpacing.h12,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: plan.price,
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: ' ${plan.period}',
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            AppSpacing.h12,
              //...plan.features.map((f) => FeatureRow(text: f)),
             
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPopular ? Colors.teal : Colors.teal.shade50,
                    foregroundColor: isPopular ? Colors.white : Colors.teal.shade800,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Get started', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
        if (isPopular)
          Positioned(
            top: -14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(20)),
                child: const Text(
                  'MOST POPULAR',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ),
            ),
          ),
      ],
    );
  }
}