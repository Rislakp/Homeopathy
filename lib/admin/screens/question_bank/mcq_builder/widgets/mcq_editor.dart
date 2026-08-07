// import 'package:flutter/material.dart';

// class McqEditor extends StatelessWidget {
//   final TextEditingController controller;
//   final ValueChanged<String> onChanged;
//   final VoidCallback onUploadImage;
//   final VoidCallback onUploadVideo;
//   final VoidCallback onUploadPdf;

//   const McqEditor({
//     super.key,
//     required this.controller,
//     required this.onChanged,
//     required this.onUploadImage,
//     required this.onUploadVideo,
//     required this.onUploadPdf,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const Color borderCol = Color(0xFFE1E7EC);
//     const Color labelColor = Color(0xFF667085);

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
//             "QUESTION EDITOR",
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//               color: labelColor,
//               letterSpacing: 0.8,
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Rich Text Toolbar
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 4),
//             decoration: const BoxDecoration(
//               border: Border(
//                 top: BorderSide(color: borderCol),
//                 bottom: BorderSide(color: borderCol),
//               ),
//             ),
//             child: Row(
//               children: [
//                 _buildToolbarButton(Icons.format_bold_rounded, "Bold"),
//                 _buildToolbarButton(Icons.format_italic_rounded, "Italic"),
//                 _buildToolbarButton(Icons.format_list_bulleted_rounded, "Bullet List"),
//                 _buildToolbarButton(Icons.functions_rounded, "Math Formula"),
//                 _buildToolbarButton(Icons.image_outlined, "Insert Image"),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Multi-line Text Area
//           TextField(
//             controller: controller,
//             onChanged: onChanged,
//             maxLines: 8,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF172033),
//               fontWeight: FontWeight.w500,
//               height: 1.5,
//             ),
//             decoration: const InputDecoration(
//               hintText: "Type your question contents here...",
//               hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
//               border: InputBorder.none,
//             ),
//           ),
//           const SizedBox(height: 24),

//           // Media Upload Cards
//           const Text(
//             "ATTACH MEDIA",
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               color: labelColor,
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 12,
//             runSpacing: 12,
//             children: [
//               _buildUploadCard(
//                 icon: Icons.image_outlined,
//                 label: "Upload Image",
//                 onTap: onUploadImage,
//               ),
//               _buildUploadCard(
//                 icon: Icons.play_circle_outline_rounded,
//                 label: "Upload Video",
//                 onTap: onUploadVideo,
//               ),
//               _buildUploadCard(
//                 icon: Icons.description_outlined,
//                 label: "Upload PDF",
//                 onTap: onUploadPdf,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildToolbarButton(IconData icon, String tooltip) {
//     return IconButton(
//       icon: Icon(icon, size: 20, color: const Color(0xFF667085)),
//       tooltip: tooltip,
//       onPressed: () {},
//       splashRadius: 18,
//     );
//   }

//   Widget _buildUploadCard({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         width: 140,
//         height: 100,
//         decoration: BoxDecoration(
//           color: const Color(0xFFF9FAFB),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: const Color(0xFFE1E7EC)),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(icon, size: 28, color: const Color(0xFF667085)),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF172033),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
