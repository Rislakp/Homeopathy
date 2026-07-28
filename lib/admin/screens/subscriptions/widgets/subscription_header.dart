import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/providers/subscription_plan_provider.dart';
import 'package:provider/provider.dart';
import 'add_subscription_dialog.dart';

class SubscriptionHeader extends StatelessWidget {
  const SubscriptionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionPlanProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        final textBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subscription Plans',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Manage pricing tiers available to students.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: const Color(0xFF4B5563),
              ),
            ),
          ],
        );

        final addButton = ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AddSubscriptionDialog(
                onSave: (newPlan) {
                  provider.addPlan(newPlan);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Subscription plan added successfully!'),
                      backgroundColor: Color(0xFF16A34A),
                    ),
                  );
                },
              ),
            );
          },
          icon: const Icon(Icons.add, size: 20),
          label: Text(
            'Add Plan',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF16A34A),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBlock,
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: addButton,
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              textBlock,
              addButton,
            ],
          );
        }
      },
    );
  }
}
