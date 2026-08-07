import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/courses/course_view/add_lessons/add_lesson_dialog.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/utils/app_colors.dart';

// =============================================================================
// LESSON & VERSION MODELS
// =============================================================================

class Lesson {
  final String id;
  final String title;
  final String duration;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.duration,
    this.isCompleted = false,
  });
}

class VersionLog {
  final String version;
  final String timeAgo;
  final String author;
  final String description;

  VersionLog({
    required this.version,
    required this.timeAgo,
    required this.author,
    required this.description,
  });
}

// =============================================================================
// STATE MANAGEMENT: COURSE VIEW PROVIDER
// =============================================================================

class CourseViewProvider extends ChangeNotifier {
  // Course details
  final String _title = "Classical Homeopathy Foundations";
  final String _description =
      "A comprehensive foundation course covering the philosophy, principles and history of Classical Homeopathy as laid down by Dr. Samuel Hahnemann, designed for beginner practitioners.";
  final String _instructor = "Dr. Anjali Verma";
  final String _duration = "42 hrs";
  final String _students = "1,240 Students";
  final String _price = "₹4,999";
  final double _completionRate = 0.68;
  final String _status = "Published";
  final bool _isBestseller = true;
  final String _demoVideoDuration = "03:24";
  final String _lastUpdated = "Last updated 2 hours ago by Dr. Anjali Verma";

  // List of lessons (mock data)
  final List<Lesson> _lessons = [
    Lesson(
      id: "1",
      title: "Introduction to Homeopathic Philosophy",
      duration: "45 mins",
      isCompleted: true,
    ),
    Lesson(
      id: "2",
      title: "The Law of Similars (Similia Similibus Curentur)",
      duration: "1 hr 15 mins",
      isCompleted: true,
    ),
    Lesson(
      id: "3",
      title: "Understanding the Vital Force Concept & Vitality",
      duration: "50 mins",
      isCompleted: true,
    ),
    Lesson(
      id: "4",
      title: "Introduction to Homeopathic Posology & Potency Selection",
      duration: "1 hr 30 mins",
      isCompleted: false,
    ),
    Lesson(
      id: "5",
      title: "Miasmatic Theory & Chronic Diseases Classification",
      duration: "2 hrs 10 mins",
      isCompleted: false,
    ),
    Lesson(
      id: "6",
      title: "Case Taking Principles, Methodology & Repertorization",
      duration: "3 hrs",
      isCompleted: false,
    ),
  ];

  // List of history versions (mock data)
  final List<VersionLog> _versionHistory = [
    VersionLog(
      version: "v1.2",
      timeAgo: "2 hours ago",
      author: "Dr. Anjali Verma",
      description:
          "Added Quiz on Vital Force concepts & updated reading materials.",
    ),
    VersionLog(
      version: "v1.1",
      timeAgo: "1 week ago",
      author: "Dr. Anjali Verma",
      description: "Added case study lecture notes and practice exercises.",
    ),
    VersionLog(
      version: "v1.0",
      timeAgo: "3 weeks ago",
      author: "Super Admin",
      description: "Initial release of the foundational course curriculum.",
    ),
  ];

  // UI Interactive States
  bool _isDarkMode = false;
  String _searchQuery = "";
  bool _isPlayingDemo = false;

  // Getters
  String get title => _title;
  String get description => _description;
  String get instructor => _instructor;
  String get duration => _duration;
  String get students => _students;
  String get price => _price;
  double get completionRate => _completionRate;
  String get status => _status;
  bool get isBestseller => _isBestseller;
  String get demoVideoDuration => _demoVideoDuration;
  String get lastUpdated => _lastUpdated;
  List<VersionLog> get versionHistory => _versionHistory;

  List<Lesson> get lessons {
    if (_searchQuery.isEmpty) {
      return _lessons;
    }
    return _lessons
        .where(
          (lesson) =>
              lesson.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  bool get isDarkMode => _isDarkMode;
  String get searchQuery => _searchQuery;
  bool get isPlayingDemo => _isPlayingDemo;

  // Setters & Actions
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void togglePlayDemo(bool play) {
    _isPlayingDemo = play;
    notifyListeners();
  }

  void addLesson(String title, String duration) {
    _lessons.add(
      Lesson(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        duration: duration,
        isCompleted: false,
      ),
    );
    notifyListeners();
  }
}

// =============================================================================
// MAIN UI SCREEN: COURSE VIEW SCREEN
// =============================================================================

class CourseViewScreen extends StatelessWidget {
  const CourseViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseViewProvider(),
      child: Consumer<CourseViewProvider>(
        builder: (context, provider, child) {
          // Define Color Palettes based on Dark Mode state
          final scaffoldBgColor = provider.isDarkMode
              ? const Color(0xFF0F172A)
              : AppColors.background;

          final cardBgColor = provider.isDarkMode
              ? const Color(0xFF1E293B)
              : AppColors.surface;

          final primaryTextColor = provider.isDarkMode
              ? Colors.white
              : AppColors.textPrimary;

          final secondaryTextColor = provider.isDarkMode
              ? const Color(0xFF94A3B8)
              : AppColors.textSecondary;

          final borderColor = provider.isDarkMode
              ? const Color(0xFF334155)
              : AppColors.border;

          final dividerColor = provider.isDarkMode
              ? const Color(0xFF334155)
              : AppColors.divider;

          return Scaffold(
            backgroundColor: scaffoldBgColor,
            body: SafeArea(
              child: Column(
                children: [
                  // 1. TOP HEADER / APP BAR
                  _buildHeader(
                    context,
                    provider,
                    cardBgColor,
                    primaryTextColor,
                    secondaryTextColor,
                    borderColor,
                  ),

                  // 2. MAIN SCROLLABLE BODY
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 1024;

                          if (isWide) {
                            // Two-Column Layout (Desktop/Tablet landscape)
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Column (65% width)
                                Expanded(
                                  flex: 65,
                                  child: _buildLeftColumn(
                                    context,
                                    provider,
                                    cardBgColor,
                                    primaryTextColor,
                                    secondaryTextColor,
                                    borderColor,
                                    dividerColor,
                                    false,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                // Right Column (35% width)
                                Expanded(
                                  flex: 35,
                                  child: _buildRightColumn(
                                    context,
                                    provider,
                                    cardBgColor,
                                    primaryTextColor,
                                    secondaryTextColor,
                                    borderColor,
                                    dividerColor,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // One-Column Stack Layout (Mobile/Tablet portrait)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildLeftColumn(
                                  context,
                                  provider,
                                  cardBgColor,
                                  primaryTextColor,
                                  secondaryTextColor,
                                  borderColor,
                                  dividerColor,
                                  true, // Show inline search for small screens
                                ),
                                const SizedBox(height: 24),
                                _buildRightColumn(
                                  context,
                                  provider,
                                  cardBgColor,
                                  primaryTextColor,
                                  secondaryTextColor,
                                  borderColor,
                                  dividerColor,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // =============================================================================
  // UI SEGMENT: HEADER
  // =============================================================================

  Widget _buildHeader(
    BuildContext context,
    CourseViewProvider provider,
    Color cardBgColor,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color borderColor,
  ) {
    final showSmall = MediaQuery.of(context).size.width < 1100;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: cardBgColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: primaryTextColor),
            tooltip: 'Back to Courses',
          ),
          const SizedBox(width: 8),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Course Details",
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Classical Homeopathy Foundations",
                  style: GoogleFonts.inter(
                    color: secondaryTextColor,
                    fontSize: isMobile ? 11 : 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Center Search Bar (Hidden on smaller viewports; falls back to inline)
          if (!showSmall) ...[
            SizedBox(
              width: 280,
              height: 40,
              child: TextField(
                onChanged: provider.updateSearchQuery,
                style: GoogleFonts.inter(color: primaryTextColor, fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Search lessons...",
                  hintStyle: GoogleFonts.inter(
                    color: secondaryTextColor,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: secondaryTextColor,
                  ),
                  filled: true,
                  fillColor: provider.isDarkMode
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Dark Mode Toggle
          IconButton(
            onPressed: provider.toggleDarkMode,
            icon: Icon(
              provider.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: primaryTextColor,
            ),
            tooltip: 'Toggle Dark Mode',
          ),

          // Notifications Icon
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Notifications panel opened",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  width: 300,
                ),
              );
            },
            icon: Icon(
              Icons.notifications_none_rounded,
              color: primaryTextColor,
            ),
            tooltip: 'Notifications',
          ),

          // Chat Icon
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Chat panel opened",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  width: 300,
                ),
              );
            },
            icon: Icon(
              Icons.chat_bubble_outline_rounded,
              color: primaryTextColor,
            ),
            tooltip: 'Chat Messages',
          ),

          // Super Admin User Dropdown (Hidden on Mobile)
          if (!isMobile) ...[
            const SizedBox(width: 12),
            PopupMenuButton<String>(
              onSelected: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Profile Dropdown: $value",
                      style: GoogleFonts.inter(),
                    ),
                    behavior: SnackBarBehavior.floating,
                    width: 250,
                  ),
                );
              },
              offset: const Offset(0, 48),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: Text(
                    'My Profile',
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Text(
                    'Settings',
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text(
                    'Logout',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.red),
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primaryDark,
                      child: Text(
                        "DR",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Dr. Renu Sharma",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "Super Admin",
                          style: GoogleFonts.inter(
                            color: secondaryTextColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: secondaryTextColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =============================================================================
  // UI SEGMENT: LEFT COLUMN (MAIN DETAILS)
  // =============================================================================

  Widget _buildLeftColumn(
    BuildContext context,
    CourseViewProvider provider,
    Color cardBgColor,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color borderColor,
    Color dividerColor,
    bool showInlineSearch,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. HERO IMAGE (Bright green stethoscope header)
        Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF10B981), // Bright emerald green
                Color(0xFF059669), // Rich green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Decorative background designs
              Positioned(
                right: -30,
                bottom: -30,
                child: CircleAvatar(
                  radius: 110,
                  backgroundColor: Colors.white.withOpacity(0.08),
                ),
              ),
              Positioned(
                left: -40,
                top: -40,
                child: CircleAvatar(
                  radius: 90,
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
              ),
              // Main Icon & Text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons
                          .medical_services_outlined, // Stethoscope stand-in representation
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "CLASSICAL HOMEOPATHY",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 2. BADGES ROW
        Row(
          children: [
            _buildPillBadge(
              "Published",
              const Color(0xFFD1FAE5),
              const Color(0xFF047857),
            ),
            const SizedBox(width: 8),
            _buildPillBadge(
              "Bestseller",
              const Color(0xFFDBEAFE),
              const Color(0xFF1D4ED8),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 3. TYPOGRAPHY
        Text(
          provider.title,
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: primaryTextColor,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          provider.description,
          style: GoogleFonts.inter(
            fontSize: 15,
            height: 1.6,
            color: secondaryTextColor,
          ),
        ),

        const SizedBox(height: 24),

        // 4. INFO CHIPS (Wrap for full responsiveness)
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildInfoChip(
              Icons.person_outline_rounded,
              provider.instructor,
              const Color(0xFFEFF6FF),
              const Color(0xFF2563EB),
            ),
            _buildInfoChip(
              Icons.access_time_rounded,
              provider.duration,
              const Color(0xFFFFF7ED),
              const Color(0xFFEA580C),
            ),
            _buildInfoChip(
              Icons.group_outlined,
              provider.students,
              const Color(0xFFF0FDF4),
              const Color(0xFF16A34A),
            ),
            _buildInfoChip(
              Icons.sell_outlined,
              provider.price,
              const Color(0xFFFEF2F2),
              const Color(0xFFDC2626),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 5. INLINE SEARCH BAR FOR NARROW WIDTHS
        if (showInlineSearch) ...[
          TextField(
            onChanged: provider.updateSearchQuery,
            style: GoogleFonts.inter(color: primaryTextColor, fontSize: 13),
            decoration: InputDecoration(
              hintText: "Search lessons...",
              hintStyle: GoogleFonts.inter(
                color: secondaryTextColor,
                fontSize: 13,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: secondaryTextColor,
              ),
              filled: true,
              fillColor: provider.isDarkMode
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // 6. COURSE CONTENT HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Course Content",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddLessonDialog(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),

              // label: const Text('Go to Second Screen'),
              label: Text(
                "Add Lesson",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 7. LESSONS LIST
        if (provider.lessons.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                "No lessons found matching standard search.",
                style: GoogleFonts.inter(color: secondaryTextColor),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.lessons.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lesson = provider.lessons[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                  boxShadow: provider.isDarkMode ? [] : AppColors.softShadow,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: lesson.isCompleted
                          ? const Color(0xFFD1FAE5)
                          : (provider.isDarkMode
                                ? const Color(0xFF334155)
                                : const Color(0xFFF1F5F9)),
                      child: Text(
                        "${index + 1}",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: lesson.isCompleted
                              ? const Color(0xFF047857)
                              : secondaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lesson.duration,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (lesson.isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                        size: 20,
                      )
                    else
                      Icon(
                        Icons.play_circle_outline,
                        color: provider.isDarkMode
                            ? Colors.white60
                            : AppColors.primary.withOpacity(0.6),
                        size: 20,
                      ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  // =============================================================================
  // UI SEGMENT: RIGHT COLUMN (SIDEBAR CARDS)
  // =============================================================================

  Widget _buildRightColumn(
    BuildContext context,
    CourseViewProvider provider,
    Color cardBgColor,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color borderColor,
    Color dividerColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CARD 1: DEMO VIDEO CARD
        _buildDemoVideoCard(
          context,
          provider,
          cardBgColor,
          primaryTextColor,
          secondaryTextColor,
          borderColor,
        ),

        const SizedBox(height: 20),

        // CARD 2: COURSE PROGRESS CARD
        _buildProgressCard(
          context,
          provider,
          cardBgColor,
          primaryTextColor,
          secondaryTextColor,
          borderColor,
        ),

        const SizedBox(height: 20),

        // CARD 3: VERSION HISTORY CARD
        _buildVersionHistoryCard(
          context,
          provider,
          cardBgColor,
          primaryTextColor,
          secondaryTextColor,
          borderColor,
          dividerColor,
        ),
      ],
    );
  }

  Widget _buildDemoVideoCard(
    BuildContext context,
    CourseViewProvider provider,
    Color cardBgColor,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: provider.isDarkMode ? [] : AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Demo Video",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              provider.togglePlayDemo(!provider.isPlayingDemo);
            },
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF047857), // Deep green
                    Color(0xFF10B981), // Emerald green
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative visual pattern inside video player
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        Icons.psychology,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  if (provider.isPlayingDemo) ...[
                    // Simulated Playback State
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.55),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.pause_circle_filled,
                              size: 48,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Streaming Demo Video...",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: LinearProgressIndicator(
                                minHeight: 3,
                                backgroundColor: Colors.white24,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Play Button Circle
                    Container(
                      height: 52,
                      width: 52,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 32,
                        color: Color(0xFF047857),
                      ),
                    ),
                  ],

                  // Duration Stamp in Bottom Right
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        provider.demoVideoDuration,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Preview button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                provider.togglePlayDemo(!provider.isPlayingDemo);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: provider.isDarkMode
                      ? Colors.white24
                      : AppColors.primary,
                ),
                foregroundColor: provider.isDarkMode
                    ? Colors.white
                    : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                provider.isPlayingDemo ? "Pause Preview" : "Preview Demo",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    CourseViewProvider provider,
    Color cardBgColor,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: provider.isDarkMode ? [] : AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Course Progress (avg.)",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Completion rate",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${(provider.completionRate * 100).toInt()}%",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF10B981), // Matching progress color
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: provider.completionRate,
              minHeight: 8,
              backgroundColor: provider.isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF10B981),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionHistoryCard(
    BuildContext context,
    CourseViewProvider provider,
    Color cardBgColor,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color borderColor,
    Color dividerColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: provider.isDarkMode ? [] : AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Version History",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.lastUpdated,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: secondaryTextColor,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),
          Divider(color: dividerColor),
          const SizedBox(height: 12),

          // History Version Log details
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.versionHistory.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: dividerColor.withOpacity(0.5), height: 1),
            ),
            itemBuilder: (context, index) {
              final log = provider.versionHistory[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: provider.isDarkMode
                          ? const Color(0xFF334155)
                          : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      log.version,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              log.author,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: primaryTextColor,
                              ),
                            ),
                            Text(
                              log.timeAgo,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          log.description,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: secondaryTextColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // =============================================================================
  // UI SEGMENT: SUB-WIDGET HELPERS
  // =============================================================================

  Widget _buildPillBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String text,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================================
  // DIALOG FLOWS
  // =============================================================================

  void _showAddLessonDialog(BuildContext context, CourseViewProvider provider) {
    final titleController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final isDark = provider.isDarkMode;
        final dialogBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? Colors.white : AppColors.textPrimary;
        final secColor = isDark
            ? const Color(0xFF94A3B8)
            : AppColors.textSecondary;
        final fieldBg = isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC);
        final border = BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        );

        return AlertDialog(
          backgroundColor: dialogBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Add New Lesson",
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: GoogleFonts.inter(color: textColor),
                decoration: InputDecoration(
                  labelText: "Lesson Title",
                  labelStyle: GoogleFonts.inter(color: secColor),
                  filled: true,
                  fillColor: fieldBg,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: border,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                style: GoogleFonts.inter(color: textColor),
                decoration: InputDecoration(
                  labelText: "Duration (e.g. 1 hr 45 mins)",
                  labelStyle: GoogleFonts.inter(color: secColor),
                  filled: true,
                  fillColor: fieldBg,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: border,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.inter(color: secColor)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty &&
                    durationController.text.trim().isNotEmpty) {
                  provider.addLesson(
                    titleController.text.trim(),
                    durationController.text.trim(),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Lesson '${titleController.text}' added successfully!",
                        style: GoogleFonts.inter(),
                      ),
                      backgroundColor: const Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                      width: 320,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Please fill in all fields.",
                        style: GoogleFonts.inter(),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      width: 250,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Add Lesson",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
