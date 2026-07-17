import 'package:flutter/material.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/size.dart';
import 'package:provider/provider.dart';
import 'package:homeopathy/student_portal/provider/category_provider.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int index;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        final isSelected = provider.selectedIndex == index;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            provider.selectCategory(index);
          },
          onExit: (_) {
            provider.clearSelected();
          },
          child: GestureDetector(
            onTap: () {
              provider.selectCategory(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: isSelected ? Colors.white : Colors.green,
                  ),
             
               AppSpacing.h16,
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                 
                  AppSpacing.h8,
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
