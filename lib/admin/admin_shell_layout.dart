import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class AdminShellLayout extends StatefulWidget {
  const AdminShellLayout({super.key});

  @override
  State<AdminShellLayout> createState() => _AdminShellLayoutState();
}

class _AdminShellLayoutState extends State<AdminShellLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final drawerProvider = context.watch<DrawerProvider>();
    final selectedMenu = drawerProvider.selectedMenu;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      key: _scaffoldKey,

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
                  subtitle: '',
                  onMenuPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
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
