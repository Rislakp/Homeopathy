import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student_model.dart';
import '../providers/student_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_textstyles.dart';

class EditStudentDialog extends StatefulWidget {
  final StudentModel? student;

  const EditStudentDialog({
    super.key,
    required this.student,
  });

  @override
  State<EditStudentDialog> createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<EditStudentDialog> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _phone;
  late String _course;
  late String _subscription;
  late String _status;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _name = s?.name ?? '';
    _email = s?.email ?? '';
    _phone = s?.phone ?? '';
    _course = s?.course ?? AppConstants.courses[0];
    _subscription = s?.subscription ?? AppConstants.subscriptions[0];
    _status = s?.status ?? AppConstants.statuses[0];
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSaving = true);
    final provider = context.read<StudentProvider>();

    try {
      if (widget.student == null) {
        // Create new
        final newStudent = StudentModel(
          id: '',
          name: _name,
          email: _email,
          phone: _phone,
          course: _course,
          subscription: _subscription,
          status: _status,
          joinedDate: DateTime.now(),
        );
        await provider.addStudent(newStudent);
      } else {
        // Edit existing
        final updated = widget.student!.copyWith(
          name: _name,
          email: _email,
          phone: _phone,
          course: _course,
          subscription: _subscription,
          status: _status,
        );
        await provider.updateStudent(updated);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.student == null
                  ? 'Successfully registered new student!'
                  : 'Successfully updated student details!',
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error Saving Student'),
            content: Text(e.toString().replaceAll('Exception: ', '')),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    final isNew = widget.student == null;

    Widget buildTextField({
      required String initialValue,
      required String label,
      required IconData prefixIcon,
      required FormFieldSetter<String> onSaved,
      required FormFieldValidator<String> validator,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.inputLabel),
            const SizedBox(height: 6),
            TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(
                prefixIcon: Icon(prefixIcon, size: 18, color: AppColors.textSecondary),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.archivedText),
                ),
              ),
              style: AppTextStyles.tableCellBold,
              onSaved: onSaved,
              validator: validator,
            ),
          ],
        ),
      );
    }

    Widget buildDropdownField({
      required String value,
      required String label,
      required List<String> items,
      required ValueChanged<String?> onChanged,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.inputLabel),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: value,
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: AppTextStyles.tableCellBold),
                    );
                  }).toList(),
                  onChanged: onChanged,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 24,
      backgroundColor: Colors.white,
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isNew ? 'Register New Student' : 'Edit Student Profile',
                    style: AppTextStyles.dialogTitle,
                  ),
                  IconButton(
                    onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const Divider(height: 24, color: AppColors.border),

              // Inputs list inside SingleChildScrollView for safety
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Name Input
                      buildTextField(
                        initialValue: _name,
                        label: 'FULL NAME',
                        prefixIcon: Icons.person_outline,
                        onSaved: (val) => _name = val ?? '',
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),

                      // Email Input
                      buildTextField(
                        initialValue: _email,
                        label: 'EMAIL ADDRESS',
                        prefixIcon: Icons.email_outlined,
                        onSaved: (val) => _email = val ?? '',
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegExp = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegExp.hasMatch(val.trim())) {
                            return 'Enter a valid email address';
                          }
                          // Duplicate check in Provider state
                          final isDuplicate = provider.students.any((s) =>
                              s.id != widget.student?.id &&
                              s.email.toLowerCase() == val.trim().toLowerCase());
                          if (isDuplicate) {
                            return 'This email address is already in use';
                          }
                          return null;
                        },
                      ),

                      // Phone Input
                      buildTextField(
                        initialValue: _phone,
                        label: 'PHONE NUMBER',
                        prefixIcon: Icons.phone_outlined,
                        onSaved: (val) => _phone = val ?? '',
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          // Basic phone validation (digits, optional +, space, parenthesis)
                          final phoneRegExp = RegExp(r'^\+?[0-9\s\-()]{7,18}$');
                          if (!phoneRegExp.hasMatch(val.trim())) {
                            return 'Enter a valid phone number';
                          }
                          // Duplicate check
                          final isDuplicate = provider.students.any((s) =>
                              s.id != widget.student?.id &&
                              s.phone.replaceAll(RegExp(r'\s+'), '') ==
                                  val.replaceAll(RegExp(r'\s+'), ''));
                          if (isDuplicate) {
                            return 'This phone number is already in use';
                          }
                          return null;
                        },
                      ),

                      // Course Dropdown
                      buildDropdownField(
                        value: _course,
                        label: 'COURSE ENROLLMENT',
                        items: AppConstants.courses,
                        onChanged: (val) {
                          if (val != null) setState(() => _course = val);
                        },
                      ),

                      // Row of Subscription & Status
                      Row(
                        children: [
                          Expanded(
                            child: buildDropdownField(
                              value: _subscription,
                              label: 'SUBSCRIPTION PLAN',
                              items: AppConstants.subscriptions,
                              onChanged: (val) {
                                if (val != null) setState(() => _subscription = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: buildDropdownField(
                              value: _status,
                              label: 'STATUS',
                              items: AppConstants.statuses,
                              onChanged: (val) {
                                if (val != null) setState(() => _status = val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(height: 24, color: AppColors.border),

              // Bottom Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.tableCellBold.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(isNew ? 'Register' : 'Save Changes'),
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
