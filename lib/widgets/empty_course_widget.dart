import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class EmptyCourseWidget extends StatelessWidget {
  final VoidCallback onClear;

  const EmptyCourseWidget({
    super.key,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp vertical padding so the widget never forces a fixed tall height
    // on short screens (e.g. small browser windows or mobile viewports).
    final double screenHeight = MediaQuery.of(context).size.height;
    final double vPadding = (screenHeight * 0.06).clamp(16.0, 60.0);

    return Container(
      padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      // SingleChildScrollView prevents the RenderFlex overflow error when the
      // available vertical space is smaller than the column's intrinsic height.
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 60,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No Courses Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We couldn\'t find any courses matching your criteria.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Clear Filters', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
