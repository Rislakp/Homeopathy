import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/providers/subscription_plan_provider.dart';
import 'package:provider/provider.dart';


class SubscriptionSearchFilterBar extends StatelessWidget {
  const SubscriptionSearchFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionPlanProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        final searchField = TextField(
          onChanged: (val) => provider.searchPlans(val),
          decoration: InputDecoration(
            hintText: 'Search by plan name, billing cycle, price...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF16A34A), width: 2),
            ),
          ),
        );

        final billingCycleDropdown = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.billingFilter,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF4B5563)),
              onChanged: (val) {
                if (val != null) {
                  provider.filterPlans(val, provider.statusFilter);
                }
              },
              items: ['All', 'Monthly', 'Quarterly', 'Half Yearly', 'Yearly', 'Lifetime'].map((cycle) {
                return DropdownMenuItem<String>(
                  value: cycle,
                  child: Text(
                    cycle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );

        final statusDropdown = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.statusFilter,
              icon: const Icon(Icons.filter_list_rounded, color: Color(0xFF4B5563)),
              onChanged: (val) {
                if (val != null) {
                  provider.filterPlans(provider.billingFilter, val);
                }
              },
              items: ['All', 'Active', 'Inactive', 'Popular'].map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchField,
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: billingCycleDropdown),
                  const SizedBox(width: 12),
                  Expanded(child: statusDropdown),
                ],
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(flex: 3, child: searchField),
              const SizedBox(width: 16),
              billingCycleDropdown,
              const SizedBox(width: 16),
              statusDropdown,
            ],
          );
        }
      },
    );
  }
}
