// import 'package:flutter/material.dart';
// import 'package:homeopathy/admin/screens/courses/model/course_model.dart';
// import 'package:homeopathy/admin/screens/courses/provider/course_provider.dart';
// import 'package:provider/provider.dart';
// import '../providers/course_provider.dart';
// import '../utils/app_colors.dart';
// import '../models/course_model.dart';

// class AddCourseDialog extends StatefulWidget {
//   const AddCourseDialog({super.key});

//   @override
//   State<AddCourseDialog> createState() => _AddCourseDialogState();
// }

// class _AddCourseDialogState extends State<AddCourseDialog> {
//   final _formKey = GlobalKey<FormState>();

//   String _title = '';
//   String _instructor = '';
//   String _category = 'Anatomy';
//   double _price = 0.0;
//   String _description = 'Homeopathy foundational and advanced modules.';
//   String _image = 'menu_book';

//   final List<String> _categories = [
//     'Anatomy',
//     'Physiology',
//     'Pathology',
//     'Materia Medica',
//     'Repertory',
//     'Organon',
//   ];

//   final List<String> _statuses = [
//     'Published',
//     'Draft',
//     'Archived',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 500,
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
//                   const Text(
//                     'Add New Course',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
//                   ),
//                   IconButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
//                   ),
//                 ],
//               ),
//               const Divider(height: 24, color: AppColors.border),
//               Flexible(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         decoration: const InputDecoration(labelText: 'Course Name', prefixIcon: Icon(Icons.book_outlined, size: 18)),
//                         validator: (v) => v == null || v.trim().isEmpty ? 'Course Name is required' : null,
//                         onSaved: (v) => _title = v ?? '',
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: const InputDecoration(labelText: 'Instructor Name', prefixIcon: Icon(Icons.person_outline, size: 18)),
//                         validator: (v) => v == null || v.trim().isEmpty ? 'Instructor Name is required' : null,
//                         onSaved: (v) => _instructor = v ?? '',
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: DropdownButtonFormField<String>(
//                               value: _category,
//                               decoration: const InputDecoration(labelText: 'Category'),
//                               items: _categories.map((c) {
//                                 return DropdownMenuItem(value: c, child: Text(c));
//                               }).toList(),
//                               onChanged: (v) {
//                                 if (v != null) setState(() => _category = v);
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: const InputDecoration(labelText: 'Price (₹)', prefixIcon: Icon(Icons.currency_rupee, size: 18)),
//                         keyboardType: TextInputType.number,
//                         validator: (v) {
//                           if (v == null || v.trim().isEmpty) return 'Price is required';
//                           if (double.tryParse(v.trim()) == null) return 'Enter valid price';
//                           return null;
//                         },
//                         onSaved: (v) => _price = double.parse(v!.trim()),
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
//                     onPressed: () => Navigator.of(context).pop(),
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: AppColors.border),
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                     child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
//                   ),
//                   const SizedBox(width: 12),
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (!_formKey.currentState!.validate()) return;
//                       _formKey.currentState!.save();

//                       final provider = context.read<CourseProvider>();
//                       final newCourse = CourseModel(
//                         id: '',
//                         courseId: '',
//                         title: _title,
//                         instructor: _instructor,
//                         category: _category,
//                         price: _price,
//                         description: _description,
//                         image: _image,
//                       );

//                       final success = await provider.addCourse(newCourse);
//                       if (success) {
//                         Navigator.of(context).pop();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Course added successfully!'),
//                             backgroundColor: AppColors.primary,
//                             behavior: SnackBarBehavior.floating,
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(provider.errorMessage ?? 'Failed to add course'),
//                             backgroundColor: Colors.red,
//                             behavior: SnackBarBehavior.floating,
//                           ),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       elevation: 0,
//                     ),
//                     child: const Text('Add Course'),
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