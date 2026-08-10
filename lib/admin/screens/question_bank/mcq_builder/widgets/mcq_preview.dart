// import 'package:flutter/material.dart';

// class McqPreview extends StatefulWidget {
//   final String questionText;

//   const McqPreview({
//     super.key,
//     required this.questionText,
//   });

//   @override
//   State<McqPreview> createState() => _McqPreviewState();
// }

// class _McqPreviewState extends State<McqPreview> {
//   int? _selectedOptionIndex; // Keep track of clicked option in mock preview

//   final List<String> _mockOptions = const [
//     "A. Right coronary artery",
//     "B. Left anterior descending artery",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     const Color labelColor = Color(0xFF667085);
//     const Color borderCol = Color(0xFFE1E7EC);

//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: borderCol),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.015),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header Label
//           const Text(
//             "LIVE PREVIEW",
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//               color: labelColor,
//               letterSpacing: 0.8,
//             ),
//           ),
//           const SizedBox(height: 18),

//           // Simulated Mobile Device Card
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: const Color(0xFFE1E7EC)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.04),
//                   blurRadius: 16,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Mobile Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Question 1",
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF667085),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF1F8F6),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: const Text(
//                         "+4 / -1",
//                         style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF08A653),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 // Question Text
//                 Text(
//                   widget.questionText.isEmpty
//                       ? "A 58-year-old man presents with crushing retrosternal chest pain..."
//                       : widget.questionText,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF172033),
//                     height: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // MCQ Clickable Options
//                 Column(
//                   children: List.generate(_mockOptions.length, (index) {
//                     final isSelected = _selectedOptionIndex == index;
//                     return _buildOptionButton(index, _mockOptions[index], isSelected);
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOptionButton(int index, String optionText, bool isSelected) {
//     const Color green = Color(0xFF08A653);
//     const Color lightGreen = Color(0xFFDDF7E8);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             _selectedOptionIndex = isSelected ? null : index;
//           });
//         },
//         borderRadius: BorderRadius.circular(10),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 150),
//           width: double.infinity,
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: isSelected ? lightGreen : Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: isSelected ? green : const Color(0xFFE1E7EC),
//               width: isSelected ? 1.5 : 1,
//             ),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 20,
//                 height: 20,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: isSelected ? green : Colors.white,
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: isSelected ? green : const Color(0xFFD9D9D9),
//                     width: 1.5,
//                   ),
//                 ),
//                 child: isSelected
//                     ? const Icon(Icons.check, size: 12, color: Colors.white)
//                     : null,
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   optionText,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//                     color: const Color(0xFF172033),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
