import 'package:flutter/material.dart';
import 'package:homeopathy/admin/models/subscription_model.dart';
import 'package:homeopathy/services/subscription_service.dart';


class SubscriptionPlanProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();

  List<SubscriptionPlanModel> _allPlans = [];
  List<SubscriptionPlanModel> _filteredPlans = [];

  bool _isLoading = false;
  String _searchQuery = '';
  String _billingFilter = 'All'; // 'All', 'Monthly', 'Quarterly', 'Half Yearly', 'Yearly', 'Lifetime'
  String _statusFilter = 'All';   // 'All', 'Active', 'Inactive', 'Popular'

  // Getters
  List<SubscriptionPlanModel> get plans => _filteredPlans;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get billingFilter => _billingFilter;
  String get statusFilter => _statusFilter;

  // Load plans
  Future<void> loadPlans() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allPlans = await _subscriptionService.fetchPlans();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading subscription plans: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add plan
  void addPlan(SubscriptionPlanModel plan) {
    _allPlans.insert(0, plan);
    _applyFilters();
  }

  // Update plan
  void updatePlan(SubscriptionPlanModel updatedPlan) {
    final index = _allPlans.indexWhere((p) => p.id == updatedPlan.id);
    if (index != -1) {
      _allPlans[index] = updatedPlan;
      _applyFilters();
    }
  }

  // Delete plan
  void deletePlan(String id) {
    _allPlans.removeWhere((p) => p.id == id);
    _applyFilters();
  }

  // Search plans
  void searchPlans(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filter plans
  void filterPlans(String billingCycle, String status) {
    _billingFilter = billingCycle;
    _statusFilter = status;
    _applyFilters();
  }

  // Toggle popular
  void togglePopular(String id) {
    final index = _allPlans.indexWhere((p) => p.id == id);
    if (index != -1) {
      final plan = _allPlans[index];
      _allPlans[index] = plan.copyWith(
        isPopular: !plan.isPopular,
        updatedAt: DateTime.now(),
      );
      _applyFilters();
    }
  }

  // Toggle active
  void toggleActive(String id) {
    final index = _allPlans.indexWhere((p) => p.id == id);
    if (index != -1) {
      final plan = _allPlans[index];
      _allPlans[index] = plan.copyWith(
        isActive: !plan.isActive,
        updatedAt: DateTime.now(),
      );
      _applyFilters();
    }
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _billingFilter = 'All';
    _statusFilter = 'All';
    _applyFilters();
  }

  // Internal filter logic
  void _applyFilters() {
    _filteredPlans = _allPlans.where((plan) {
      // 1. Search Query Match
      final matchesQuery = plan.planName.toLowerCase().contains(_searchQuery.trim().toLowerCase()) ||
          plan.billingCycle.toLowerCase().contains(_searchQuery.trim().toLowerCase()) ||
          plan.price.toString().contains(_searchQuery.trim()) ||
          plan.description.toLowerCase().contains(_searchQuery.trim().toLowerCase());

      // 2. Billing Cycle Match
      final matchesBilling = _billingFilter == 'All' || plan.billingCycle.toLowerCase() == _billingFilter.toLowerCase();

      // 3. Status Match
      bool matchesStatus = true;
      if (_statusFilter == 'Active') {
        matchesStatus = plan.isActive;
      } else if (_statusFilter == 'Inactive') {
        matchesStatus = !plan.isActive;
      } else if (_statusFilter == 'Popular') {
        matchesStatus = plan.isPopular;
      }

      return matchesQuery && matchesBilling && matchesStatus;
    }).toList();

    notifyListeners();
  }
}
