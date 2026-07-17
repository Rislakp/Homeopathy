import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class PricingProvider extends ChangeNotifier {
  final List<PricingModel> plans = [

    PricingModel(
      title: "Monthly",
      price: "999",
      duration: "/mo",
      features: [
        "All live classes",
        "Weekly mock tests",
        "Doubt support",
      ],
    ),

    PricingModel(
      title: "Annual",
      price: "8,999",
      duration: "/yr",
      isPopular: true,
      features: [
        "Everything in Monthly",
        "Personal mentor",
        "Rank predictor",
        "Downloadable notes",
      ],
    ),

    PricingModel(
      title: "Lifetime",
      price: "29,999",
      duration: "once",
      features: [
        "All programs forever",
        "1:1 mentorship",
        "Priority support",
        "Alumni network",
      ],
    ),

  ];
}