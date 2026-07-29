import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/students/students_screen.dart';
import 'package:provider/provider.dart';
import 'models/admin_menu_item.dart';
import 'providers/drawer_provider.dart';
import 'screens/settings/activity_history_screen.dart';
import 'screens/admissions/admissions_screen.dart';
import 'screens/admins/admins_screen.dart';
import 'screens/analytics/analytics_screen.dart';
import 'screens/announcements/announcements_screen.dart';
import 'screens/assignments/assignments_screen.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/coupons/coupons_screen.dart';
import 'screens/courses/courses_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/demo_videos/demo_videos_screen.dart';
import 'screens/exams/exams_screen.dart';
import 'screens/live_classes/live_classes_screen.dart';
import 'screens/messages/messages_screen.dart';
import 'screens/notes/notes_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/payments/payments_screen.dart';
import 'screens/permissions/permissions_screen.dart';
import 'screens/question_bank/question_bank_screen.dart';
import 'screens/recorded_classes/recorded_classes_screen.dart';
import 'screens/refunds/refunds_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/revenue/revenue_screen.dart';
import 'screens/roles/roles_screen.dart';
import 'screens/settings/app_settings_screen.dart';
import 'screens/settings/branding_screen.dart';
import 'screens/settings/email_settings_screen.dart';
import 'screens/settings/general_settings_screen.dart';
import 'screens/settings/logs_screen.dart';
import 'screens/settings/payment_gateway_screen.dart';
import 'screens/settings/security_screen.dart';
import 'screens/settings/sms_settings_screen.dart';
import 'screens/subscriptions/subscriptions_screen.dart';
import 'screens/support/support_screen.dart';
import 'screens/teachers/teachers_screen.dart';
import 'screens/videos/videos_screen.dart';
import 'screens/webinars/webinars_screen.dart';
import 'screens/workshops/workshops_screen.dart';
import 'theme/admin_colors.dart';
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
        return const DashboardScreen();

      // Academics
      case AdminMenuItem.teachers:
        return const TeachersScreen();
        case AdminMenuItem.students:
        return const StudentsScreen();
      case AdminMenuItem.courses:
        return const CourseManagementPage();
      // return const CoursesScreen();
      case AdminMenuItem.categories:
        return const CategoriesScreen();
      case AdminMenuItem.videos:
        return const VideosScreen();
      case AdminMenuItem.demoVideos:
        return const DemoVideosScreen();
      case AdminMenuItem.liveClasses:
        return const LiveClassesScreen();
      case AdminMenuItem.recordedClasses:
        return const RecordedClassesScreen();
      case AdminMenuItem.assignments:
        return const AssignmentsScreen();
      case AdminMenuItem.notes:
        return const NotesScreen();
      case AdminMenuItem.questionBank:
        return const QuestionBankScreen();
      case AdminMenuItem.exams:
        return const ExamsScreen();
      // case AdminMenuItem.admissions:
      //   return const AdmissionsScreen();
      case AdminMenuItem.fees:
        return const SubscriptionPlansScreen();

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
      case AdminMenuItem.notifications:
        return const NotificationsScreen();
      case AdminMenuItem.announcements:
        return const AnnouncementsScreen();
      case AdminMenuItem.messages:
        return const MessagesScreen();
      case AdminMenuItem.supportTickets:
        return const SupportScreen();
      case AdminMenuItem.reports:
        return const ReportsScreen();
      case AdminMenuItem.analytics:
        return const AnalyticsScreen();

      // Finance
      case AdminMenuItem.payments:
        return const PaymentsScreen();
      case AdminMenuItem.revenue:
        return const RevenueScreen();
      case AdminMenuItem.subscriptions:
        return const SubscriptionPlansScreen();
      case AdminMenuItem.coupons:
        return const CouponsScreen();
      case AdminMenuItem.refunds:
        return const RefundsScreen();

      // User Management
      case AdminMenuItem.admins:
        return const AdminsScreen();
      case AdminMenuItem.roles:
        return const RolesScreen();
      case AdminMenuItem.permissions:
        return const PermissionsScreen();

      // Settings
      case AdminMenuItem.generalSettings:
        return const GeneralSettingsScreen();
      case AdminMenuItem.branding:
        return const BrandingScreen();
      case AdminMenuItem.appSettings:
        return const AppSettingsScreen();
      case AdminMenuItem.emailSettings:
        return const EmailSettingsScreen();
      case AdminMenuItem.smsSettings:
        return const SmsSettingsScreen();
      case AdminMenuItem.paymentGateway:
        return const PaymentGatewayScreen();
      // case AdminMenuItem.firebase:
      //   return const FirebaseScreen();
      // case AdminMenuItem.apiKeys:
      //   return const ApiKeysScreen();
      // case AdminMenuItem.backup:
      //   return const BackupScreen();
      case AdminMenuItem.security:
        return const SecurityScreen();
      case AdminMenuItem.logs:
        return const LogsScreen();
      case AdminMenuItem.activityHistory:
        return const ActivityHistoryScreen();

      default:
        return const DashboardScreen();
    }
  }
}
