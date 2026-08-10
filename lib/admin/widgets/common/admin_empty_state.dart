import 'package:flutter/material.dart';
import 'package:homeopathy/utils/app_colors.dart';
import '../../theme/admin_colors.dart';

class AdminEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onReset;

  const AdminEmptyState({
    super.key,
    this.title = 'No Records Found',
    this.message = 'There are no items matching your criteria. Try adjusting your filters or search terms.',
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          if (onReset != null) ...[
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reset Filters'),
            ),
          ],
        ],
      ),
    );
  }
}
