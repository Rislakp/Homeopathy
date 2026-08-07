import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/courses/model/course_model.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../utils/app_colors.dart';
import '../models/course_model.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _instructor = '';
  String _category = 'Materia Medica';
  double _price = 0.0;
  String _status = 'Published';
  String _description = '';
  String _image = 'menu_book'; // Default Icon code

  final List<String> _categories = [
    'Anatomy',
    'Physiology',
    'Pathology',
    'Materia Medica',
    'Repertory',
    'Organon',
  ];

  final List<String> _statuses = [
    'Published',
    'Draft',
    'Archived',
  ];


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Course',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const Divider(height: 24, color: AppColors.border),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Title
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Course Name', prefixIcon: Icon(Icons.book_outlined, size: 18)),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Course Name is required' : null,
                        onSaved: (v) => _title = v ?? '',
                      ),
                      const SizedBox(height: 16),
                      // Instructor
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Instructor Name', prefixIcon: Icon(Icons.person_outline, size: 18)),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Instructor Name is required' : null,
                        onSaved: (v) => _instructor = v ?? '',
                      ),
                      const SizedBox(height: 16),
                      // Row of Category & Status
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _category,
                              decoration: const InputDecoration(labelText: 'Category'),
                              items: _categories.map((c) {
                                return DropdownMenuItem(value: c, child: Text(c));
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => _category = v);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _status,
                              decoration: const InputDecoration(labelText: 'Status'),
                              items: _statuses.map((s) {
                                return DropdownMenuItem(value: s, child: Text(s));
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => _status = v);
                              },
                            ),
                          ),
                        ],
                      ),
                     const SizedBox(height: 16),
                   
                     
                      const SizedBox(height: 16),
                      // Description
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
                        maxLines: 3,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Description is required' : null,
                        onSaved: (v) => _description = v ?? '',
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 24, color: AppColors.border),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: provider.isCreating ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: provider.isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _onSave() async {
  if (!_formKey.currentState!.validate()) return;

  _formKey.currentState!.save();

  final provider = context.read<CourseProvider>();

  debugPrint('Creating course: $_title');

  final course = CourseModel(
    id: '',
    courseId: '',
    title: _title,
    instructor: _instructor,
    category: _category,
    price: _price,
     description: '',
  );

  final success = await provider.addCourse(course);

  if (!mounted) return;

  if (success) {
    await provider.fetchCourses();

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Course created successfully'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          provider.errorMessage ?? 'Failed to create course',
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
}