// import 'package:flutter/material.dart';
// import '../utils/app_colors.dart';

// class StatusChip extends StatelessWidget {
//   final String status;

//   const StatusChip({
//     super.key,
//     required this.status,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Color bg;
//     Color text;

//     switch (status.toLowerCase()) {
//       case 'active':
//         bg = AppColors.activeBg;
//         text = AppColors.activeText;
//         break;
//       case 'inactive':
//         bg = AppColors.inactiveBg;
//         text = AppColors.inactiveText;
//         break;
//       case 'trial':
//         bg = AppColors.trialBg;
//         text = AppColors.trialText;
//         break;
//       case 'expired':
//         bg = AppColors.expiredBg;
//         text = AppColors.expiredText;
//         break;
//       default:
//         bg = AppColors.inactiveBg;
//         text = AppColors.inactiveText;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: text,
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
