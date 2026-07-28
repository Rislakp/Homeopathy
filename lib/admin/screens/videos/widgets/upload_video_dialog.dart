import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/models/video_model.dart';
import '../../../../services/video_service.dart';

class UploadVideoDialog extends StatefulWidget {
  final VideoModel? videoToEdit;
  final Function(VideoModel) onSave;

  const UploadVideoDialog({
    super.key,
    this.videoToEdit,
    required this.onSave,
  });

  @override
  State<UploadVideoDialog> createState() => _UploadVideoDialogState();
}

class _UploadVideoDialogState extends State<UploadVideoDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  
  String? _selectedCourse;
  bool _isDemo = false;
  
  String? _pickedVideoName;
  String? _pickedThumbnailName;
  
  final List<String> _courses = VideoService.mockCourses;

  @override
  void initState() {
    super.initState();
    final editVideo = widget.videoToEdit;
    
    _titleController = TextEditingController(text: editVideo?.title ?? '');
    _descriptionController = TextEditingController(text: editVideo?.description ?? '');
    _durationController = TextEditingController(text: editVideo?.duration ?? '');
    _selectedCourse = editVideo != null && _courses.contains(editVideo.course) 
        ? editVideo.course 
        : _courses.first;
    _isDemo = editVideo?.isDemo ?? false;
    _pickedVideoName = editVideo != null ? 'video_source_file.mp4' : null;
    _pickedThumbnailName = editVideo != null ? editVideo.thumbnail : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedVideoName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    }
  }

  Future<void> _pickThumbnail() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedThumbnailName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint('Error picking thumbnail: $e');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_pickedVideoName == null && widget.videoToEdit == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please pick a video file.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }
      if (_pickedThumbnailName == null && widget.videoToEdit == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please pick a thumbnail image.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }

      final video = VideoModel(
        id: widget.videoToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        course: _selectedCourse!,
        description: _descriptionController.text.trim(),
        duration: _durationController.text.trim(),
        thumbnail: _pickedThumbnailName ?? 'placeholder_thumbnail.png',
        videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
        isDemo: _isDemo,
        createdAt: widget.videoToEdit?.createdAt ?? DateTime.now(),
      );

      widget.onSave(video);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.videoToEdit != null;

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        width: 500,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Video Details' : 'Upload New Video',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 24),
              
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video Title
                      Text(
                        'Video Title',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter video title...',
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.03),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF16A34A), width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Course Dropdown
                      Text(
                        'Course / Category',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedCourse,
                        items: _courses.map((course) {
                          return DropdownMenuItem(
                            value: course,
                            child: Text(course),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedCourse = val;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.03),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF16A34A), width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a course';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'Description',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter video description...',
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.03),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF16A34A), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Duration & Pickers row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Duration (MM:SS)',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: const Color(0xFF374151),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _durationController,
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 14:20',
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(0.03),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color(0xFF16A34A), width: 2),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    final regex = RegExp(r'^\d+:\d{2}$');
                                    if (!regex.hasMatch(value)) {
                                      return 'Use MM:SS';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Video Settings',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: const Color(0xFF374151),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SwitchListTile(
                                  title: Text(
                                    'Demo Video',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  value: _isDemo,
                                  activeColor: const Color(0xFF16A34A),
                                  onChanged: (val) {
                                    setState(() {
                                      _isDemo = val;
                                    });
                                  },
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // File Pickers
                      Row(
                        children: [
                          // Video file picker
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _pickVideo,
                              icon: const Icon(Icons.video_call_rounded, color: Color(0xFF16A34A)),
                              label: Text(
                                _pickedVideoName != null ? 'Re-pick Video' : 'Pick Video File',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: const Color(0xFF16A34A),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF16A34A)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Thumbnail picker
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _pickThumbnail,
                              icon: const Icon(Icons.image_outlined, color: Color(0xFF16A34A)),
                              label: Text(
                                _pickedThumbnailName != null ? 'Re-pick Image' : 'Pick Thumbnail',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: const Color(0xFF16A34A),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF16A34A)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Picked file indicators
                      if (_pickedVideoName != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Video: $_pickedVideoName',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4B5563)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_pickedThumbnailName != null)
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Thumbnail: $_pickedThumbnailName',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4B5563)),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF4B5563),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Save Changes' : 'Upload Video',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
