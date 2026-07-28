import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/providers/video_provider.dart';
import 'package:provider/provider.dart';
import 'upload_video_dialog.dart';

class VideoSearchFilter extends StatelessWidget {
  const VideoSearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final videoProvider = context.watch<VideoProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;
        
        final searchField = TextField(
          onChanged: (val) => videoProvider.searchVideos(val),
          decoration: InputDecoration(
            hintText: 'Search videos by title or course...',
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

        final courseDropdown = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: videoProvider.selectedCourse,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF4B5563)),
              onChanged: (val) {
                if (val != null) {
                  videoProvider.filterByCourse(val);
                }
              },
              items: videoProvider.courses.map((course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(
                    course,
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

        final uploadButton = MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => UploadVideoDialog(
                  onSave: (newVideo) {
                    videoProvider.uploadVideo(newVideo);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Video uploaded successfully!'),
                        backgroundColor: Color(0xFF16A34A),
                      ),
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.add, size: 20),
            label: Text(
              'Upload Video',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
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
                  Expanded(child: courseDropdown),
                  const SizedBox(width: 12),
                  uploadButton,
                ],
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(flex: 3, child: searchField),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: courseDropdown),
              const SizedBox(width: 16),
              uploadButton,
            ],
          );
        }
      },
    );
  }
}
