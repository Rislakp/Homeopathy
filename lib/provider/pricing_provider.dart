// lib/provider/pricing_provider.dart

import 'package:flutter/material.dart';
import 'package:homeopathy/model/pricingPlan.dart';


class PricingProvider extends ChangeNotifier {
  List<PricingPlan> _plans = [];
  bool _isLoading = false;
  String? _error;

  List<PricingPlan> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPlans() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _plans = const [
        PricingPlan(
          id: '1',
          name: 'Monthly',
          price: '₹999',
          period: '/mo',
          features: ['All live classes', 'Weekly mock tests', 'Doubt support'],
        ),
        PricingPlan(
          id: '2',
          name: 'Annual',
          price: '₹8,999',
          period: '/yr',
          isPopular: true,
          features: [
            'Everything in Monthly',
            'Personal mentor',
            'Rank predictor',
            'Downloadable notes',
          ],
        ),
        PricingPlan(
          id: '3',
          name: 'Lifetime',
          price: '₹29,999',
          period: 'once',
          features: [
            'All programs forever',
            '1:1 mentorship',
            'Priority support',
            'Alumni network',
          ],
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}