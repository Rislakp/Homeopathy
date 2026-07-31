import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/courses/model/course_model.dart';
import 'package:homeopathy/admin/screens/courses/provider/course_provider.dart';


import 'package:provider/provider.dart';

import '../../../../utils/app_colors.dart';


class EditCourseDialog extends StatefulWidget {
  final CourseModel course;

  const EditCourseDialog({
    super.key,
    required this.course,
  });

  @override
  State<EditCourseDialog> createState() => _EditCourseDialogState();
}

class _EditCourseDialogState extends State<EditCourseDialog> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _instructor;
  late String _category;
  late double _price;
  late int _students;
  late String _status;
  late String _description;
  late String _image;

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

  final Map<String, IconData> _iconOptions = {
    'menu_book': Icons.menu_book,
    'auto_stories': Icons.auto_stories,
    'troubleshoot': Icons.troubleshoot,
    'history_edu': Icons.history_edu,
    'accessibility': Icons.accessibility,
    'favorite': Icons.favorite,
    'biotech': Icons.biotech,
    'groups': Icons.groups,
    'vaccines': Icons.vaccines,
    'local_hospital': Icons.local_hospital,
    'content_cut': Icons.content_cut,
    'gavel': Icons.gavel,
  };

  @override
  void initState() {
    super.initState();
    final c = widget.course;
    _title = c.title;
    _instructor = c.instructor;
    _category = c.category;
    _price = c.price;
    _students = c.students;
    _status = c.status;
    _description = c.description;
    _image = c.image;
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final provider = context.read<CourseProvider>();
    final updated = widget.course.copyWith(
      title: _title,
      instructor: _instructor,
      category: _category,
      price: _price,
      students: _students,
      status: _status,
      description: _description,
      image: _image,
    );

    provider.updateCourse(updated as CourseModel);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Course updated successfully!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    'Edit Course',
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
                        initialValue: _title,
                        decoration: const InputDecoration(labelText: 'Course Name', prefixIcon: Icon(Icons.book_outlined, size: 18)),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Course Name is required' : null,
                        onSaved: (v) => _title = v ?? '',
                      ),
                      const SizedBox(height: 16),
                      // Instructor
                      TextFormField(
                        initialValue: _instructor,
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
                      // Row of Price & Students
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _price.toStringAsFixed(0),
                              decoration: const InputDecoration(labelText: 'Price (₹)', prefixIcon: Icon(Icons.currency_rupee, size: 18)),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Price is required';
                                if (double.tryParse(v.trim()) == null) return 'Enter valid price';
                                return null;
                              },
                              onSaved: (v) => _price = double.parse(v!.trim()),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              initialValue: _students.toString(),
                              decoration: const InputDecoration(labelText: 'Student Count', prefixIcon: Icon(Icons.people_outline, size: 18)),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Student Count is required';
                                if (int.tryParse(v.trim()) == null) return 'Enter valid integer';
                                return null;
                              },
                              onSaved: (v) => _students = int.parse(v!.trim()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Dropdown of Illustration Icon
                      DropdownButtonFormField<String>(
                        value: _image,
                        decoration: const InputDecoration(labelText: 'Course Icon/Illustration'),
                        items: _iconOptions.keys.map((k) {
                          return DropdownMenuItem(
                            value: k,
                            child: Row(
                              children: [
                                Icon(_iconOptions[k], size: 18, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Text(k.replaceAll('_', ' ')),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _image = v);
                        },
                      ),
                      const SizedBox(height: 16),
                      // Description
                      TextFormField(
                        initialValue: _description,
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
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Save Changes'),
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
