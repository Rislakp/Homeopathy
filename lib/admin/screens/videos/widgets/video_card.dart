import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/models/video_model.dart';
import 'delete_video_dialog.dart';
import 'upload_video_dialog.dart';

class VideoCard extends StatefulWidget {
  final VideoModel video;
  final VoidCallback onView;
  final Function(VideoModel) onEdit;
  final VoidCallback onDelete;

  const VideoCard({
    super.key,
    required this.video,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        transform: Matrix4.identity()
          ..translate(_isHovered ? -2.0 : 0.0, _isHovered ? -2.0 : 0.0)
          ..scale(_isHovered ? 1.012 : 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isHovered ? const Color(0xFF16A34A).withOpacity(0.5) : const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
              blurRadius: _isHovered ? 16 : 12,
              offset: _isHovered ? const Offset(0, 6) : const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onView,
            borderRadius: BorderRadius.circular(18),
            splashColor: const Color(0xFF16A34A).withOpacity(0.05),
            highlightColor: const Color(0xFF16A34A).withOpacity(0.02),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 650;

                // 1. Thumbnail Widget
                final thumbnailWidget = Container(
                  width: 140,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7), // light green
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDCFCE7), Color(0xFFF0FDF4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Play icon centered
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Color(0xFF16A34A),
                            size: 26,
                          ),
                        ),
                      ),
                      // Duration badge bottom right
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.video.duration,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                // 2. Info Widget (Title & Course Name)
                final infoWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111827),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.bookmark_outline, size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          widget.video.course,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF4B5563),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                );

                // 3. Demo Badge Widget
                final demoBadge = widget.video.isDemo
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF86EFAC)),
                        ),
                        child: Text(
                          'DEMO',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF16A34A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const SizedBox.shrink();

                // 4. Action Buttons Widget
                final actionButtons = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // View Button
                    TextButton.icon(
                      onPressed: widget.onView,
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                      label: Text(
                        'View',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF16A34A),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Edit Button
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => UploadVideoDialog(
                            videoToEdit: widget.video,
                            onSave: widget.onEdit,
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit Video',
                      color: const Color(0xFF4B5563),
                      padding: const EdgeInsets.all(8),
                    ),
                    // Delete Button
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => DeleteVideoDialog(
                            videoTitle: widget.video.title,
                            onDelete: widget.onDelete,
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      tooltip: 'Delete Video',
                      color: const Color(0xFFEF4444),
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                );

                if (isMobile) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            thumbnailWidget,
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  infoWidget,
                                  if (widget.video.isDemo) ...[
                                    const SizedBox(height: 8),
                                    demoBadge,
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0xFFF3F4F6)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            actionButtons,
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        thumbnailWidget,
                        const SizedBox(width: 20),
                        Expanded(child: infoWidget),
                        const SizedBox(width: 12),
                        if (widget.video.isDemo) ...[
                          demoBadge,
                          const SizedBox(width: 16),
                        ],
                        actionButtons,
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
