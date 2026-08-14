import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/courses/courses_screen.dart';
import 'package:homeopathy/admin/screens/students/students_screen.dart';
import 'package:homeopathy/admin/screens/test_history/test_history_screen.dart';
import 'package:homeopathy/admin/theme/admin_colors.dart';
import 'package:provider/provider.dart';
import 'models/admin_menu_item.dart';
import 'providers/drawer_provider.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/grandmocktest/exams_screen.dart';
import 'widgets/common/admin_header.dart';
import 'widgets/drawer/app_drawer.dart';
import 'widgets/responsive/responsive_layout.dart';

class AdminShellLayout extends StatelessWidget {
  const AdminShellLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerProvider = context.watch<DrawerProvider>();
    final selectedMenu = drawerProvider.selectedMenu;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: AdminColors.background,
      drawer: isMobile ? const Drawer(child: AppDrawer()) : null,
      body: Row(
        children: [
          // Desktop & Tablet Drawer
          if (!isMobile) const AppDrawer(),

          // Main Body Screen
          Expanded(
            child: Column(
              children: [
                // Top AppBar Header
                AdminHeader(
                  title: selectedMenu.label,
                  showMenuButton: isMobile,
                  onMenuPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  subtitle: '',
                ),

                // Animated Active Screen Container
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.02, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey<AdminMenuItem>(selectedMenu),
                      child: _buildBodyForMenu(selectedMenu),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyForMenu(AdminMenuItem menuItem) {
    switch (menuItem) {
      case AdminMenuItem.dashboard:
        return const AdminDashboardScreen();

      // Academics
      // case AdminMenuItem.teachers:
      //   return const TeachersScreen();
        case AdminMenuItem.students:
        return const StudentsScreen();
      case AdminMenuItem.courses:
        return const CourseManagementPage();
      // // return const CoursesScreen();
      // case AdminMenuItem.categories:
      //   return const CategoriesScreen();
      // case AdminMenuItem.videos:
      //   return const VideosScreen();
      // case AdminMenuItem.demoVideos:
      //   return const DemoVideosScreen();
      // case AdminMenuItem.liveClasses:
      //   return const LiveClassesScreen();
      // case AdminMenuItem.recordedClasses:
      //   return const RecordedClassesScreen();
     
      // case AdminMenuItem.notes:
      //   return const NotesScreen();
      // case AdminMenuItem.questionBank:
      //   return const QuestionBankScreen();
      case AdminMenuItem.grandmocktest:
        return const GrandMockPage();
        case AdminMenuItem.testHistory:
        return const TestHistoryScreen();
      // case AdminMenuItem.admissions:
      //   return const AdmissionsScreen();
      // case AdminMenuItem.fees:
      //   return const SubscriptionPlansScreen();

      // Events
      // case AdminMenuItem.events:
      //   return const EventsScreen();
      // case AdminMenuItem.workshops:
      //   return const WorkshopsScreen();
      // case AdminMenuItem.webinars:
      //   return const WebinarsScreen();
      // case AdminMenuItem.placements:
      //   return const PlacementsScreen();

      // Communication
      // case AdminMenuItem.notifications:
      //   return const NotificationsScreen();

      // // Finance
     
      // case AdminMenuItem.subscriptions:
      //   return const SubscriptionPlansScreen();
    
      // // User Management
      // case AdminMenuItem.admins:
      //   return const AdminsScreen();
      // case AdminMenuItem.roles:
      //   return const RolesScreen();
      
      // Settings
      // case AdminMenuItem.generalSettings:
      //   return const GeneralSettingsScreen();
      // case AdminMenuItem.branding:
      //   return const BrandingScreen();
      // case AdminMenuItem.appSettings:
      //   return const AppSettingsScreen();
      // case AdminMenuItem.emailSettings:
      //   return const EmailSettingsScreen();
      // case AdminMenuItem.smsSettings:
      //   return const SmsSettingsScreen();
      // case AdminMenuItem.paymentGateway:
      //   return const PaymentGatewayScreen();
      // case AdminMenuItem.firebase:
      //   return const FirebaseScreen();
      // case AdminMenuItem.apiKeys:
      //   return const ApiKeysScreen();
      // case AdminMenuItem.backup:
      //   return const BackupScreen();
      // case AdminMenuItem.security:
      //   return const SecurityScreen();
      // case AdminMenuItem.logs:
      //   return const LogsScreen();
      // case AdminMenuItem.activityHistory:
      //   return const ActivityHistoryScreen();

      default:
        return const AdminDashboardScreen();
    }
  }
}
