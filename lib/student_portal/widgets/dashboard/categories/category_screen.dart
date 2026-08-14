import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/core/theme/app_colors.dart';
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
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                "Learn What you love. Master What \nyou need",
                style: GoogleFonts.inter(
                  fontSize: constraints.maxWidth < 600 ? 26 : 34,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 160,
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
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryBorder),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: AppColors.primary),
          SizedBox(width: 6),
          Text(
            'Popular Categories',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}