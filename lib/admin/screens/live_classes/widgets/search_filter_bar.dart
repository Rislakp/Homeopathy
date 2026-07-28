import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/providers/live_class_provider.dart';
import 'package:provider/provider.dart';
import 'add_live_class_dialog.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiveClassProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 750;

        final searchField = TextField(
          onChanged: (val) => provider.searchLiveClasses(val),
          decoration: InputDecoration(
            hintText: 'Search by class, instructor, link...',
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
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF4B5563)),
              onChanged: (val) {
                if (val != null) {
                  provider.filterByStatus(val);
                }
              },
              items: ['All', 'Upcoming', 'Live', 'Completed', 'Cancelled'].map((status) {
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

        final sortDropdown = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.sortBy,
              icon: const Icon(Icons.sort_rounded, color: Color(0xFF4B5563)),
              onChanged: (val) {
                if (val != null) {
                  provider.sortByDate(val);
                }
              },
              items: ['Newest', 'Oldest', 'Date'].map((sortType) {
                return DropdownMenuItem<String>(
                  value: sortType,
                  child: Text(
                    sortType,
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

        final scheduleButton = ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AddLiveClassDialog(
                onSave: (newClass) {
                  provider.addLiveClass(newClass);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Live class scheduled successfully!'),
                      backgroundColor: Color(0xFF16A34A),
                    ),
                  );
                },
              ),
            );
          },
          icon: const Icon(Icons.add, size: 20),
          label: Text(
            'Schedule Class',
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchField,
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: statusDropdown),
                  const SizedBox(width: 12),
                  Expanded(child: sortDropdown),
                ],
              ),
              const SizedBox(height: 12),
              scheduleButton,
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(flex: 3, child: searchField),
              const SizedBox(width: 16),
              statusDropdown,
              const SizedBox(width: 16),
              sortDropdown,
              const SizedBox(width: 16),
              scheduleButton,
            ],
          );
        }
      },
    );
  }
}
