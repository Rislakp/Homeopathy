import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/models/live_class_model.dart';
import 'live_class_row.dart';

class LiveClassTable extends StatelessWidget {
  final List<LiveClassModel> liveClasses;
  final Function(LiveClassModel) onView;
  final Function(LiveClassModel) onEdit;
  final Function(LiveClassModel) onDelete;

  const LiveClassTable({
    super.key,
    required this.liveClasses,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 750;

        return Column(
          children: [
            // Table Header (Hidden on Mobile)
            if (!isMobile)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _headerCell('Class')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _headerCell('Instructor')),
                    const SizedBox(width: 8),
                    Expanded(flex: 3, child: _headerCell('Date & Time')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _headerCell('Duration')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _headerCell('Enrolled')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _headerCell('Status')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: _headerCell('Actions'))),
                  ],
                ),
              ),
            
            // List of Rows
            Expanded(
              child: ListView.builder(
                itemCount: liveClasses.length,
                padding: const EdgeInsets.only(bottom: 24),
                itemBuilder: (context, index) {
                  final lc = liveClasses[index];
                  return LiveClassRow(
                    liveClass: lc,
                    onView: () => onView(lc),
                    onEdit: onEdit,
                    onDelete: () => onDelete(lc),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _headerCell(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF6B7280), // Neutral Muted Text
      ),
    );
  }
}
