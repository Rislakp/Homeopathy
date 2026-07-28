// import 'package:flutter/material.dart';
// import 'package:homeopathy/admin/screens/live_classes/widgets/loading_widget.dart';
// import 'package:provider/provider.dart';
// import '../providers/subscription_plan_provider.dart';
// import '../widgets/empty_subscription_widget.dart';

// import '../widgets/subscription_card.dart';
// import '../widgets/subscription_header.dart';
// import '../widgets/subscription_search_filter_bar.dart';
// import '../widgets/add_subscription_dialog.dart';

// class SubscriptionPlansScreen extends StatefulWidget {
//   const SubscriptionPlansScreen({super.key});

//   @override
//   State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
// }

// class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Load plans on init
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<SubscriptionPlanProvider>().loadPlans();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<SubscriptionPlanProvider>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 1. Header Row
//               const SubscriptionHeader(),
//               const SizedBox(height: 24),

//               // 2. Search & Filter Bar
//               const SubscriptionSearchFilterBar(),
//               const SizedBox(height: 24),

//               // 3. Grid / Empty / Loading Body Switcher
//               Expanded(
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   transitionBuilder: (child, animation) {
//                     return FadeTransition(opacity: animation, child: child);
//                   },
//                   child: _buildBody(provider),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(SubscriptionPlanProvider provider) {
//     if (provider.isLoading) {
//       return const LoadingWidget(
//         key: ValueKey('loading'),
//         message: 'Fetching subscription pricing tiers...',
//       );
//     }

//     if (provider.plans.isEmpty) {
//       return EmptySubscriptionWidget(
//         key: const ValueKey('empty'),
//         onAddPressed: () {
//           showDialog(
//             context: context,
//             builder: (ctx) => AddSubscriptionDialog(
//               onSave: (newPlan) {
//                 provider.addPlan(newPlan);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Subscription plan added successfully!'),
//                     backgroundColor: Color(0xFF16A34A),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       );
//     }

//     return LayoutBuilder(
//       key: const ValueKey('grid'),
//       builder: (context, constraints) {
//         int crossAxisCount = 4;
//         if (constraints.maxWidth < 600) {
//           crossAxisCount = 1; // Mobile
//         } else if (constraints.maxWidth < 1000) {
//           crossAxisCount = 2; // Tablet
//         } else {
//           crossAxisCount = 4; // Desktop
//         }

//         return GridView.builder(
//           itemCount: provider.plans.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: crossAxisCount,
//             crossAxisSpacing: 24,
//             mainAxisSpacing: 24,
//             mainAxisExtent: 440, // fixed height for unified row lengths
//           ),
//           itemBuilder: (context, index) {
//             final plan = provider.plans[index];
//             return SubscriptionCard(
//               plan: plan,
//               onUpdate: (updated) {
//                 provider.updatePlan(updated);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Plan "${updated.planName}" updated!'),
//                     backgroundColor: const Color(0xFF16A34A),
//                   ),
//                 );
//               },
//               onDelete: (deleted) {
//                 provider.deletePlan(deleted.id);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Plan "${deleted.planName}" deleted.'),
//                     backgroundColor: const Color(0xFFEF4444),
//                     action: SnackBarAction(
//                       label: 'Undo',
//                       textColor: Colors.white,
//                       onPressed: () {
//                         provider.addPlan(deleted);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
