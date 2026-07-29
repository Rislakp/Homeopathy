// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'models/live_class_model.dart';
// import 'widgets/live_class_card.dart';
// import 'widgets/section_header.dart';
// import 'package:homeopathy/student_portal/widgets/dashboard/appbar.dart';



// class LiveClassesPageContent extends StatelessWidget {
//   const LiveClassesPageContent();

//   List<LiveClassModel> _getMockLiveClasses() {
//     final now = DateTime.now();
//     return [
//       LiveClassModel(
//         title: "AIAPGET · Organon Marathon",
//         facultyName: "Dr. Anjali Menon",
//         startTime: now.add(const Duration(hours: 2, minutes: 15)),
//         dayLabel: "Today · 7:00 PM",
//       ),
//       LiveClassModel(
//         title: "NEET PG · Physiology Crash Course",
//         facultyName: "Dr. Sandeep Kumar",
//         startTime: now.add(const Duration(hours: 4, minutes: 45)),
//         dayLabel: "Today · 9:30 PM",
//       ),
//       LiveClassModel(
//         title: "Clinical Medicine · Materia Medica & Gynaecology",
//         facultyName: "Dr. Rajesh Venkataraman",
//         startTime: now.add(const Duration(hours: 11, minutes: 30)),
//         dayLabel: "Tomorrow · 10:00 AM",
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final bool isMobile = width < 600;
//     final bool isTablet = width >= 600 && width < 1024;
//     final mockClasses = _getMockLiveClasses();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: const CustomAppBar(),
//       body: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: isMobile ? 16.w : (isTablet ? 32.w : 64.w),
//               vertical: 40.h,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Section Title Header
//                 const SectionHeader(),
//                 SizedBox(height: 40.h),

//                 // Responsive List or Wrap Layout
//                 LayoutBuilder(
//                   builder: (context, constraints) {
//                     if (isMobile) {
//                       return SizedBox(
//                         height: 380.h,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: mockClasses.length,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: EdgeInsets.only(right: 16.w),
//                               child: SizedBox(
//                                 width: 280.w,
//                                 child: LiveClassCard(
//                                   liveClass: mockClasses[index],
//                                   onRegister: () => _showRegistrationDialog(
//                                     context,
//                                     mockClasses[index],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }

//                     int columns = isTablet ? 2 : 3;
//                     double gap = 24.w;

//                     // Guard against constraints.maxWidth being infinite —
//                     // if this ever happens (e.g. misused inside an
//                     // unbounded Row), fall back to the actual screen width
//                     // instead of producing NaN/negative card widths.
//                     final double gridWidth = constraints.maxWidth.isFinite
//                         ? constraints.maxWidth
//                         : width;

//                     double cardWidth =
//                         (gridWidth - (gap * (columns - 1))) / columns;
//                     if (cardWidth.isNaN || cardWidth <= 0) {
//                       cardWidth = gridWidth / columns;
//                     }

//                     return Center(
//                       child: ConstrainedBox(
//                         constraints: const BoxConstraints(maxWidth: 1200),
//                         child: Wrap(
//                           spacing: gap,
//                           runSpacing: gap,
//                           children: mockClasses.map((item) {
//                             return SizedBox(
//                               width: cardWidth,
//                               child: LiveClassCard(
//                                 liveClass: item,
//                                 onRegister: () =>
//                                     _showRegistrationDialog(context, item),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 60.h),
//               ],
//             ),
//           ),
        
//       ),
//     );
//   }

//   void _showRegistrationDialog(BuildContext context, LiveClassModel item) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         title: Text(
//           "Registration Successful",
//           style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
//         ),
//         content: Text(
//           "You have registered for '${item.title}' by ${item.facultyName}. We will notify you when the class goes live!",
//           style: GoogleFonts.inter(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               "OK",
//               style: GoogleFonts.inter(
//                 color: const Color(0xFF0F9D58),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
