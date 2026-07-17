import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';


class PricingCard extends StatelessWidget {
  final PricingModel plan;

  const PricingCard({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [

        Container(
          width: 370,
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.green.shade100,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              Text(
                plan.title,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  const Text(
                    "₹",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    plan.price,
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 5),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      plan.duration,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              ...plan.features
                  .map((e) => FeatureTile(text: e))
                  .toList(),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan.isPopular
                        ? Colors.green
                        : Colors.green.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},

                  child: Text(
                    "Get started",
                    style: TextStyle(
                      color: plan.isPopular
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        if (plan.isPopular)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              "MOST POPULAR",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
      ],
    );
  }
}