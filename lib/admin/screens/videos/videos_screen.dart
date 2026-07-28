import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/models/video_model.dart';
import 'package:homeopathy/admin/providers/video_provider.dart';
import 'package:homeopathy/admin/screens/videos/widgets/empty_video.dart';
import 'package:homeopathy/admin/screens/videos/widgets/loading_widget.dart';
import 'package:homeopathy/admin/screens/videos/widgets/video_search_filter.dart';
import 'package:provider/provider.dart';

import 'widgets/video_card.dart';


class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  @override
  void initState() {
    super.initState();
    // Load videos on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoProvider>().loadVideos();
    });
  }

  void _showViewVideoDialog(BuildContext context, VideoModel video) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            width: 700,
            height: 500,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        video.title,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Mock Video Player Interface
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Play Icon
                        const Icon(
                          Icons.play_circle_fill_rounded,
                          color: Color(0xFF16A34A),
                          size: 72,
                        ),
                        // Mock duration / slider bar bottom
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3,
                                  thumbColor: const Color(0xFF16A34A),
                                  activeTrackColor: const Color(0xFF16A34A),
                                  inactiveTrackColor: Colors.white24,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                ),
                                child: Slider(
                                  value: 0.35,
                                  onChanged: (val) {},
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '02:15',
                                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                                  ),
                                  Text(
                                    video.duration,
                                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF16A34A)),
                      ),
                      child: Text(
                        video.course,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF86EFAC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        video.description.isNotEmpty 
                            ? video.description 
                            : 'No video description provided.',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = context.watch<VideoProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // custom slate bg
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header Area
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Videos Management',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Upload, view, and organize video lectures for your curriculum.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Top filter controls
              const VideoSearchFilter(),
              const SizedBox(height: 24),

              // Scrollable body state manager
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: _buildBodyState(videoProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyState(VideoProvider provider) {
    if (provider.isLoading) {
      return const LoadingWidget(
        key: ValueKey('loading'),
        message: 'Loading your homeopathic video lectures...',
      );
    }

    if (provider.videos.isEmpty) {
      return const EmptyVideoWidget(
        key: ValueKey('empty'),
      );
    }

    return ListView.builder(
      key: const ValueKey('list'),
      itemCount: provider.videos.length,
      padding: const EdgeInsets.only(bottom: 24),
      itemBuilder: (context, index) {
        final video = provider.videos[index];
        return VideoCard(
          video: video,
          onView: () => _showViewVideoDialog(context, video),
          onEdit: (updated) {
            provider.updateVideo(updated);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Video "${updated.title}" updated successfully!'),
                backgroundColor: const Color(0xFF16A34A),
              ),
            );
          },
          onDelete: () {
            provider.deleteVideo(video.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Video "${video.title}" deleted.'),
                backgroundColor: const Color(0xFFEF4444),
                action: SnackBarAction(
                  label: 'Undo',
                  textColor: Colors.white,
                  onPressed: () {
                    provider.uploadVideo(video);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
