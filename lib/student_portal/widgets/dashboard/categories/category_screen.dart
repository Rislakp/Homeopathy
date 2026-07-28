import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_card.dart';
import 'category_data.dart';
import 'category_provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryUIProvider(),
      child: const CategoryScreenContent(),
    );
  }
}

class CategoryScreenContent extends StatelessWidget {
  const CategoryScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = CategoryData.categories;

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;

        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1000) {
          crossAxisCount = 2;
        } else if (constraints.maxWidth < 1400) {
          crossAxisCount = 3;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FeaturedBadge(),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                "Learn What you love.Master What \nyou need",
                style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
              ),
            ),

            
               GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 150, 
                ),
                itemBuilder: (context, index) {
                  return CategoryCard(
                    category: categories[index],
                  );
                },
              ),
            
          ],
        );
      },
    );
  }
}
class _FeaturedBadge extends StatelessWidget {
  const _FeaturedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5EC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 8, color: Color(0xFF2E7D4F)),
          const SizedBox(width: 6),
          const Text(
            'Popular Categories',
            style: TextStyle(
              color: Color(0xFF2E7D4F),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}