import 'package:flutter/material.dart';

// The top part of the screen: "Featured Courses" pill, heading,
// subtitle, and the "Browse all courses" button.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder lets the row of text + button wrap on narrow screens
    // instead of overflowing — a simple, beginner-friendly responsive trick.
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        final titleBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FeaturedBadge(),
            const SizedBox(height: 16),
            const Text(
              'Handpicked programs to\naccelerate your prep.',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Curated by our academic council. Trusted by rank holders across India.',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        );

        final browseButton = OutlinedButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
          icon: const Text(
            'Browse all courses',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          label: const Icon(Icons.arrow_forward, size: 18),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleBlock,
              const SizedBox(height: 16),
              Align(alignment: Alignment.centerLeft, child: browseButton),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: titleBlock),
            browseButton,
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
            'Featured Courses',
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