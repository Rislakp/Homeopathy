// import 'package:flutter/material.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_textstyles.dart';

// class StudentStatusChip extends StatelessWidget {
//   final String status;

//   const StudentStatusChip({
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

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeInOut,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         status,
//         style: AppTextStyles.statusChip.copyWith(color: text),
//       ),
//     );
//   }
// }
