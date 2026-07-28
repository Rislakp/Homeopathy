// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/student_model.dart';
// import '../providers/student_provider.dart';
// import '../utils/app_colors.dart';

// class StudentFormDialog extends StatefulWidget {
//   final StudentModel? student;

//   const StudentFormDialog({
//     super.key,
//     required this.student,
//   });

//   @override
//   State<StudentFormDialog> createState() => _StudentFormDialogState();
// }

// class _StudentFormDialogState extends State<StudentFormDialog> {
//   final _formKey = GlobalKey<FormState>();

//   late String _name;
//   late String _email;
//   late String _phone;
//   late String _course;
//   late String _subscription;
//   late String _status;

//   final List<String> _courses = [
//     'Materia Medica',
//     'Repertory',
//     'Organon',
//     'Physiology',
//     'Anatomy',
//     'Pathology',
//   ];

//   final List<String> _subscriptions = [
//     'Monthly',
//     'Quarterly',
//     'Yearly',
//   ];

//   final List<String> _statuses = [
//     'Active',
//     'Inactive',
//     'Trial',
//     'Expired',
//   ];

//   bool _isSaving = false;

//   @override
//   void initState() {
//     super.initState();
//     final s = widget.student;
//     _name = s?.name ?? '';
//     _email = s?.email ?? '';
//     _phone = s?.phone ?? '';
//     _course = s?.course ?? _courses[0];
//     _subscription = s?.subscription ?? _subscriptions[0];
//     _status = s?.status ?? _statuses[0];
//   }

//   Future<void> _onSave() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     setState(() => _isSaving = true);
//     final provider = context.read<StudentProvider>();

//     try {
//       if (widget.student == null) {
//         final newStudent = StudentModel(
//           id: '',
//           name: _name,
//           email: _email.trim(),
//           phone: _phone.trim(),
//           course: _course,
//           subscription: _subscription,
//           status: _status,
//           joinedDate: DateTime.now(),
//         );
//         await provider.addStudent(newStudent);
//       } else {
//         final updated = widget.student!.copyWith(
//           name: _name,
//           email: _email.trim(),
//           phone: _phone.trim(),
//           course: _course,
//           subscription: _subscription,
//           status: _status,
//         );
//         await provider.updateStudent(updated);
//       }

//       if (mounted) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               widget.student == null
//                   ? 'Successfully registered new student!'
//                   : 'Successfully updated student profile!',
//             ),
//             backgroundColor: AppColors.primary,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint('Error saving student: $e');
//     } finally {
//       if (mounted) {
//         setState(() => _isSaving = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<StudentProvider>();
//     final isNew = widget.student == null;

//     Widget buildTextField({
//       required String initialValue,
//       required String label,
//       required IconData icon,
//       required FormFieldSetter<String> onSaved,
//       required FormFieldValidator<String> validator,
//     }) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label.toUpperCase(),
//               style: const TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 6),
//             TextFormField(
//               initialValue: initialValue,
//               decoration: InputDecoration(
//                 prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.border),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.border),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.expiredText),
//                 ),
//               ),
//               style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
//               onSaved: onSaved,
//               validator: validator,
//             ),
//           ],
//         ),
//       );
//     }

//     Widget buildDropdown({
//       required String value,
//       required String label,
//       required List<String> items,
//       required ValueChanged<String?> onChanged,
//     }) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label.toUpperCase(),
//               style: const TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 border: Border.all(color: AppColors.border),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   value: value,
//                   items: items.map((String item) {
//                     return DropdownMenuItem<String>(
//                       value: item,
//                       child: Text(
//                         item,
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: onChanged,
//                   icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 480,
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     isNew ? 'Add Student' : 'Edit Student',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
//                     icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
//                   ),
//                 ],
//               ),
//               const Divider(height: 24, color: AppColors.border),
//               Flexible(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       buildTextField(
//                         initialValue: _name,
//                         label: 'Name',
//                         icon: Icons.person_outline,
//                         onSaved: (val) => _name = val ?? '',
//                         validator: (val) {
//                           if (val == null || val.trim().isEmpty) {
//                             return 'Name is required';
//                           }
//                           return null;
//                         },
//                       ),
//                       buildTextField(
//                         initialValue: _email,
//                         label: 'Email',
//                         icon: Icons.email_outlined,
//                         onSaved: (val) => _email = val ?? '',
//                         validator: (val) {
//                           if (val == null || val.trim().isEmpty) {
//                             return 'Email is required';
//                           }
//                           final regex = RegExp(
//                             r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//                           );
//                           if (!regex.hasMatch(val.trim())) {
//                             return 'Enter a valid email address';
//                           }
//                           final isDuplicate = provider.students.any((s) =>
//                               s.id != widget.student?.id &&
//                               s.email.toLowerCase() == val.trim().toLowerCase());
//                           if (isDuplicate) {
//                             return 'Duplicate email not allowed';
//                           }
//                           return null;
//                         },
//                       ),
//                       buildTextField(
//                         initialValue: _phone,
//                         label: 'Phone',
//                         icon: Icons.phone_outlined,
//                         onSaved: (val) => _phone = val ?? '',
//                         validator: (val) {
//                           if (val == null || val.trim().isEmpty) {
//                             return 'Phone is required';
//                           }
//                           final regex = RegExp(r'^\+?[0-9\s\-()]{7,18}$');
//                           if (!regex.hasMatch(val.trim())) {
//                             return 'Enter a valid phone number';
//                           }
//                           final isDuplicate = provider.students.any((s) =>
//                               s.id != widget.student?.id &&
//                               s.phone.replaceAll(RegExp(r'\s+'), '') ==
//                                   val.replaceAll(RegExp(r'\s+'), ''));
//                           if (isDuplicate) {
//                             return 'Duplicate phone not allowed';
//                           }
//                           return null;
//                         },
//                       ),
//                       buildDropdown(
//                         value: _course,
//                         label: 'Course',
//                         items: _courses,
//                         onChanged: (val) {
//                           if (val != null) setState(() => _course = val);
//                         },
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: buildDropdown(
//                               value: _subscription,
//                               label: 'Subscription',
//                               items: _subscriptions,
//                               onChanged: (val) {
//                                 if (val != null) setState(() => _subscription = val);
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: buildDropdown(
//                               value: _status,
//                               label: 'Status',
//                               items: _statuses,
//                               onChanged: (val) {
//                                 if (val != null) setState(() => _status = val);
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const Divider(height: 24, color: AppColors.border),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   OutlinedButton(
//                     onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: AppColors.border),
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                     child: const Text(
//                       'Cancel Button',
//                       style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   ElevatedButton(
//                     onPressed: _isSaving ? null : _onSave,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       elevation: 0,
//                     ),
//                     child: _isSaving
//                         ? const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                         : const Text('Save Button', style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
