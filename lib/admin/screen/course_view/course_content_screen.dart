import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_lesson/add_lesson_dialog.dart';

// =============================================================================
// LOCAL DATA MODELS
// =============================================================================

class Lesson {
  final String id;
  final String title;
  final String typeText;
  final String details;
  final LessonType type;
  final String status;
  bool isLocked;

  Lesson({
    required this.id,
    required this.title,
    required this.typeText,
    required this.details,
    required this.type,
    required this.status,
    this.isLocked = false,
  });

  Lesson copyWith({
    String? id,
    String? title,
    String? typeText,
    String? details,
    LessonType? type,
    String? status,
    bool? isLocked,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      typeText: typeText ?? this.typeText,
      details: details ?? this.details,
      type: type ?? this.type,
      status: status ?? this.status,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class Module {
  final String id;
  final String title;
  final List<Lesson> lessons;

  Module({
    required this.id,
    required this.title,
    required this.lessons,
  });
}

class TimelineLog {
  final String id;
  final String action;
  final String author;
  final String timeAgo;

  TimelineLog({
    required this.id,
    required this.action,
    required this.author,
    required this.timeAgo,
  });
}

// =============================================================================
// MAIN SCREEN WIDGET
// =============================================================================

class CourseContentScreen extends StatefulWidget {
  const CourseContentScreen({super.key});

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  // Collapsible sidebar state
  bool _isSidebarCollapsed = false;

  // Dark/Light Theme state
  bool _isDarkMode = false;

  // Search filter query
  String _searchQuery = "";

  // Dynamic modules mock data
  late List<Module> _modules;

  // Dynamic timeline log history
  late List<TimelineLog> _timeline;

  @override
  void initState() {
    super.initState();
    _initMockData();
  }

  void _initMockData() {
    _modules = [
      Module(
        id: "mod-1",
        title: "Module 1 — Introduction to Homeopathy",
        lessons: [
          Lesson(
            id: "l-1-1",
            title: "History & Origins of Homeopathy",
            typeText: "Recorded Video",
            details: "14:20",
            type: LessonType.video,
            status: "Published",
            isLocked: false,
          ),
          Lesson(
            id: "l-1-2",
            title: "The Law of Similars in Practice",
            typeText: "Recorded Video",
            details: "22:45",
            type: LessonType.video,
            status: "Published",
            isLocked: false,
          ),
          Lesson(
            id: "l-1-3",
            title: "Hahnemann's Vital Force Principles",
            typeText: "Live Class",
            details: "10:00 AM",
            type: LessonType.liveClass,
            status: "Published",
            isLocked: true,
          ),
          Lesson(
            id: "l-1-4",
            title: "Introduction to Homeopathy Handouts",
            typeText: "PDF Notes",
            details: "12 pages",
            type: LessonType.document,
            status: "Published",
            isLocked: false,
          ),
        ],
      ),
      Module(
        id: "mod-2",
        title: "Module 2 — Materia Medica Basics",
        lessons: [
          Lesson(
            id: "l-2-1",
            title: "Aconitum Napellus: Drug Picture & Symptoms",
            typeText: "Recorded Video",
            details: "18:15",
            type: LessonType.video,
            status: "Published",
            isLocked: false,
          ),
          Lesson(
            id: "l-2-2",
            title: "Belladonna: Acute Inflammatory Remedies",
            typeText: "Recorded Video",
            details: "25:30",
            type: LessonType.video,
            status: "Published",
            isLocked: false,
          ),
          Lesson(
            id: "l-2-3",
            title: "Polychrest Remedies Comparative Study",
            typeText: "Live Class",
            details: "3:00 PM",
            type: LessonType.liveClass,
            status: "Published",
            isLocked: true,
          ),
          Lesson(
            id: "l-2-4",
            title: "Materia Medica Revision PDF",
            typeText: "PDF Notes",
            details: "8 pages",
            type: LessonType.document,
            status: "Published",
            isLocked: false,
          ),
        ],
      ),
      Module(
        id: "mod-3",
        title: "Module 3 — Chronic Miasms & Organon",
        lessons: [
          Lesson(
            id: "l-3-1",
            title: "Understanding Hahnemannian Miasms",
            typeText: "Recorded Video",
            details: "34:50",
            type: LessonType.video,
            status: "Published",
            isLocked: false,
          ),
          Lesson(
            id: "l-3-2",
            title: "Psora as the Primary Chronic Miasm",
            typeText: "Live Class",
            details: "11:30 AM",
            type: LessonType.liveClass,
            status: "Published",
            isLocked: false,
          ),
          Lesson(
            id: "l-3-3",
            title: "Chronic Diseases Treatment Guideline",
            typeText: "PDF Notes",
            details: "20 pages",
            type: LessonType.document,
            status: "Published",
            isLocked: false,
          ),
        ],
      ),
    ];

    _timeline = [
      TimelineLog(
        id: "t-1",
        action: "Updated lesson description and visibility",
        author: "Dr. Anjali Verma",
        timeAgo: "2 hours ago",
      ),
      TimelineLog(
        id: "t-2",
        action: "Replaced lesson video and updated duration",
        author: "Dr. Anjali Verma",
        timeAgo: "4 hours ago",
      ),
      TimelineLog(
        id: "t-3",
        action: "Added Live Class scheduling to Module 2",
        author: "Super Admin",
        timeAgo: "1 day ago",
      ),
    ];
  }

  // =============================================================================
  // INTERACTION HANDLERS
  // =============================================================================

  void _addNewLesson(String moduleName, String title, LessonType type, String? fileName) {
    final modIndex = _modules.indexWhere((m) => m.title.contains(moduleName.split(' — ')[0]));
    if (modIndex != -1) {
      final typeLabel = type == LessonType.liveClass
          ? "Live Class"
          : type == LessonType.video
              ? "Recorded Video"
              : type == LessonType.document
                  ? "PDF Notes"
                  : type == LessonType.quiz
                      ? "Quiz Assessment"
                      : "Assignment";

      final detailLabel = type == LessonType.liveClass ? "10:00 AM" : "15:00";

      final newLesson = Lesson(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        typeText: typeLabel,
        details: fileName ?? detailLabel,
        type: type,
        status: "Published",
        isLocked: false,
      );

      setState(() {
        _modules[modIndex].lessons.add(newLesson);
        _timeline.insert(
          0,
          TimelineLog(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            action: "Added lesson '$title' to ${moduleName.split(' — ')[0]}",
            author: "Super Admin",
            timeAgo: "Just now",
          ),
        );
      });
    }
  }

  void _deleteLesson(String moduleId, String lessonId) {
    final modIdx = _modules.indexWhere((m) => m.id == moduleId);
    if (modIdx != -1) {
      final lessonIdx = _modules[modIdx].lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIdx != -1) {
        final removedName = _modules[modIdx].lessons[lessonIdx].title;
        setState(() {
          _modules[modIdx].lessons.removeAt(lessonIdx);
          _timeline.insert(
            0,
            TimelineLog(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              action: "Deleted lesson '$removedName' from Module ${modIdx + 1}",
              author: "Super Admin",
              timeAgo: "Just now",
            ),
          );
        });
      }
    }
  }

  void _toggleLock(String moduleId, String lessonId) {
    final modIdx = _modules.indexWhere((m) => m.id == moduleId);
    if (modIdx != -1) {
      final lessonIdx = _modules[modIdx].lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIdx != -1) {
        setState(() {
          final isLockedNow = !_modules[modIdx].lessons[lessonIdx].isLocked;
          _modules[modIdx].lessons[lessonIdx].isLocked = isLockedNow;
          
          _timeline.insert(
            0,
            TimelineLog(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              action: "${isLockedNow ? 'Locked' : 'Unlocked'} lesson '${_modules[modIdx].lessons[lessonIdx].title}'",
              author: "Super Admin",
              timeAgo: "Just now",
            ),
          );
        });
      }
    }
  }

  void _renameLesson(String moduleId, String lessonId, String newTitle) {
    final modIdx = _modules.indexWhere((m) => m.id == moduleId);
    if (modIdx != -1) {
      final lessonIdx = _modules[modIdx].lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIdx != -1) {
        setState(() {
          final oldName = _modules[modIdx].lessons[lessonIdx].title;
          _modules[modIdx].lessons[lessonIdx] = _modules[modIdx].lessons[lessonIdx].copyWith(title: newTitle);
          
          _timeline.insert(
            0,
            TimelineLog(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              action: "Renamed lesson from '$oldName' to '$newTitle'",
              author: "Super Admin",
              timeAgo: "Just now",
            ),
          );
        });
      }
    }
  }

  // Helper calculation for subtitle header metrics
  int get _totalLessonsCount {
    int total = 0;
    for (var mod in _modules) {
      total += mod.lessons.length;
    }
    return total;
  }

  // Filter logic
  List<Module> get _filteredModules {
    if (_searchQuery.isEmpty) return _modules;
    
    List<Module> filteredList = [];
    for (var module in _modules) {
      final matchingLessons = module.lessons
          .where((l) => l.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
      
      if (matchingLessons.isNotEmpty || module.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
        filteredList.add(Module(
          id: module.id,
          title: module.title,
          lessons: matchingLessons.isNotEmpty ? matchingLessons : module.lessons,
        ));
      }
    }
    return filteredList;
  }

  // =============================================================================
  // WIDGET BUILDER METHOD
  // =============================================================================

  @override
  Widget build(BuildContext context) {
    // Explicit color styling tokens based on requirements
    final Color scaffoldBg = _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF3F4F6); // Light grey body background
    final Color elementBg = _isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color primaryText = _isDarkMode ? Colors.white : const Color(0xFF1F2937);
    final Color secondaryText = _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF4B5563);
    final Color borderColour = _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

    final showSmall = MediaQuery.of(context).size.width < 1150;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Row(
          children: [
            // 1. LEFT SIDEBAR NAVIGATION
            _buildLeftSidebar(elementBg, primaryText, secondaryText, borderColour),

            // 2. MAIN CONTENT AREA
            Expanded(
              child: Column(
                children: [
                  // Top App Bar
                  _buildTopAppBar(elementBg, primaryText, secondaryText, borderColour, showSmall),

                  // Main Scrollable body (Two-column layout)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 1024;
                          
                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Column (65% width)
                                Expanded(
                                  flex: 65,
                                  child: _buildLeftColumn(elementBg, primaryText, secondaryText, borderColour, false),
                                ),
                                const SizedBox(width: 24),
                                // Right Column (35% width)
                                Expanded(
                                  flex: 35,
                                  child: _buildRightColumn(elementBg, primaryText, secondaryText, borderColour),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildLeftColumn(elementBg, primaryText, secondaryText, borderColour, true),
                                const SizedBox(height: 24),
                                _buildRightColumn(elementBg, primaryText, secondaryText, borderColour),
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
          ],
        ),
      ),
    );
  }

  // =============================================================================
  // PRIVATE HELPER WIDGETS: LEFT SIDEBAR
  // =============================================================================

  Widget _buildLeftSidebar(Color elementBg, Color primaryText, Color secondaryText, Color borderColour) {
    const Color brandBlue = Color(0xFF2563EB); // Small blue text for brand
    const Color highlightColor = Color(0xFFECFDF5); // Bright highlighted bg (Academics highlight)
    const Color highlightText = Color(0xFF047857); // Green text active state

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isSidebarCollapsed ? 70 : 250,
      decoration: BoxDecoration(
        color: elementBg,
        border: Border(right: BorderSide(color: borderColour)),
      ),
      child: Column(
        children: [
          // Header Logo Area
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: _isSidebarCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                // Green logo icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.school, color: Colors.white, size: 20),
                ),
                if (!_isSidebarCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "White Coat",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: primaryText,
                          ),
                        ),
                        Text(
                          "ADMIN PORTAL",
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: brandBlue,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Menu Navigation List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // Section OVERVIEW
                _buildSidebarSectionHeader("OVERVIEW", secondaryText),
                _buildSidebarMenuItem(
                  icon: Icons.dashboard_outlined,
                  label: "Dashboard",
                  isActive: false,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
                
                const SizedBox(height: 16),

                // Section ACADEMICS
                _buildSidebarSectionHeader("ACADEMICS", secondaryText),
                _buildSidebarMenuItem(
                  icon: Icons.people_outline,
                  label: "Students",
                  isActive: false,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
                _buildSidebarMenuItem(
                  icon: Icons.auto_stories_outlined,
                  label: "Courses",
                  isActive: true, // HIGHLIGHTED / ACTIVE STATE
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  highlightBg: highlightColor,
                  highlightFg: highlightText,
                ),
                _buildSidebarMenuItem(
                  icon: Icons.folder_open_outlined,
                  label: "Categories",
                  isActive: false,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
                _buildSidebarMenuItem(
                  icon: Icons.video_library_outlined,
                  label: "Videos",
                  isActive: false,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
                _buildSidebarMenuItem(
                  icon: Icons.ondemand_video,
                  label: "Demo Videos",
                  isActive: false,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
                _buildSidebarMenuItem(
                  icon: Icons.live_tv_outlined,
                  label: "Live Classes",
                  isActive: false,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),

          // Footer Collapse Button
          InkWell(
            onTap: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              child: Row(
                mainAxisAlignment: _isSidebarCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Icon(
                    _isSidebarCollapsed ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                    size: 18,
                    color: secondaryText,
                  ),
                  if (!_isSidebarCollapsed) ...[
                    const SizedBox(width: 12),
                    Text(
                      "Collapse",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarSectionHeader(String title, Color secondaryText) {
    if (_isSidebarCollapsed) return const SizedBox(height: 8);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: secondaryText.withOpacity(0.6),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSidebarMenuItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color primaryText,
    required Color secondaryText,
    Color? highlightBg,
    Color? highlightFg,
  }) {
    final itemFgColor = isActive ? (highlightFg ?? const Color(0xFF10B981)) : secondaryText;
    final itemBgColor = isActive ? (highlightBg ?? const Color(0xFFECFDF5)) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: InkWell(
        onTap: () {
          // Visual navigation state simulation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Routing to: $label"),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: itemBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: _isSidebarCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: itemFgColor),
              if (!_isSidebarCollapsed) ...[
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: itemFgColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================================
  // PRIVATE HELPER WIDGETS: TOP APP BAR
  // =============================================================================

  Widget _buildTopAppBar(
    Color elementBg, 
    Color primaryText, 
    Color secondaryText, 
    Color borderColour,
    bool showInlineSearch,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: elementBg,
        border: Border(bottom: BorderSide(color: borderColour)),
      ),
      child: Row(
        children: [
          // Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Course Details",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Classical Homeopathy Foundations",
                  style: GoogleFonts.inter(
                    color: secondaryText,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Central Search input (Light grey dashboard style)
          if (!showInlineSearch) ...[
            SizedBox(
              width: 320,
              height: 40,
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: GoogleFonts.inter(color: primaryText, fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Search students, courses, payments...",
                  hintStyle: GoogleFonts.inter(color: secondaryText.withOpacity(0.7), fontSize: 13),
                  prefixIcon: Icon(Icons.search, size: 18, color: secondaryText),
                  filled: true,
                  fillColor: _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF3F4F6),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColour),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Dark Mode Toggle Icon (Moon)
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(
              _isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: primaryText,
            ),
            tooltip: 'Toggle Theme Mode',
          ),

          // Notification Bell (With yellow dot indicator)
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Notifications panel opened.")),
                  );
                },
                icon: Icon(Icons.notifications_none_rounded, color: primaryText),
                tooltip: 'Notifications',
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: Colors.amber, // Yellow dot indicator
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          // Chat Icon
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chat messages opened.")),
              );
            },
            icon: Icon(Icons.chat_bubble_outline_rounded, color: primaryText),
            tooltip: 'Chat Messages',
          ),

          const SizedBox(width: 8),

          // User Profile Dropdown chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: elementBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColour),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: const Color(0xFF0F172A),
                  child: Text(
                    "DR",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Dr. Renu Sharma",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                    Text(
                      "Super Admin",
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================================
  // PRIVATE HELPER WIDGETS: LEFT COLUMN (MODULES)
  // =============================================================================

  Widget _buildLeftColumn(
    Color elementBg, 
    Color primaryText, 
    Color secondaryText, 
    Color borderColour,
    bool showInlineSearch,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Header Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Course Content",
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${_modules.length} modules • $_totalLessonsCount lessons • Live Classes, Videos, Notes, Assignments, Quizzes & Resources",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: secondaryText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogCtx) => AddLessonDialog(
                    onAddLesson: (module, title, type, fileName) {
                      _addNewLesson(module, title, type, fileName);
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 14),
              label: Text(
                "Add Lesson",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF10B981), // Bright Dashboard green
                side: const BorderSide(color: Color(0xFF10B981)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        if (showInlineSearch) ...[
          TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            style: GoogleFonts.inter(color: primaryText, fontSize: 13),
            decoration: InputDecoration(
              hintText: "Search students, courses, payments...",
              hintStyle: GoogleFonts.inter(color: secondaryText.withOpacity(0.7), fontSize: 13),
              prefixIcon: Icon(Icons.search, size: 18, color: secondaryText),
              filled: true,
              fillColor: _isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColour),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Render Modules Loop
        if (_filteredModules.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            width: double.infinity,
            decoration: BoxDecoration(
              color: elementBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColour),
            ),
            child: Center(
              child: Text(
                "No lessons found matching standard search.",
                style: GoogleFonts.inter(color: secondaryText, fontSize: 13),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredModules.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, modIdx) {
              final module = _filteredModules[modIdx];
              return _buildModuleCard(module, elementBg, primaryText, secondaryText, borderColour);
            },
          ),
      ],
    );
  }

  Widget _buildModuleCard(
    Module module, 
    Color elementBg, 
    Color primaryText, 
    Color secondaryText, 
    Color borderColour,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: elementBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColour),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Module Header card segment
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    module.title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${module.lessons.length} lessons",
                  style: GoogleFonts.inter(
                    color: secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE5E7EB)), // Faint divider under header

          // Lesson list items builder
          if (module.lessons.isEmpty)
            Padding(
              padding: const EdgeInsets.all(18),
              child: Center(
                child: Text(
                  "No lessons in this module.",
                  style: GoogleFonts.inter(color: secondaryText, fontSize: 12),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: module.lessons.length,
              separatorBuilder: (context, index) => Divider(color: borderColour, height: 1),
              itemBuilder: (context, lessonIdx) {
                final lesson = module.lessons[lessonIdx];
                return _buildLessonRow(module.id, lesson, primaryText, secondaryText, borderColour);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLessonRow(
    String moduleId, 
    Lesson lesson, 
    Color primaryText, 
    Color secondaryText, 
    Color borderColour,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Leading Container box representation
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getLessonIconData(lesson.type),
              color: lesson.type == LessonType.liveClass
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF10B981),
              size: 18,
            ),
          ),
          const SizedBox(width: 14),

          // Title & Subtitle details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "${lesson.typeText} • ${lesson.details}",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Status Badge Pill (Published green dot pill)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF047857),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "Published",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF047857),
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Trailing Action button row controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lock icon (orange/yellow if locked, grey if open)
              IconButton(
                onPressed: () => _toggleLock(moduleId, lesson.id),
                icon: Icon(
                  lesson.isLocked ? Icons.lock : Icons.lock_open,
                  color: lesson.isLocked ? Colors.orange : Colors.grey.shade400,
                ),
                iconSize: 18,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                tooltip: lesson.isLocked ? "Unlock lesson" : "Lock lesson",
              ),
              // Eye icon (View/Preview preview)
              IconButton(
                onPressed: () => _showPreviewMock(lesson),
                icon: Icon(Icons.visibility, color: Colors.blue.shade400),
                iconSize: 18,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                tooltip: "View Preview",
              ),
              // Pencil icon (Edit quick dialog title renaming)
              IconButton(
                onPressed: () => _showEditQuickMock(moduleId, lesson),
                icon: Icon(Icons.edit, color: Colors.green.shade400),
                iconSize: 18,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                tooltip: "Edit Title",
              ),
              // Trash icon (Delete option)
              IconButton(
                onPressed: () => _deleteLesson(moduleId, lesson.id),
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                iconSize: 18,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                tooltip: "Delete Lesson",
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getLessonIconData(LessonType type) {
    switch (type) {
      case LessonType.liveClass:
        return Icons.live_tv_rounded;
      case LessonType.video:
        return Icons.play_arrow_rounded;
      case LessonType.document:
        return Icons.article_outlined;
      case LessonType.quiz:
        return Icons.quiz_outlined;
      case LessonType.assignment:
        return Icons.assignment_outlined;
    }
  }

  // =============================================================================
  // PRIVATE HELPER WIDGETS: RIGHT COLUMN (SIDEBAR CARDS)
  // =============================================================================

  Widget _buildRightColumn(Color elementBg, Color primaryText, Color secondaryText, Color borderColour) {
    return Column(
      children: [
        // Sidebar Card 1: Version History Card
        _buildSidebarCard(
          title: "Version History",
          subtitle: "Last updated 2 hours ago by Dr. Anjali Verma",
          elementBg: elementBg,
          primaryText: primaryText,
          secondaryText: secondaryText,
          borderColour: borderColour,
          child: _buildVersionTimeline(primaryText, secondaryText, borderColour),
        ),

        const SizedBox(height: 24),

        // Sidebar Card 2: Quick Actions Card
        _buildSidebarCard(
          title: "Quick Actions",
          elementBg: elementBg,
          primaryText: primaryText,
          secondaryText: secondaryText,
          borderColour: borderColour,
          child: _buildQuickActions(borderColour),
        ),
      ],
    );
  }

  Widget _buildSidebarCard({
    required String title,
    String? subtitle,
    required Color elementBg,
    required Color primaryText,
    required Color secondaryText,
    required Color borderColour,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: elementBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColour),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: secondaryText,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Divider(color: borderColour),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildVersionTimeline(Color primaryText, Color secondaryText, Color borderColour) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _timeline.length,
      itemBuilder: (context, index) {
        final log = _timeline[index];
        final isLast = index == _timeline.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Connected green dots vertical flow
              Column(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981), // Green dot indicator
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: borderColour,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Text Log Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.action,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${log.author} • ${log.timeAgo}",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(Color borderColour) {
    // Styling colors for delete warning actions explicitly
    const Color lightRedBg = Color(0xFFFEE2E2);
    const Color darkRedText = Color(0xFFB91C1C);

    return Column(
      children: [
        // Button Edit Course (Outlined with Pencil icon)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Opening course editing profile manager...")),
              );
            },
            icon: const Icon(Icons.edit, size: 16),
            label: Text(
              "Edit Course",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _isDarkMode ? Colors.white : Colors.black87,
              side: BorderSide(color: borderColour),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Button Manage Videos (Outlined with Video Camera icon)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Routing to Academics Video Assets panel...")),
              );
            },
            icon: const Icon(Icons.video_camera_back_outlined, size: 16),
            label: Text(
              "Manage Videos",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _isDarkMode ? Colors.white : Colors.black87,
              side: BorderSide(color: borderColour),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Button Delete Course (Solid Light Red background, dark red text, Trash icon)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showDeleteCourseMock(),
            icon: const Icon(Icons.delete_outline_rounded, size: 16, color: darkRedText),
            label: Text(
              "Delete Course",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: darkRedText, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: lightRedBg,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================================
  // ROW ACTIONS INTERACTION POPUPS
  // =============================================================================

  void _showPreviewMock(Lesson lesson) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(lesson.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Type: ${lesson.typeText}",
                style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13),
              ),
              Text(
                "Duration/Pages: ${lesson.details}",
                style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_fill, size: 38, color: Color(0xFF10B981)),
                      SizedBox(height: 8),
                      Text("Simulated Lesson Preview Player"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showEditQuickMock(String moduleId, Lesson lesson) {
    final controller = TextEditingController(text: lesson.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Lesson Title"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter new lesson title",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  _renameLesson(moduleId, lesson.id, controller.text.trim());
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteCourseMock() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete Course?"),
          content: const Text(
            "Warning: This action will permanently remove all lessons and records associated with 'Classical Homeopathy Foundations'. This cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Course deleted simulation complete."),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
