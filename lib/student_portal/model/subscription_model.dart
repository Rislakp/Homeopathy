class PricingModel {
  final String title;
  final String price;
  final String duration;
  final List<String> features;
  final bool isPopular;

  PricingModel({
    required this.title,
    required this.price,
    required this.duration,
    required this.features,
    this.isPopular = false,
  });
}