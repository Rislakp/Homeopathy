import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/models/live_class_model.dart';
import 'package:homeopathy/admin/providers/live_class_provider.dart';
import 'package:homeopathy/admin/screens/live_classes/widgets/add_live_class_dialog.dart';
import 'package:homeopathy/admin/screens/live_classes/widgets/empty_state.dart';
import 'package:homeopathy/admin/screens/live_classes/widgets/live_class_table.dart';
import 'package:homeopathy/admin/screens/live_classes/widgets/loading_widget.dart';
import 'package:homeopathy/admin/screens/live_classes/widgets/search_filter_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LiveClassesScreen extends StatefulWidget {
  const LiveClassesScreen({super.key});

  @override
  State<LiveClassesScreen> createState() => _LiveClassesScreenState();
}

class _LiveClassesScreenState extends State<LiveClassesScreen> {
  @override
  void initState() {
    super.initState();
    // Load live classes on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveClassProvider>().loadLiveClasses();
    });
  }

  void _showViewDetailsDialog(BuildContext context, LiveClassModel lc) {
    final dateStr = DateFormat('EEEE, dd MMMM yyyy').format(lc.date);
    final timeStr = '${lc.startTime.format(context)} - ${lc.endTime.format(context)}';

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: Text(
                        lc.status.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF16A34A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Class Title
                Text(
                  lc.title,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                
                // Instructor
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded, size: 16, color: Color(0xFF6B7280)),
                    const SizedBox(width: 6),
                    Text(
                      'Instructor: ${lc.instructor}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF4B5563),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),

                // Date, Time, Duration
                _infoRow(Icons.calendar_today_outlined, 'Date', dateStr),
                const SizedBox(height: 12),
                _infoRow(Icons.access_time_rounded, 'Time', timeStr),
                const SizedBox(height: 12),
                _infoRow(Icons.hourglass_empty_rounded, 'Duration', lc.duration),
                const SizedBox(height: 12),
                _infoRow(Icons.people_outline_rounded, 'Enrolled Students', '${lc.enrolledStudents} students'),
                
                const Divider(height: 32),

                // Description
                Text(
                  'About this Class',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: const Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  lc.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF4B5563),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Meeting Button Link
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Launching Meeting Room at: ${lc.meetingLink}'),
                          backgroundColor: const Color(0xFF16A34A),
                        ),
                      );
                    },
                    icon: const Icon(Icons.videocam_rounded, size: 20),
                    label: Text(
                      'Join Live Session',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, 
        size: 16,
         color: const Color(0xFF9CA3AF),
         ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          maxLines: 1,
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280), fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF111827), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiveClassProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live Classes',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Schedule and manage live sessions.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Filter Controls
              const SearchFilterBar(),
              const SizedBox(height: 24),

              // Responsive List States
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _buildBody(provider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(LiveClassProvider provider) {
    if (provider.isLoading) {
      return const LoadingWidget(
        key: ValueKey('loading'),
        message: 'Fetching live sessions...',
      );
    }

    if (provider.liveClasses.isEmpty) {
      return EmptyState(
        key: const ValueKey('empty'),
        onSchedulePressed: () {
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
      );
    }

    return LiveClassTable(
      key: const ValueKey('table'),
      liveClasses: provider.liveClasses,
      onView: (lc) => _showViewDetailsDialog(context, lc),
      onEdit: (updated) {
        provider.updateLiveClass(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Live class "${updated.title}" updated successfully!'),
            backgroundColor: const Color(0xFF16A34A),
          ),
        );
      },
      onDelete: (lc) {
        provider.deleteLiveClass(lc.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Live class "${lc.title}" deleted.'),
            backgroundColor: const Color(0xFFEF4444),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () {
                provider.addLiveClass(lc);
              },
            ),
          ),
        );
      },
    );
  }
}
