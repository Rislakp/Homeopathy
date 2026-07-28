import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/category_model.dart';
import '../../theme/admin_colors.dart';
import 'widgets/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<CategoryModel> _categories = [
    CategoryModel(icon: '📖', title: 'Materia Medica', courseCount: 24),
    CategoryModel(icon: '🔍', title: 'Repertory', courseCount: 16),
    CategoryModel(icon: '📜', title: 'Organon of Medicine', courseCount: 12),
    CategoryModel(icon: '🧸', title: 'Pediatric Homeopathy', courseCount: 9),
    CategoryModel(icon: '⚗️', title: 'Homeopathic Pharmacy', courseCount: 7),
    CategoryModel(icon: '🧪', title: 'Case Studies', courseCount: 20),
    CategoryModel(icon: '🩺', title: 'Chronic Diseases', courseCount: 14),
    CategoryModel(icon: '💼', title: 'Practice Management', courseCount: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive Header Row
              LayoutBuilder(
                builder: (context, headerConstraints) {
                  final isSmallScreen = headerConstraints.maxWidth < 600;
                  if (isSmallScreen) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Course Categories',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Organize your curriculum',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: _AddCategoryButton(),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Course Categories',
                              style: GoogleFonts.inter(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AdminColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Organize your curriculum',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AdminColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const _AddCategoryButton(),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 36),

              // Responsive Categories Grid
              LayoutBuilder(
                builder: (context, gridConstraints) {
                  int crossAxisCount;
                  double aspectRatio;

                  if (gridConstraints.maxWidth >= 1100) {
                    crossAxisCount = 4; // Desktop
                    aspectRatio = 1.1;
                  } else if (gridConstraints.maxWidth >= 768) {
                    crossAxisCount = 3; // Tablet
                    aspectRatio = 1.0;
                  } else {
                    crossAxisCount = 2; // Mobile
                    aspectRatio = 0.9;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        category: _categories[index],
                        onTap: () {
                          // Handle card tap callback
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddCategoryButton extends StatefulWidget {
  const _AddCategoryButton();

  @override
  State<_AddCategoryButton> createState() => _AddCategoryButtonState();
}

class _AddCategoryButtonState extends State<_AddCategoryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isHovered ? 1.025 : 1.0),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFF059669) : const Color(0xFF10B981),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(_isHovered ? 0.35 : 0.2),
              blurRadius: _isHovered ? 10 : 6,
              offset: _isHovered ? const Offset(0, 4) : const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Adding category...'),
                  backgroundColor: Color(0xFF10B981),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add Category',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
