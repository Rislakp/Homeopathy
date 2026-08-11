import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/course_management_model.dart';
import '../../../providers/course_management_provider.dart';
import 'lesson_list_tile.dart';

class CourseContentSection extends StatefulWidget {
  final CourseDetailModel course;

  const CourseContentSection({
    super.key,
    required this.course,
  });

  @override
  State<CourseContentSection> createState() => _CourseContentSectionState();
}

class _CourseContentSectionState extends State<CourseContentSection> {
  final Map<String, bool> _expandedModules = {};

  @override
  void initState() {
    super.initState();
    if (widget.course.modules.isNotEmpty) {
      _expandedModules[widget.course.modules.first.id] = true;
    }
  }

  void _showAddLessonDialog(BuildContext context) {
    final provider = context.read<CourseManagementNotifier>();
    final modules = widget.course.modules;

    if (modules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No modules available. Please create a module first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final formKey = GlobalKey<FormState>();
    String selectedModuleId = modules.first.id;
    String title = '';
    LessonType type = LessonType.video;
    String subtitle = '';
    String status = 'Published';
    bool isLocked = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Add New Lesson',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SizedBox(
            width: 450,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedModuleId,
                      decoration: const InputDecoration(labelText: 'Select Module'),
                      items: modules.map((m) {
                        return DropdownMenuItem(
                          value: m.id,
                          child: Text(
                            m.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) selectedModuleId = v;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Lesson Name',
                        prefixIcon: Icon(Icons.book_outlined, size: 18),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Lesson Name is required' : null,
                      onSaved: (v) => title = v ?? '',
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<LessonType>(
                      value: type,
                      decoration: const InputDecoration(labelText: 'Lesson Type'),
                      items: const [
                        DropdownMenuItem(value: LessonType.video, child: Text('Video Lesson')),
                        DropdownMenuItem(value: LessonType.live, child: Text('Live Session')),
                        DropdownMenuItem(value: LessonType.file, child: Text('File Document')),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() {
                            type = v;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: type == LessonType.file
                            ? 'File Size (e.g. 2.4 MB)'
                            : type == LessonType.live
                                ? 'Date/Time (e.g. Aug 30, 3:00 PM)'
                                : 'Video Duration (e.g. 15 mins)',
                        prefixIcon: const Icon(Icons.info_outline, size: 18),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Field is required' : null,
                      onSaved: (v) => subtitle = v ?? '',
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: const [
                        DropdownMenuItem(value: 'Published', child: Text('Published')),
                        DropdownMenuItem(value: 'Draft', child: Text('Draft')),
                      ],
                      onChanged: (v) {
                        if (v != null) status = v;
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Require Enrollment Lock', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Students must buy course to unlock this lesson', style: TextStyle(fontSize: 11)),
                      value: isLocked,
                      activeColor: Colors.teal,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (v) {
                        setDialogState(() {
                          isLocked = v;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                formKey.currentState!.save();

                String finalSubtitle = subtitle;
                if (type == LessonType.file && !subtitle.toLowerCase().contains('document')) {
                  finalSubtitle = 'PDF Document • $subtitle';
                } else if (type == LessonType.live && !subtitle.toLowerCase().contains('live')) {
                  finalSubtitle = 'Live Session • $subtitle';
                } else if (type == LessonType.video && !subtitle.toLowerCase().contains('video')) {
                  finalSubtitle = 'Recorded Video • $subtitle';
                }

                final newLesson = LessonDetailModel(
                  id: 'LES-${DateTime.now().millisecondsSinceEpoch}',
                  title: title,
                  subtitle: finalSubtitle,
                  type: type,
                  status: status,
                  isLocked: isLocked,
                );

                provider.addLesson(selectedModuleId, newLesson);
                Navigator.pop(ctx);

                setState(() {
                  _expandedModules[selectedModuleId] = true;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lesson added successfully!'),
                    backgroundColor: Colors.teal,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Lesson'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Course Content',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.course.modules.length} Modules • ${widget.course.modules.fold<int>(0, (sum, m) => sum + m.lessons.length)} Lessons total',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddLessonDialog(context),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Lesson'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (widget.course.modules.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: const Center(
                child: Text(
                  'No content modules found. Add a lesson to get started.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.course.modules.length,
              itemBuilder: (context, index) {
                final module = widget.course.modules[index];
                final isExpanded = _expandedModules[module.id] ?? false;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _expandedModules[module.id] = !isExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Row(
                            children: [
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded,
                                color: const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  module.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.teal.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${module.lessons.length} Lessons',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                          child: module.lessons.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: Text(
                                      'No lessons in this module yet.',
                                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: module.lessons.length,
                                  itemBuilder: (context, lIndex) {
                                    return LessonListTile(
                                      moduleId: module.id,
                                      lesson: module.lessons[lIndex],
                                    );
                                  },
                                ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
