import 'package:flutter/material.dart';
import 'package:homeopathy/widgets/dashboard/action_button.dart';
import 'package:homeopathy/widgets/dashboard/search_bar.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "India's #1 Homeopathy Learning Platform",
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          "Master\nHomeopathy.",
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          "Clear Every Exam.",
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "Live classes, mock tests and personal mentorship from India's top homeopathy faculty.",
          style: TextStyle(
            fontSize: 22,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 30),

        const SearchBarWidget(),

        const SizedBox(height: 25),

        const ActionButtons(),

        const SizedBox(height: 30),

        Row(
          children: const [
            CircleAvatar(radius: 16),
            CircleAvatar(radius: 16),
            CircleAvatar(radius: 16),
            SizedBox(width: 10),
            Text(
              "1,20,000+ learners",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      ],
    );
  }
}