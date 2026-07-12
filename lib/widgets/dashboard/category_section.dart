import 'package:flutter/material.dart';
import 'package:homeopathy/provider/category_provider.dart';
import 'package:provider/provider.dart';

import 'category_card.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 10, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                "Popular Categories",
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        const Text(
          "Learn what you love. Master what you need.",
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        const Text(
          "From AIAPGET and NEET PG to the classical pillars of homeopathy — pick your track.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),

        const SizedBox(height: 40),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,

            mainAxisExtent: 220,
          ),
          itemBuilder: (context, index) {
            return CategoryCard(category: provider.categories[index]);
          },
        ),
      ],
    );
  }
}
