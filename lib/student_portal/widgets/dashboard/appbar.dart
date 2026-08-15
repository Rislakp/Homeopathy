import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/admin/admin_app.dart';
import 'package:homeopathy/auth/login_screen.dart';
import 'package:homeopathy/auth/sign_up_screen.dart';
import 'package:homeopathy/core/theme/app_colors.dart';
import 'package:homeopathy/student_portal/pages/courses/courses_screen.dart';
import 'package:homeopathy/student_portal/pages/faculty/faculty.dart';
import 'package:homeopathy/student_portal/pages/mock_test/mock_test.dart';
import 'package:homeopathy/student_portal/pages/pricing/pricing_screen.dart';
import 'package:homeopathy/student_portal/widgets/dashboard/unani/unani.dart';
import 'package:homeopathy/student_portal/widgets/dashboard/categories/screens/aiapget_screen.dart';
import 'package:homeopathy/student_portal/widgets/dashboard/categories/screens/clinical_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  static const Color primaryBlue = AppColors.primary;
  static const Color textDarkGrey = AppColors.textSecondary;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return _buildMobileAppBar(context);
    } else if (width < 1024) {
      return _buildTabletAppBar(context);
    } else {
      return _buildDesktopAppBar(context);
    }
  }

  // --- MOBILE LAYOUT (<600px) ---
  Widget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 80,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
             _buildLogoSection(),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "White Coat",
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              Text(
                "ACADEMY",
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [_buildSearchIcon(context), const SizedBox(width: 16)],
    );
  }

  // --- TABLET LAYOUT (600px - 1023px) ---
  Widget _buildTabletAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 80,
      titleSpacing: 20,
      title: Row(
        children: [
          _buildLogoSection(),
          const Spacer(),
         // _NavMenuItem(title: "Courses", page: const CoursesScreen()),
          _NavMenuItem(title: "Mock Tests", page: const MockTest()),
        //  _NavMenuItem(title: "Faculty", page: const FacultyScreen()),
        //  _NavMenuItem(title: "Pricing", page: const PricingScreen()),
        ],
      ),
      actions: [
        _buildSearchIcon(context),
        const SizedBox(width: 12),
        _buildStartLearningButton(context),
        const SizedBox(width: 20),
      ],
    );
  }

  // --- DESKTOP LAYOUT (>=1024px) ---
  Widget _buildDesktopAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 80,
      titleSpacing: 30,
      title: Row(
        children: [
          // Logo Area on far left
          _buildLogoSection(),

          // Horizontally Centered Navigation Links
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //const _NavMenuItem(title: "Courses", page: CoursesScreen()),
                    const _NavMenuItem(title: "Mock Tests", page: MockTest()),
                   // const _NavMenuItem(title: "Pricing", page: PricingScreen()),
                   // _buildMoreDropdown(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        _buildSearchIcon(context),
        const SizedBox(width: 14),
        _buildSignInButton(context),
        const SizedBox(width: 14),
       // _buildAdminButton(context),
       // const SizedBox(width: 14),
        _buildStartLearningButton(context),
        const SizedBox(width: 30),
      ],
    );
  }

  // Widget: Admin Button
  // Widget _buildAdminButton(BuildContext context) {
  //   return MouseRegion(
  //     cursor: SystemMouseCursors.click,
  //     child: OutlinedButton.icon(
  //       onPressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (_) => const WhiteCoatAdminPortal()),
  //         );
  //       },
  //       icon: const Icon(Icons.shield_outlined, size: 16),
  //       label: Text(
  //         "Admin",
  //         style: GoogleFonts.inter(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       style: OutlinedButton.styleFrom(
  //         foregroundColor: AppColors.primary,
  //         side: const BorderSide(color: AppColors.border),
  //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget: Logo Section
  Widget _buildLogoSection() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Replaced the CircleAvatar & Icon with the WCA Logo
      Image.asset(
        'assets/images/WCA_LOGO.jpg',
        height: 70, 
        width: 70,
        fit: BoxFit.contain,
        
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "White Coat",
            style: GoogleFonts.inter(
              color: AppColors.textPrimary, // Ensure AppColors is imported
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          Text(
            "ACADEMY",
            style: GoogleFonts.inter(
              color: AppColors.primary, // Ensure AppColors is imported
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    ],
  );
}

  // Widget: More Dropdown popup menu button with screens navigation
  /*Widget _buildMoreDropdown(BuildContext context) {
    return PopupMenuButton<Widget>(
      offset: const Offset(0, 45),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "More",
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const UnaniScreen(),
          child: Text(
            "Unani",
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
        ),
        PopupMenuItem(
          value: const ClinicalScreen(),
          child: Text(
            "Clinical Classes",
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
        ),
        PopupMenuItem(
          value: const AIAPGETScreen(),
          child: Text(
            "AIAPGET",
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
        ),
      ],
      onSelected: (screen) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }*/

  // Widget: Search icon circular container
  Widget _buildSearchIcon(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(
          Icons.search_rounded,
          color: AppColors.textPrimary,
          size: 20,
        ),
      ),
    );
  }

  // Widget: Sign In text button
  Widget _buildSignInButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TextButton(
        onPressed: () {
           LoginScreen.show(context);
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(
          "Sign In",
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // Widget: Primary Medical Blue Start Learning button
  Widget _buildStartLearningButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          SignupScreen.show(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              "Start Learning",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

// Custom Navigation link with Web hover scaling and color shifts
class _NavMenuItem extends StatefulWidget {
  final String title;
  final Widget page;

  const _NavMenuItem({required this.title, required this.page});

  @override
  State<_NavMenuItem> createState() => _NavMenuItemState();
}

class _NavMenuItemState extends State<_NavMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => widget.page),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
          child: Text(
            widget.title,
            style: GoogleFonts.inter(
              color: _isHovered ? AppColors.primary : AppColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
