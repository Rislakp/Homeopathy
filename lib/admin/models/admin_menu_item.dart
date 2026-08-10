import 'package:flutter/material.dart';

enum AdminMenuSection {
  overview('OVERVIEW'),
  academics('ACADEMICS'),
  events('EVENTS'),
  communication('COMMUNICATION'),
  finance('FINANCE'),
  userManagement('USER MANAGEMENT'),
  settings('SETTINGS'),
  help('HELP');

  final String title;
  const AdminMenuSection(this.title);
}

enum AdminMenuItem {
  // Overview
  dashboard(AdminMenuSection.overview, 'Dashboard', Icons.dashboard_rounded),

  // Academics
//  teachers(AdminMenuSection.academics, 'Teachers', Icons.school_rounded),
  students(AdminMenuSection.academics, ' Students', Icons.people,),
  courses(AdminMenuSection.academics, 'Courses', Icons.menu_book_rounded),
  categories(AdminMenuSection.academics, 'Categories', Icons.category_rounded),
  // videos(AdminMenuSection.academics, 'Videos', Icons.play_circle_fill_rounded),
  // demoVideos(AdminMenuSection.academics, 'Demo Videos', Icons.smart_display_rounded),
 // liveClasses(AdminMenuSection.academics, 'Live Classes', Icons.live_tv_rounded),
 // recordedClasses(AdminMenuSection.academics, 'Recorded Classes', Icons.video_library_rounded),
 // assignments(AdminMenuSection.academics, 'Assignments', Icons.assignment_rounded),
 // notes(AdminMenuSection.academics, 'Notes', Icons.description_rounded),
  questionBank(AdminMenuSection.academics, 'Question Bank', Icons.quiz_rounded),
  exams(AdminMenuSection.academics, 'Exams', Icons.fact_check_rounded),
  // certificates(AdminMenuSection.academics, 'Certificates', Icons.workspace_premium_rounded),
  // admissions(AdminMenuSection.academics, 'Admissions', Icons.how_to_reg_rounded),
  // attendance(AdminMenuSection.academics, 'Attendance', Icons.rule_rounded),
 // fees(AdminMenuSection.academics, 'Fees', Icons.payments_rounded),
//  library(AdminMenuSection.academics, 'Library', Icons.local_library_rounded),
  // hostel(AdminMenuSection.academics, 'Hostel', Icons.apartment_rounded),

  // Events
  // events(AdminMenuSection.events, 'Events', Icons.event_rounded),
  // workshops(AdminMenuSection.events, 'Workshops', Icons.build_circle_rounded),
  // webinars(AdminMenuSection.events, 'Webinars', Icons.video_call_rounded),
  // placements(AdminMenuSection.events, 'Placements', Icons.work_rounded),

  // Communication
  notifications(AdminMenuSection.communication, 'Notifications', Icons.notifications_rounded),
  announcements(AdminMenuSection.communication, 'Announcements', Icons.campaign_rounded),
  messages(AdminMenuSection.communication, 'Messages', Icons.chat_rounded),
  supportTickets(AdminMenuSection.communication, 'Support Tickets', Icons.confirmation_number_rounded),
  reports(AdminMenuSection.communication, 'Reports', Icons.assessment_rounded),
  analytics(AdminMenuSection.communication, 'Analytics', Icons.insights_rounded),

  // Finance
  payments(AdminMenuSection.finance, 'Payments', Icons.account_balance_wallet_rounded),
  revenue(AdminMenuSection.finance, 'Revenue', Icons.attach_money_rounded),
  subscriptions(AdminMenuSection.finance, 'Subscriptions', Icons.card_membership_rounded),
  coupons(AdminMenuSection.finance, 'Coupons', Icons.local_offer_rounded),
  refunds(AdminMenuSection.finance, 'Refunds', Icons.money_off_rounded),

  // User Management
  admins(AdminMenuSection.userManagement, 'Admins', Icons.admin_panel_settings_rounded),
  roles(AdminMenuSection.userManagement, 'Roles', Icons.manage_accounts_rounded),
  permissions(AdminMenuSection.userManagement, 'Permissions', Icons.verified_user_rounded),
  parents(AdminMenuSection.userManagement, 'Parents', Icons.family_restroom_rounded),
  staff(AdminMenuSection.userManagement, 'Staff', Icons.badge_rounded),

  // Settings
  generalSettings(AdminMenuSection.settings, 'General Settings', Icons.settings_rounded),
  branding(AdminMenuSection.settings, 'Branding', Icons.brush_rounded),
  appSettings(AdminMenuSection.settings, 'App Settings', Icons.phone_android_rounded),
  emailSettings(AdminMenuSection.settings, 'Email Settings', Icons.email_rounded),
  smsSettings(AdminMenuSection.settings, 'SMS Settings', Icons.sms_rounded),
  paymentGateway(AdminMenuSection.settings, 'Payment Gateway', Icons.credit_card_rounded),
  // firebase(AdminMenuSection.settings, 'Firebase', Icons.local_fire_department_rounded),
  // apiKeys(AdminMenuSection.settings, 'API Keys', Icons.vpn_key_rounded),
  // backup(AdminMenuSection.settings, 'Backup', Icons.cloud_download_rounded),
  security(AdminMenuSection.settings, 'Security', Icons.shield_rounded),
  logs(AdminMenuSection.settings, 'Logs', Icons.receipt_long_rounded),
  activityHistory(AdminMenuSection.settings, 'Activity History', Icons.history_rounded),

  // Help
  helpCenter(AdminMenuSection.help, 'Help Center', Icons.help_outline_rounded),
  faq(AdminMenuSection.help, 'FAQ', Icons.question_answer_rounded),
  documentation(AdminMenuSection.help, 'Documentation', Icons.import_contacts_rounded),
  logout(AdminMenuSection.help, 'Logout', Icons.logout_rounded);

  final AdminMenuSection section;
  final String label;
  final IconData icon;

  const AdminMenuItem(this.section, this.label, this.icon);
}
