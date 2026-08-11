import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../models/course_management_model.dart';
import '../../../providers/course_management_provider.dart';

class EditCourseScreen extends StatefulWidget {
  final CourseItem courseId;

  const EditCourseScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _category;
  late String _instructor;
  late String _duration;
  late String _price;
  late int _students;
  late double _rating;
  late String _status;
  late String _language;

  bool _isSaving = false;

  final List<String> _categories = [
    'Anatomy',
    'Physiology',
    'Pathology',
    'Materia Medica',
    'Repertory',
    'Organon',
    'Pharmacy',
    'Clinical',
  ];

  final List<String> _statuses = ['Published', 'Draft'];
  final List<String> _languages = ['English', 'Hindi', 'Bilingual'];

  @override
  void initState() {
    super.initState();
    final c = widget.courseId;
    _name = c.name;
    _category = c.category;
    _instructor = c.instructor;
    _duration = c.duration;
    _price = c.price.replaceAll(RegExp(r'[^0-9.]'), ''); // Strip currency symbol for user input
    _students = c.students;
    _rating = c.rating;
    _status = c.status;
    _language = c.language;
  }

  void _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isSaving = true;
    });

    try {
      final notifier = context.read<CourseManagementNotifier>();
      final updated = CourseItem(
        id: widget.courseId.id,
        name: _name,
        category: _category,
        instructor: _instructor,
        duration: _duration,
        price: '₹$_price',
        students: _students,
        rating: _rating,
        status: _status,
        language: _language,
        thumbnailIcon: widget.courseId.thumbnailIcon,
        thumbnailBgColor: widget.courseId.thumbnailBgColor,
      );

      await notifier.updateCourse(updated);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Course updated successfully!'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update course: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Edit Course Detail', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: 600,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Update Academic Course Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 20),
                  // Course Name
                  TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(labelText: 'Course Name', prefixIcon: Icon(Icons.book_outlined, size: 18)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Course Name is required' : null,
                    onSaved: (v) => _name = v ?? '',
                  ),
                  const SizedBox(height: 16),
                  // Instructor
                  TextFormField(
                    initialValue: _instructor,
                    decoration: const InputDecoration(labelText: 'Instructor Name', prefixIcon: Icon(Icons.person_outline, size: 18)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Instructor is required' : null,
                    onSaved: (v) => _instructor = v ?? '',
                  ),
                  const SizedBox(height: 16),
                  // Row Category & Status
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _categories.contains(_category) ? _category : 'Materia Medica',
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
                  // Row price, duration & language
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _price,
                          decoration: const InputDecoration(labelText: 'Price (₹)', prefixIcon: Icon(Icons.currency_rupee, size: 18)),
                          keyboardType: TextInputType.number,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Price is required' : null,
                          onSaved: (v) => _price = v ?? '',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: _duration,
                          decoration: const InputDecoration(labelText: 'Duration', prefixIcon: Icon(Icons.timer_outlined, size: 18)),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Duration is required' : null,
                          onSaved: (v) => _duration = v ?? '',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _students.toString(),
                          decoration: const InputDecoration(labelText: 'Students Enrolled', prefixIcon: Icon(Icons.people_outline, size: 18)),
                          keyboardType: TextInputType.number,
                          validator: (v) => v == null || int.tryParse(v) == null ? 'Enter valid student count' : null,
                          onSaved: (v) => _students = int.parse(v!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _language,
                          decoration: const InputDecoration(labelText: 'Language'),
                          items: _languages.map((l) {
                            return DropdownMenuItem(value: l, child: Text(l));
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _language = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save Changes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
