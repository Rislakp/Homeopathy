import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_textstyles.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onReset;

  const EmptyState({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modern Illustration Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration:  BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search_outlined,
                size: 64,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Students Found',
              style: AppTextStyles.title.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find any students matching your search criteria.',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
