import 'package:flutter/material.dart';
import 'package:homeopathy/model/journey_model.dart';
import 'package:homeopathy/widgets/common_widgetts.dart/size.dart';

class JourneyCard extends StatelessWidget {
  final JourneyStepModel step;

  const JourneyCard({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.green.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Text(
              step.number.toString().padLeft(2, "0"),
              style: TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade200,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xff009B5A),
                child: Icon(step.icon, color: Colors.white),
              ),

            
              AppSpacing.h25,

              Text(
                step.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

             
              AppSpacing.h16,

              Text(
                step.description,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
