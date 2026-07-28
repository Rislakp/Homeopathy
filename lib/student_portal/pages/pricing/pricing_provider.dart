import 'package:flutter/material.dart';
import 'pricing_model.dart';

class PricingProvider extends ChangeNotifier {
  final List<PricingPlanModel> _plans = const [
    PricingPlanModel(
      id: 'monthly',
      name: 'Monthly',
      price: 999,
      duration: 'month',
      features: [
        'Live Classes',
        'Weekly Tests',
        'Doubt Support',
        'Mobile Access',
      ],
    ),
    PricingPlanModel(
      id: 'quarterly',
      name: 'Quarterly',
      price: 2499,
      duration: 'quarter',
      features: [
        'Everything in Monthly',
        'Download Notes',
        'Community Access',
      ],
    ),
    PricingPlanModel(
      id: 'half_yearly',
      name: 'Half Yearly',
      price: 4999,
      duration: '6 months',
      features: [
        'Everything in Quarterly',
        'Test Analysis',
        'Priority Support',
      ],
    ),
    PricingPlanModel(
      id: 'annual',
      name: 'Annual',
      price: 8999,
      duration: 'year',
      features: [
        'Everything Above',
        'Personal Mentor',
        'Rank Predictor',
        'Revision Notes',
      ],
      isPopular: true,
    ),
    PricingPlanModel(
      id: 'lifetime',
      name: 'Lifetime',
      price: 29999,
      duration: 'lifetime',
      features: [
        'Lifetime Access',
        'Alumni Community',
        'Future Updates',
        'One-to-One Mentorship',
      ],
    ),
  ];

  List<PricingPlanModel> get plans => _plans;

  String? _selectedPlanId;

  String? get selectedPlanId => _selectedPlanId;

  void selectPlan(String planId) {
    _selectedPlanId = planId;
    notifyListeners();
  }
}
