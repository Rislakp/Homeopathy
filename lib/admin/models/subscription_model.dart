class SubscriptionPlanModel {
  final String id;
  final String planName;
  final double price;
  final String billingCycle; // 'Monthly', 'Quarterly', 'Half Yearly', 'Yearly', 'Lifetime'
  final String description;
  final List<String> features;
  final bool isPopular;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubscriptionPlanModel({
    required this.id,
    required this.planName,
    required this.price,
    required this.billingCycle,
    required this.description,
    required this.features,
    required this.isPopular,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  SubscriptionPlanModel copyWith({
    String? id,
    String? planName,
    double? price,
    String? billingCycle,
    String? description,
    List<String>? features,
    bool? isPopular,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionPlanModel(
      id: id ?? this.id,
      planName: planName ?? this.planName,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      description: description ?? this.description,
      features: features ?? this.features,
      isPopular: isPopular ?? this.isPopular,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
