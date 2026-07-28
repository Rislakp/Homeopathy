import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/models/live_class_model.dart';
import 'package:intl/intl.dart';
import 'delete_live_class_dialog.dart';
import 'edit_live_class_dialog.dart';

class LiveClassRow extends StatefulWidget {
  final LiveClassModel liveClass;
  final VoidCallback onView;
  final Function(LiveClassModel) onEdit;
  final VoidCallback onDelete;

  const LiveClassRow({
    super.key,
    required this.liveClass,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<LiveClassRow> createState() => _LiveClassRowState();
}

class _LiveClassRowState extends State<LiveClassRow> {
  bool _isHovered = false;

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return const Color(0xFF16A34A); // Green
      case 'upcoming':
        return const Color(0xFF2563EB); // Blue
      case 'completed':
        return const Color(0xFF4B5563); // Gray
      case 'cancelled':
        return const Color(0xFFDC2626); // Red
      default:
        return const Color(0xFF4B5563);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return const Color(0xFFDCFCE7);
      case 'upcoming':
        return const Color(0xFFDBEAFE);
      case 'completed':
        return const Color(0xFFF3F4F6);
      case 'cancelled':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lc = widget.liveClass;
    final dateStr = DateFormat('dd MMM yyyy').format(lc.date);
    final timeStr =
        '${lc.startTime.format(context)} - ${lc.endTime.format(context)}';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        transform: Matrix4.identity()
          ..translate(_isHovered ? -2.0 : 0.0, _isHovered ? -1.0 : 0.0)
          ..scale(_isHovered ? 1.008 : 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF16A34A).withOpacity(0.4)
                : const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.06 : 0.03),
              blurRadius: _isHovered ? 12 : 8,
              offset: _isHovered ? const Offset(0, 4) : const Offset(0, 2),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 750;

            final classTitleWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lc.title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
          
                const SizedBox(height: 2),
                Text(
                  lc.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            );
          

            final instructorWidget = Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 16,
                  color: Color(0xFF9CA3AF),
                ),
          
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    lc.instructor,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF374151),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          
            final dateTimeWidget = Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      Text(
                        timeStr,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );

            final statusBadge = Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusBgColor(lc.status),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                lc.status,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: _getStatusTextColor(lc.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );

            final actionButtons = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                  tooltip: 'View Class',
                  color: const Color(0xFF16A34A),
                  onPressed: widget.onView,
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: 'Edit Class',
                  color: const Color(0xFF4B5563),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => EditLiveClassDialog(
                        liveClass: lc,
                        onUpdate: widget.onEdit,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  tooltip: 'Delete Class',
                  color: const Color(0xFFEF4444),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => DeleteLiveClassDialog(
                        title: lc.title,
                        onDelete: widget.onDelete,
                      ),
                    );
                  },
                ),
              ],
            );

            if (isMobile) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.hourglass_empty_rounded,
                                    size: 14,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    lc.duration,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF4B5563),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.people_outline_rounded,
                                    size: 14,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${lc.enrolledStudents}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF4B5563),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        FittedBox(child: actionButtons),
                      ],
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        classTitleWidget,
                        const SizedBox(height: 12),
                        instructorWidget,
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dateTimeWidget,
                        const SizedBox(height: 8),
                        statusBadge,
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: actionButtons,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
