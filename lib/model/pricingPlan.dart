// lib/models/pricing_plan_model.dart

class PricingPlan {
  final String id;
  final String name;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;

  const PricingPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    this.isPopular = false,
  });

  factory PricingPlan.fromJson(Map<String, dynamic> json) => PricingPlan(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        price: json['price'] ?? '',
        period: json['period'] ?? '',
        features: List<String>.from(json['features'] ?? []),
        isPopular: json['isPopular'] ?? false,
      );
}