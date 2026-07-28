import 'package:flutter/material.dart';
import '../../../theme/admin_colors.dart';
import '../../../models/category_model.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
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
        transform: Matrix4.identity()
          ..translate(_isHovered ? -2.0 : 0.0, _isHovered ? -2.0 : 0.0)
          ..scale(_isHovered ? 1.025 : 1.0),
        decoration: BoxDecoration(
          color: AdminColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isHovered 
                ? AdminColors.primary.withOpacity(0.5) 
                : AdminColors.border, 
            width: 1,
          ),
          boxShadow: _isHovered ? AdminColors.hoverShadow : AdminColors.softShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap ?? () {},
              borderRadius: BorderRadius.circular(18),
              splashColor: AdminColors.primary.withOpacity(0.08),
              highlightColor: AdminColors.primary.withOpacity(0.04),
              hoverColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top: Large Icon (44px range)
                    Text(
                      widget.category.icon,
                      style: const TextStyle(
                        fontSize: 44,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Center: Category Name
                    Text(
                      widget.category.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AdminColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Bottom: Course Count
                    Text(
                      '${widget.category.courseCount} courses',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AdminColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
