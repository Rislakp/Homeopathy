import 'dart:math';
import 'package:flutter/material.dart';
import 'package:homeopathy/admin/theme/admin_colors.dart';
import 'package:provider/provider.dart';
import '../model/student_model.dart';
import '../provider/student_provider.dart';

class AddEditStudentDialog extends StatefulWidget {
  final StudentModel? student;

  const AddEditStudentDialog({super.key, this.student});

  @override
  State<AddEditStudentDialog> createState() => _AddEditStudentDialogState();
}

class _AddEditStudentDialogState extends State<AddEditStudentDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _passwordController;

  String _selectedQualification = 'BHMS';
  String _selectedCourse = 'Classical Homeopathy';
  String _selectedSubscription = 'Monthly';
  String _selectedStatus = 'Active';

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _apiError; // inline error banner text

  // ── Static list data ─────────────────────────────────────────────────────
  final List<String> _qualifications = [
    'BHMS',
    'MD (Hom)',
    'PhD (Hom)',
    'DHMS',
    'Other',
  ];

  final List<String> _courses = [
    'Classical Homeopathy',
    'Materia Medica',
    'Repertory',
    'Organon',
    'Pharmacy',
    'Anatomy',
    'Physiology',
    'Pathology',
  ];

  final List<String> _subscriptions = [
    'Monthly',
    'Quarterly',
    'Half Yearly',
    'Yearly',
    'Trial',
  ];

  final List<String> _statuses = ['Active', 'Trial', 'Expired', 'Inactive'];

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    final student = widget.student;

    _nameController = TextEditingController(text: student?.name ?? '');
    _emailController = TextEditingController(text: student?.email ?? '');
    _phoneController = TextEditingController(text: student?.phone ?? '');
    _dobController = TextEditingController(
        text: student?.dateOfBirth ?? '');

    // For "Add" mode, pre-fill a secure temporary password the admin can change.
    _passwordController = TextEditingController(
      text: student == null ? _generateTempPassword() : '',
    );

    if (student != null) {
      if (_courses.contains(student.course)) {
        _selectedCourse = student.course;
      }
      if (_subscriptions.contains(student.subscription)) {
        _selectedSubscription = student.subscription;
      }
      if (_statuses.contains(student.status)) {
        _selectedStatus = student.status;
      }
      final qual = student.qualification;
      if (qual != null && _qualifications.contains(qual)) {
        _selectedQualification = qual;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Generates a secure 12-character temporary password:
  /// uppercase + lowercase + digits + special chars.
  String _generateTempPassword() {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789!@#\$%';
    final rng = Random.secure();
    return List.generate(12, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  /// Formats a [DateTime] to the API's expected `dd/MM/yyyy` format.
  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  /// Parses a `dd/MM/yyyy` string back to a [DateTime] for the date picker.
  DateTime? _parseDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;
    return DateTime.tryParse('${parts[2]}-${parts[1]}-${parts[0]}');
  }

  // ── Date picker ───────────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final initial = _parseDate(_dobController.text) ??
        DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      helpText: 'Select Date of Birth',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.adminBlue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _dobController.text = _formatDate(picked);
    }
  }

  // ── Save (Add mode → API) / Update (Edit mode → local) ───────────────────
  Future<void> _save() async {
    // Clear any previous API error and validate the form.
    setState(() => _apiError = null);
    if (!_formKey.currentState!.validate()) return;

    final isEdit = widget.student != null;

    if (isEdit) {
      // ── Edit mode: local update (unchanged behaviour) ──────────────────
      final name = _nameController.text.trim();
      final words = name.split(' ');
      String avatar = '';
      if (words.isNotEmpty) {
        avatar += words[0][0].toUpperCase();
        if (words.length > 1 && words[1].isNotEmpty) {
          avatar += words[1][0].toUpperCase();
        }
      }
      if (avatar.isEmpty) avatar = 'ST';

      final updatedStudent = StudentModel(
        id: widget.student!.id,
        name: name,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        course: _selectedCourse,
        subscription: _selectedSubscription,
        status: _selectedStatus,
        avatarText: avatar,
        qualification: _selectedQualification,
        dateOfBirth: _dobController.text.trim().isEmpty
            ? null
            : _dobController.text.trim(),
      );

      if (mounted) Navigator.of(context).pop(updatedStudent);
      return;
    }

    // ── Add mode: call the real API ────────────────────────────────────────
    setState(() => _isLoading = true);

    try {
      final provider = context.read<StudentProvider>();
      final newStudent = await provider.registerStudentViaApi(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        dateOfBirth: _dobController.text.trim(),
        contactNumber: _phoneController.text.trim(),
        qualification: _selectedQualification,
      );

      // Pop with the new student so student_body.dart can show the snackbar.
      if (mounted) Navigator.of(context).pop(newStudent);
    } catch (e) {
      // Surface the error inline (no pop — the admin stays in the dialog).
      final raw = e.toString().replaceAll('Exception: ', '');
      setState(() {
        _apiError = raw;
        _isLoading = false;
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 580),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit ? 'Edit Student Details' : 'Add New Student',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isEdit
                      ? 'Update the student profile and configuration details.'
                      : 'Fill in the information below to enroll a new student.',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 20),

                // ── Inline API error banner ───────────────────────────────
                if (_apiError != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFFFCA5A5), width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: Color(0xFFEF4444), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _apiError!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFB91C1C),
                              height: 1.4,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _apiError = null),
                          child: const Icon(Icons.close,
                              color: Color(0xFFEF4444), size: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Full Name ─────────────────────────────────────────────
                _fieldLabel('Full Name'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  decoration:
                      _inputDecoration('Enter full name', Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── Email + Phone ─────────────────────────────────────────
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 450;
                    if (isMobile) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEmailField(),
                          const SizedBox(height: 16),
                          _buildPhoneField(),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildEmailField()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildPhoneField()),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // ── Date of Birth + Qualification ─────────────────────────
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 450;
                    if (isMobile) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDobField(),
                          const SizedBox(height: 16),
                          _buildQualificationDropdown(),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDobField()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildQualificationDropdown()),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // ── Temporary Password (Add mode only) ─────────────────────
                if (!isEdit) ...[
                  _fieldLabel('Temporary Password'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    enabled: !_isLoading,
                    decoration: _inputDecoration(
                      'Auto-generated or enter custom',
                      Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF9CA3AF),
                              size: 18,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            tooltip: _obscurePassword
                                ? 'Show password'
                                : 'Hide password',
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded,
                                color: Color(0xFF9CA3AF), size: 18),
                            onPressed: () => setState(() {
                              _passwordController.text =
                                  _generateTempPassword();
                            }),
                            tooltip: 'Regenerate password',
                          ),
                        ],
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'A secure temporary password has been auto-generated. '
                    'The student should change it after first login.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Course ────────────────────────────────────────────────
                _fieldLabel('Course'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedCourse,
                  decoration: _inputDecoration(
                      'Select course', Icons.school_outlined),
                  items: _courses.map((course) {
                    return DropdownMenuItem<String>(
                        value: course, child: Text(course));
                  }).toList(),
                  onChanged: _isLoading
                      ? null
                      : (val) {
                          if (val != null) {
                            setState(() => _selectedCourse = val);
                          }
                        },
                ),
                const SizedBox(height: 16),

                // ── Subscription + Status ─────────────────────────────────
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 450;
                    if (isMobile) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSubscriptionDropdown(),
                          const SizedBox(height: 16),
                          _buildStatusDropdown(),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildSubscriptionDropdown()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatusDropdown()),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 28),

                // ── Action Buttons ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        disabledBackgroundColor:
                            const Color.fromARGB(255, 47, 16, 185).withOpacity(0.6),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : Text(
                              isEdit ? 'Update Student' : 'Save Student',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Reusable field builders ───────────────────────────────────────────────

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Email Address'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: !_isLoading,
          decoration:
              _inputDecoration('email@example.com', Icons.mail_outline),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter an email';
            }
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRegex.hasMatch(value.trim())) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Phone Number'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          enabled: !_isLoading,
          decoration: _inputDecoration('9876543210', Icons.phone_outlined),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDobField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Date of Birth'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _dobController,
          readOnly: true,
          enabled: !_isLoading,
          onTap: _pickDate,
          decoration: _inputDecoration(
            'dd/mm/yyyy',
            Icons.cake_outlined,
          ).copyWith(
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF9CA3AF),
              size: 18,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please select date of birth';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildQualificationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Qualification'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedQualification,
          decoration: _inputDecoration(
              'Select qualification', Icons.school_outlined),
          items: _qualifications.map((q) {
            return DropdownMenuItem<String>(value: q, child: Text(q));
          }).toList(),
          onChanged: _isLoading
              ? null
              : (val) {
                  if (val != null) {
                    setState(() => _selectedQualification = val);
                  }
                },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a qualification';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubscriptionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Subscription'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedSubscription,
          decoration: _inputDecoration(
              'Select type', Icons.card_membership_outlined),
          items: _subscriptions.map((sub) {
            return DropdownMenuItem<String>(value: sub, child: Text(sub));
          }).toList(),
          onChanged: _isLoading
              ? null
              : (val) {
                  if (val != null) {
                    setState(() => _selectedSubscription = val);
                  }
                },
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Status'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          decoration: _inputDecoration(
              'Select status', Icons.toggle_on_outlined),
          items: _statuses.map((status) {
            return DropdownMenuItem<String>(value: status, child: Text(status));
          }).toList(),
          onChanged: _isLoading
              ? null
              : (val) {
                  if (val != null) setState(() => _selectedStatus = val);
                },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 18),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color.fromARGB(255, 16, 33, 185), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            BorderSide(color: const Color(0xFFE5E7EB).withOpacity(0.5)),
      ),
    );
  }
}
