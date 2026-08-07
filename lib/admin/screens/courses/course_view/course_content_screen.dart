import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeopathy/utils/app_colors.dart';
import 'add_lessons/add_lesson_dialog.dart';

// =============================================================================
// MODELS
// =============================================================================

enum LessonType { video, document, liveClass, quiz, assignment }

class LessonItem {
  final String id;
  final String title;
  final LessonType type;
  final String durationText; // E.g., "Recorded Video • 14:20"
  final String status; // "Published", "Draft"
  final bool isLocked;

  LessonItem({
    required this.id,
    required this.title,
    required this.type,
    required this.durationText,
    required this.status,
    this.isLocked = false,
  });

  LessonItem copyWith({
    String? id,
    String? title,
    LessonType? type,
    String? durationText,
    String? status,
    bool? isLocked,
  }) {
    return LessonItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      durationText: durationText ?? this.durationText,
      status: status ?? this.status,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class ModuleContent {
  final String id;
  final String title;
  final List<LessonItem> lessons;

  ModuleContent({
    required this.id,
    required this.title,
    required this.lessons,
  });
}

class TimelineItem {
  final String id;
  final String action;
  final String author;
  final String timeAgo;

  TimelineItem({
    required this.id,
    required this.action,
    required this.author,
    required this.timeAgo,
  });
}

// =============================================================================
// PROVIDER STATE MANAGEMENT
// =============================================================================

class CourseContentProvider extends ChangeNotifier {
  // Mock modules matching UI description
  final List<ModuleContent> _modules = [
    ModuleContent(
      id: "mod-1",
      title: "Module 1 — Introduction to Classical Homeopathy",
      lessons: [
        LessonItem(
          id: "les-1-1",
          title: "History & Origins of Homeopathic Medicine",
          type: LessonType.video,
          durationText: "Recorded Video • 14:20",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-1-2",
          title: "The Law of Similars (Similia Similibus Curentur)",
          type: LessonType.video,
          durationText: "Recorded Video • 22:45",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-1-3",
          title: "Vital Force and Health Dynamics",
          type: LessonType.liveClass,
          durationText: "Live Class • 45:00",
          status: "Published",
          isLocked: true,
        ),
        LessonItem(
          id: "les-1-4",
          title: "Hahnemannian Philosophy Lecture Notes",
          type: LessonType.document,
          durationText: "PDF Notes • 12 pages",
          status: "Published",
          isLocked: false,
        ),
      ],
    ),
    ModuleContent(
      id: "mod-2",
      title: "Module 2 — Homeopathic Posology & Potency",
      lessons: [
        LessonItem(
          id: "les-2-1",
          title: "Concept of Drug Dynamisation & Potentisation",
          type: LessonType.video,
          durationText: "Recorded Video • 18:30",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-2-2",
          title: "The Scale of Potencies: Decimal, Centesimal & LM",
          type: LessonType.video,
          durationText: "Recorded Video • 25:10",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-2-3",
          title: "Selection of Potency & Dose Repetition",
          type: LessonType.liveClass,
          durationText: "Live Class • 10:00 AM",
          status: "Published",
          isLocked: true,
        ),
        LessonItem(
          id: "les-2-4",
          title: "Materia Medica Study Guide (Aconitum & Belladonna)",
          type: LessonType.document,
          durationText: "PDF Notes • 6 pages",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-2-5",
          title: "Potency Selection Practical Assessment",
          type: LessonType.quiz,
          durationText: "Quiz Assessment • 10 Qs",
          status: "Published",
          isLocked: false,
        ),
      ],
    ),
    ModuleContent(
      id: "mod-3",
      title: "Module 3 — Organon of Medicine Analysis",
      lessons: [
        LessonItem(
          id: "les-3-1",
          title: "Aphorisms 1 to 20: The Mission of Physician",
          type: LessonType.video,
          durationText: "Recorded Video • 35:15",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-3-2",
          title: "Understanding Healing Principles & Law of Cure",
          type: LessonType.liveClass,
          durationText: "Live Class • 3:00 PM",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-3-3",
          title: "Organon Introduction Study Guides",
          type: LessonType.document,
          durationText: "PDF Notes • 15 pages",
          status: "Published",
          isLocked: false,
        ),
      ],
    ),
    ModuleContent(
      id: "mod-4",
      title: "Module 4 — Theory of Miasms & Chronic Disease",
      lessons: [
        LessonItem(
          id: "les-4-1",
          title: "Hahnemann's Concept of Chronic Miasms",
          type: LessonType.video,
          durationText: "Recorded Video • 40:00",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-4-2",
          title: "Psora - The Mother of All True Chronic Diseases",
          type: LessonType.video,
          durationText: "Recorded Video • 32:20",
          status: "Published",
          isLocked: true,
        ),
        LessonItem(
          id: "les-4-3",
          title: "Sycosis (The Hydremoid State) Case Analyses",
          type: LessonType.liveClass,
          durationText: "Live Class • 11:30 AM",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-4-4",
          title: "Sypilitic Miasm & Chronic Treatment Methods",
          type: LessonType.assignment,
          durationText: "Assignment • Case study PDF",
          status: "Published",
          isLocked: false,
        ),
      ],
    ),
    ModuleContent(
      id: "mod-5",
      title: "Module 5 — Case Taking Methodology",
      lessons: [
        LessonItem(
          id: "les-5-1",
          title: "Art of Homeopathic Case Taking (§83-104)",
          type: LessonType.video,
          durationText: "Recorded Video • 28:45",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-5-2",
          title: "Eliciting Symptoms: Subjective vs Objective",
          type: LessonType.liveClass,
          durationText: "Live Class • 5:00 PM",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-5-3",
          title: "Case Taking Template & Questionnaires",
          type: LessonType.document,
          durationText: "PDF Notes • 4 pages",
          status: "Published",
          isLocked: false,
        ),
      ],
    ),
    ModuleContent(
      id: "mod-6",
      title: "Module 6 — Repertorization Foundations",
      lessons: [
        LessonItem(
          id: "les-6-1",
          title: "Evolution of Repertory & Symptom Valuation",
          type: LessonType.video,
          durationText: "Recorded Video • 26:12",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-6-2",
          title: "Introduction to Kent's Repertory structure",
          type: LessonType.video,
          durationText: "Recorded Video • 31:40",
          status: "Published",
          isLocked: false,
        ),
        LessonItem(
          id: "les-6-3",
          title: "Case Rubric Selection Exercises",
          type: LessonType.liveClass,
          durationText: "Live Class • 2:00 PM",
          status: "Published",
          isLocked: true,
        ),
        LessonItem(
          id: "les-6-4",
          title: "Final Case Rubric Sheet",
          type: LessonType.document,
          durationText: "PDF Notes • 10 pages",
          status: "Published",
          isLocked: false,
        ),
      ],
    ),
  ];

  // Timeline logs (mock data)
  final List<TimelineItem> _timeline = [
    TimelineItem(
      id: "log-1",
      action: "Replaced lesson video and updated duration",
      author: "Dr. Anjali Verma",
      timeAgo: "2 hours ago",
    ),
    TimelineItem(
      id: "log-2",
      action: "Published Module 6: Repertorization Foundations",
      author: "Super Admin",
      timeAgo: "1 day ago",
    ),
    TimelineItem(
      id: "log-3",
      action: "Added Live Class schedules to Module 3 Organon",
      author: "Dr. Anjali Verma",
      timeAgo: "3 days ago",
    ),
    TimelineItem(
      id: "log-4",
      action: "Initial curriculum syllabus draft uploaded",
      author: "Super Admin",
      timeAgo: "1 week ago",
    ),
  ];

  // Interactivity States
  bool _isDarkMode = false;
  String _searchQuery = "";

  // Getters
  List<ModuleContent> get modules => _modules;
  List<TimelineItem> get timeline => _timeline;
  bool get isDarkMode => _isDarkMode;
  String get searchQuery => _searchQuery;

  int get totalLessonsCount {
    int total = 0;
    for (var module in _modules) {
      total += module.lessons.length;
    }
    return total;
  }

  // Filtered modules based on search query
  List<ModuleContent> get filteredModules {
    if (_searchQuery.isEmpty) return _modules;
    
    List<ModuleContent> filteredList = [];
    for (var module in _modules) {
      final matchingLessons = module.lessons
          .where((l) => l.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
      
      if (matchingLessons.isNotEmpty || module.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
        filteredList.add(ModuleContent(
          id: module.id,
          title: module.title,
          lessons: matchingLessons.isNotEmpty ? matchingLessons : module.lessons,
        ));
      }
    }
    return filteredList;
  }

  // Actions
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addLesson(String moduleId, LessonItem lesson) {
    final modIndex = _modules.indexWhere((m) => m.id == moduleId);
    if (modIndex != -1) {
      _modules[modIndex].lessons.add(lesson);
      
      // Auto-append dynamic timeline log
      _timeline.insert(0, TimelineItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        action: "Added lesson '${lesson.title}' to ${ _modules[modIndex].title.split(' — ')[0]}",
        author: "Super Admin",
        timeAgo: "Just now",
      ));
      
      notifyListeners();
    }
  }

  void deleteLesson(String moduleId, String lessonId) {
    final modIndex = _modules.indexWhere((m) => m.id == moduleId);
    if (modIndex != -1) {
      final lessonIndex = _modules[modIndex].lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex != -1) {
        final removedLessonName = _modules[modIndex].lessons[lessonIndex].title;
        _modules[modIndex].lessons.removeAt(lessonIndex);
        
        // Log delete in version history
        _timeline.insert(0, TimelineItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          action: "Deleted lesson '$removedLessonName' from ${_modules[modIndex].title.split(' — ')[0]}",
          author: "Super Admin",
          timeAgo: "Just now",
        ));
        
        notifyListeners();
      }
    }
  }

  void toggleLock(String moduleId, String lessonId) {
    final modIndex = _modules.indexWhere((m) => m.id == moduleId);
    if (modIndex != -1) {
      final lessonIndex = _modules[modIndex].lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex != -1) {
        final lesson = _modules[modIndex].lessons[lessonIndex];
        final newLockedState = !lesson.isLocked;
        
        _modules[modIndex].lessons[lessonIndex] = lesson.copyWith(isLocked: newLockedState);
        
        // Log locked status update in history
        _timeline.insert(0, TimelineItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          action: "${newLockedState ? 'Locked' : 'Unlocked'} lesson '${lesson.title}'",
          author: "Super Admin",
          timeAgo: "Just now",
        ));

        notifyListeners();
      }
    }
  }

  void renameLesson(String moduleId, String lessonId, String newTitle) {
    final modIndex = _modules.indexWhere((m) => m.id == moduleId);
    if (modIndex != -1) {
      final lessonIndex = _modules[modIndex].lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex != -1) {
        final lesson = _modules[modIndex].lessons[lessonIndex];
        _modules[modIndex].lessons[lessonIndex] = lesson.copyWith(title: newTitle);
        
        // Log rename update in version history
        _timeline.insert(0, TimelineItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          action: "Renamed lesson to '$newTitle'",
          author: "Super Admin",
          timeAgo: "Just now",
        ));

        notifyListeners();
      }
    }
  }
}

// =============================================================================
// MAIN VIEW SCREEN
// =============================================================================

class CourseContentScreen extends StatelessWidget {
  const CourseContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseContentProvider(),
      child: Consumer<CourseContentProvider>(
        builder: (context, provider, child) {
          final isDark = provider.isDarkMode;
          
          final scaffoldBgColor = isDark 
              ? const Color(0xFF0F172A) 
              : AppColors.background;
          
          final cardBgColor = isDark 
              ? const Color(0xFF1E293B) 
              : AppColors.surface;
          
          final primaryTextColor = isDark 
              ? Colors.white 
              : AppColors.textPrimary;
          
          final secondaryTextColor = isDark 
              ? const Color(0xFF94A3B8) 
              : AppColors.textSecondary;
          
          final borderColor = isDark 
              ? const Color(0xFF334155) 
              : AppColors.border;

          final dividerColor = isDark 
              ? const Color(0xFF334155) 
              : AppColors.divider;

          return Scaffold(
            backgroundColor: scaffoldBgColor,
            body: SafeArea(
              child: Column(
                children: [
                  // Top Navigation Bar
                  _buildTopBar(context, provider, cardBgColor, primaryTextColor, secondaryTextColor, borderColor),
                  
                  // Main Body
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
                                // Left Column (65%)
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
                                // Right Column (35%)
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
                                  true,
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
  // UI WIDGET: TOP BAR
  // =============================================================================

  Widget _buildTopBar(
    BuildContext context,
    CourseContentProvider provider,
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
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: primaryTextColor),
            tooltip: 'Back',
          ),
          const SizedBox(width: 8),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Course Content Manager",
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

          // Central Search input
          if (!showSmall) ...[
            SizedBox(
              width: 280,
              height: 40,
              child: TextField(
                onChanged: provider.updateSearchQuery,
                style: GoogleFonts.inter(color: primaryTextColor, fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Search content...",
                  hintStyle: GoogleFonts.inter(color: secondaryTextColor, fontSize: 13),
                  prefixIcon: Icon(Icons.search, size: 18, color: secondaryTextColor),
                  filled: true,
                  fillColor: provider.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],

          IconButton(
            onPressed: provider.toggleDarkMode,
            icon: Icon(
              provider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: primaryTextColor,
            ),
            tooltip: 'Toggle Theme',
          ),

          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Syncing curriculum items to live server...", style: GoogleFonts.inter()),
                  behavior: SnackBarBehavior.floating,
                  width: 300,
                ),
              );
            },
            icon: Icon(Icons.sync_rounded, color: primaryTextColor),
            tooltip: 'Sync Changes',
          ),

          if (!isMobile) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primaryDark,
                    child: Text(
                      "DR",
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Dr. Renu Sharma",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: primaryTextColor),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =============================================================================
  // UI WIDGET: LEFT COLUMN
  // =============================================================================

  Widget _buildLeftColumn(
    BuildContext context,
    CourseContentProvider provider,
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
        // 1. Title section
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
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${provider.modules.length} modules • ${provider.totalLessonsCount} lessons • Live Classes, Videos, Notes, Assignments, Quizzes & Resources",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: secondaryTextColor,
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
                  builder: (dialogCtx) => ChangeNotifierProvider.value(
                    value: provider,
                    child: const AddLessonDialog(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 16),
              label: Text("Add Lesson", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        if (showInlineSearch) ...[
          TextField(
            onChanged: provider.updateSearchQuery,
            style: GoogleFonts.inter(color: primaryTextColor, fontSize: 13),
            decoration: InputDecoration(
              hintText: "Search content...",
              hintStyle: GoogleFonts.inter(color: secondaryTextColor, fontSize: 13),
              prefixIcon: Icon(Icons.search, size: 18, color: secondaryTextColor),
              filled: true,
              fillColor: provider.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // 2. Modules list
        if (provider.filteredModules.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            width: double.infinity,
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: Text(
                "No lessons found matching search criteria.",
                style: GoogleFonts.inter(color: secondaryTextColor),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.filteredModules.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final module = provider.filteredModules[index];
              return Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                  boxShadow: provider.isDarkMode ? [] : AppColors.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Module Header Card Segment
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: provider.isDarkMode ? const Color(0xFF2E3B4E) : const Color(0xFFF8FAFC),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border(bottom: BorderSide(color: borderColor)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              module.title,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${module.lessons.length} lessons",
                            style: GoogleFonts.inter(
                              color: secondaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Lessons inside module list
                    if (module.lessons.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            "No lessons in this module.",
                            style: GoogleFonts.inter(color: secondaryTextColor, fontSize: 13),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: module.lessons.length,
                        separatorBuilder: (context, index) => Divider(color: dividerColor, height: 1),
                        itemBuilder: (context, lessonIdx) {
                          final lesson = module.lessons[lessonIdx];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                // Icon Box Container
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: provider.isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _getLessonIcon(lesson.type),
                                    color: lesson.type == LessonType.liveClass 
                                        ? const Color(0xFFEF4444) 
                                        : AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Title & Subtitle Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lesson.title,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        lesson.durationText,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Status Badge
                                _buildStatusBadge(lesson.status),
                                const SizedBox(width: 16),

                                // Actions Bar Row
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Lock Action
                                    IconButton(
                                      onPressed: () {
                                        provider.toggleLock(module.id, lesson.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Lesson '${lesson.title}' ${!lesson.isLocked ? 'locked' : 'unlocked'}.",
                                              style: GoogleFonts.inter(),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            width: 300,
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        lesson.isLocked ? Icons.lock : Icons.lock_open,
                                        color: lesson.isLocked ? Colors.orange : Colors.grey,
                                      ),
                                      iconSize: 18,
                                      tooltip: lesson.isLocked ? "Unlock Lesson" : "Lock Lesson",
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(8),
                                    ),

                                    // View Action
                                    IconButton(
                                      onPressed: () {
                                        _showPreviewDialog(context, lesson, provider.isDarkMode);
                                      },
                                      icon: const Icon(Icons.visibility, color: Colors.blue),
                                      iconSize: 18,
                                      tooltip: "Preview Lesson",
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(8),
                                    ),

                                    // Edit Action
                                    IconButton(
                                      onPressed: () {
                                        _showEditQuickDialog(context, module.id, lesson, provider);
                                      },
                                      icon: const Icon(Icons.edit, color: Colors.green),
                                      iconSize: 18,
                                      tooltip: "Edit Title",
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(8),
                                    ),

                                    // Delete Action
                                    IconButton(
                                      onPressed: () {
                                        provider.deleteLesson(module.id, lesson.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Lesson '${lesson.title}' deleted successfully.", style: GoogleFonts.inter()),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                            width: 320,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      iconSize: 18,
                                      tooltip: "Delete Lesson",
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(8),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
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
  // UI WIDGET: RIGHT COLUMN (SIDEBAR)
  // =============================================================================

  Widget _buildRightColumn(
    BuildContext context,
    CourseContentProvider provider,
    Color cardBgColor,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color borderColor,
    Color dividerColor,
  ) {
    return Column(
      children: [
        // 1. Version History Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 6),
              Text(
                "Last updated 2 hours ago by Dr. Anjali Verma",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: secondaryTextColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: dividerColor),
              const SizedBox(height: 16),
              
              // Timeline List Builder
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.timeline.length,
                itemBuilder: (context, index) {
                  final item = provider.timeline[index];
                  final isLast = index == provider.timeline.length - 1;
                  
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Timeline dot and connecting vertical line
                        Column(
                          children: [
                            Container(
                              height: 12,
                              width: 12,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981), // Green dot
                                shape: BoxShape.circle,
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: dividerColor,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        
                        // Timeline Content Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.action,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${item.author} • ${item.timeAgo}",
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: secondaryTextColor,
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
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 2. Quick Actions Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: provider.isDarkMode ? [] : AppColors.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quick Actions",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              
              // Edit Course Outlined Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Routing to Course Editor...", style: GoogleFonts.inter())),
                    );
                  },
                  icon: Icon(Icons.edit, size: 16, color: primaryTextColor),
                  label: Text("Edit Course", style: GoogleFonts.inter(color: primaryTextColor, fontWeight: FontWeight.bold, fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Manage Videos Outlined Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Opening Video Library Manager...", style: GoogleFonts.inter())),
                    );
                  },
                  icon: Icon(Icons.video_library_rounded, size: 16, color: primaryTextColor),
                  label: Text("Manage Videos", style: GoogleFonts.inter(color: primaryTextColor, fontWeight: FontWeight.bold, fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Delete Course Solid Light Red Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showDeleteCourseDialog(context);
                  },
                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFB91C1C)),
                  label: Text(
                    "Delete Course",
                    style: GoogleFonts.inter(
                      color: const Color(0xFFB91C1C),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE2E2),
                    foregroundColor: const Color(0xFFB91C1C),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =============================================================================
  // HELPER SUB-METHODS
  // =============================================================================

  IconData _getLessonIcon(LessonType type) {
    switch (type) {
      case LessonType.video:
        return Icons.play_circle_outline_rounded;
      case LessonType.document:
        return Icons.article_outlined;
      case LessonType.liveClass:
        return Icons.live_tv_rounded;
      case LessonType.quiz:
        return Icons.quiz_outlined;
      case LessonType.assignment:
        return Icons.assignment_outlined;
    }
  }

  Widget _buildStatusBadge(String status) {
    final isPublished = status.toLowerCase() == "published";
    final bg = isPublished ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7);
    final fg = isPublished ? const Color(0xFF047857) : const Color(0xFFB45309);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: GoogleFonts.inter(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Preview Info Dialog
  void _showPreviewDialog(BuildContext context, LessonItem lesson, bool isDark) {
    showDialog(
      context: context,
      builder: (context) {
        final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? Colors.white : AppColors.textPrimary;
        final secColor = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;

        return AlertDialog(
          backgroundColor: dialogBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Lesson Preview", style: GoogleFonts.inter(color: textColor, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.title,
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 8),
              Text(
                "Format: ${lesson.durationText}",
                style: GoogleFonts.inter(color: secColor, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_getLessonIcon(lesson.type), size: 40, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text(
                        "Preview Player Mockup",
                        style: GoogleFonts.inter(color: secColor, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Dismiss", style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Delete warning dialog
  void _showDeleteCourseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Entire Course?"),
          content: const Text(
            "Warning: This action is irreversible. All modules, recordings, assessments, and logs related to 'Classical Homeopathy Foundations' will be permanently removed from the system.",
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
                    content: Text("Course deletion simulation performed successfully!"),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Confirm Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Edit title quick dialog
  void _showEditQuickDialog(
    BuildContext context,
    String moduleId,
    LessonItem lesson,
    CourseContentProvider provider,
  ) {
    final titleController = TextEditingController(text: lesson.title);
    
    showDialog(
      context: context,
      builder: (context) {
        final isDark = provider.isDarkMode;
        final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? Colors.white : AppColors.textPrimary;
        final border = BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
        final fieldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

        return AlertDialog(
          backgroundColor: dialogBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Edit Lesson Title", style: GoogleFonts.inter(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
          content: TextField(
            controller: titleController,
            style: GoogleFonts.inter(color: textColor),
            decoration: InputDecoration(
              filled: true,
              fillColor: fieldBg,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: border,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.inter(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  provider.renameLesson(
                    moduleId,
                    lesson.id,
                    titleController.text.trim(),
                  );
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Lesson title renamed successfully!", style: GoogleFonts.inter()),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text("Save", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
