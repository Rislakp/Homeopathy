import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class CourseItem {
  final String id;
  final String name;
  final String category;
  final String instructor;
  final String duration;
  final String price;
  final int students;
  final double rating;
  final String status; 
  final String language;
  final IconData thumbnailIcon;
  final Color thumbnailBgColor;

  const CourseItem({
    required this.id,
    required this.name,
    required this.category,
    required this.instructor,
    required this.duration,
    required this.price,
    required this.students,
    required this.rating,
    required this.status,
    this.language = 'English',
    required this.thumbnailIcon,
    this.thumbnailBgColor = const Color(0xFF16A34A),
  });
}

class CourseStat {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const CourseStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

class ActivityLog {
  final String text;
  final String time;
  final IconData icon;

  const ActivityLog({
    required this.text,
    required this.time,
    required this.icon,
  });
}

// ============================================================================
// STATE MANAGEMENT (PROVIDER)
// ============================================================================

class CourseManagementNotifier extends ChangeNotifier {
  String searchQuery = '';
  String selectedCategory = 'All Categories';
  String selectedInstructor = 'All Instructors';
  String selectedStatus = 'All Status';
  String selectedLanguage = 'All Languages';
  String selectedSort = 'Newest';

  final List<String> categories = [
    'All Categories',
    'Materia Medica',
    'Organon',
    'Pharmacy',
    'Clinical',
    'Anatomy',
  ];

  final List<String> instructors = [
    'All Instructors',
    'Dr. Renu Sharma',
    'Dr. Arjun',
    'Dr. Meera',
    'Dr. Ahmed',
  ];

  final List<String> statuses = ['All Status', 'Published', 'Draft'];
  final List<String> languages = ['All Languages', 'English', 'Hindi', 'Bilingual'];
  final List<String> sortOptions = ['Newest', 'Popularity', 'Rating', 'Price: Low to High'];

  final List<CourseItem> _courses = [
    const CourseItem(
      id: 'WCA-01',
      name: 'Advanced Materia Medica',
      category: 'Materia Medica',
      instructor: 'Dr. Renu Sharma',
      duration: '32 Hours',
      price: '₹2,499',
      students: 425,
      rating: 4.9,
      status: 'Published',
      thumbnailIcon: Icons.menu_book_rounded,
      thumbnailBgColor: Color(0xFF16A34A),
    ),
    const CourseItem(
      id: 'WCA-02',
      name: 'Organon of Medicine',
      category: 'Organon',
      instructor: 'Dr. Arjun',
      duration: '28 Hours',
      price: '₹1,999',
      students: 312,
      rating: 4.8,
      status: 'Published',
      thumbnailIcon: Icons.psychology_rounded,
      thumbnailBgColor: Color(0xFF2563EB),
    ),
    const CourseItem(
      id: 'WCA-03',
      name: 'Homeopathic Pharmacy',
      category: 'Pharmacy',
      instructor: 'Dr. Meera',
      duration: '18 Hours',
      price: '₹999',
      students: 208,
      rating: 4.6,
      status: 'Draft',
      thumbnailIcon: Icons.science_rounded,
      thumbnailBgColor: Color(0xFFD97706),
    ),
    const CourseItem(
      id: 'WCA-04',
      name: 'Case Studies & Therapeutics',
      category: 'Clinical',
      instructor: 'Dr. Ahmed',
      duration: '40 Hours',
      price: '₹2,999',
      students: 520,
      rating: 4.9,
      status: 'Published',
      thumbnailIcon: Icons.medical_services_rounded,
      thumbnailBgColor: Color(0xFF9333EA),
    ),
  ];

  final List<ActivityLog> activities = const [
    ActivityLog(text: 'New course "Advanced Materia Medica" added', time: '12 mins ago', icon: Icons.add_circle_outline_rounded),
    ActivityLog(text: 'Course "Organon of Medicine" updated', time: '1 hour ago', icon: Icons.edit_note_rounded),
    ActivityLog(text: 'Draft "Homeopathic Pharmacy" awaiting approval', time: '3 hours ago', icon: Icons.pending_actions_rounded),
    ActivityLog(text: 'New instructor Dr. Ahmed assigned', time: '5 hours ago', icon: Icons.person_add_alt_1_rounded),
  ];

  List<CourseItem> get filteredCourses {
    return _courses.where((c) {
      final matchSearch = searchQuery.isEmpty ||
          c.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          c.instructor.toLowerCase().contains(searchQuery.toLowerCase());
      final matchCat = selectedCategory == 'All Categories' || c.category == selectedCategory;
      final matchInst = selectedInstructor == 'All Instructors' || c.instructor == selectedInstructor;
      final matchStatus = selectedStatus == 'All Status' || c.status == selectedStatus;
      final matchLang = selectedLanguage == 'All Languages' || c.language == selectedLanguage;

      return matchSearch && matchCat && matchInst && matchStatus && matchLang;
    }).toList();
  }

  void setSearch(String val) { searchQuery = val; notifyListeners(); }
  void setCategory(String val) { selectedCategory = val; notifyListeners(); }
  void setInstructor(String val) { selectedInstructor = val; notifyListeners(); }
  void setStatus(String val) { selectedStatus = val; notifyListeners(); }
  void setLanguage(String val) { selectedLanguage = val; notifyListeners(); }
  void setSort(String val) { selectedSort = val; notifyListeners(); }
  void addCourse(CourseItem item) { _courses.insert(0, item); notifyListeners(); }
  void deleteCourse(String id) { _courses.removeWhere((c) => c.id == id); notifyListeners(); }
}

// ============================================================================
// STANDALONE COURSE MANAGEMENT CONTENT PAGE (NO SIDEBAR / TOP NAVBAR WRAPPER)
// ============================================================================

class CourseManagementPage extends StatelessWidget {
  const CourseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseManagementNotifier(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Page Header (Title, Subtitle, + Add Course, Import, Export)
                const _CourseHeaderSection(),
                const SizedBox(height: 24),

                // 2. Statistics Cards (Total Courses: 148, Published: 126, Draft: 22, Enrollments: 4,875)
                const _CourseStatCardsSection(),
                const SizedBox(height: 24),

                // 3. Filter Section (Search, Category, Instructor, Status, Language, Sort By)
                const _CourseFilterBarSection(),
                const SizedBox(height: 24),

                // 4. Main Course Table & Recent Activity Panel
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 1150) {
                      return const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _CourseTableSection()),
                          SizedBox(width: 24),
                          Expanded(flex: 1, child: _CourseActivityFeedSection()),
                        ],
                      );
                    } else {
                      return const Column(
                        children: [
                          _CourseTableSection(),
                          SizedBox(height: 24),
                          _CourseActivityFeedSection(),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 1. PAGE HEADER SECTION
// ----------------------------------------------------------------------------

class _CourseHeaderSection extends StatelessWidget {
  const _CourseHeaderSection();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CourseManagementNotifier>();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 16),
              _buildActions(context, notifier),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildTitle()),
              _buildActions(context, notifier),
            ],
          );
  }

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course Management',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.6,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Manage all academy courses, pricing, instructors, and publishing.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, CourseManagementNotifier notifier) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFF475569)),
          label: const Text('Export', style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w600, fontSize: 13)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.file_upload_outlined, size: 18, color: Color(0xFF475569)),
          label: const Text('Import Courses', style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w600, fontSize: 13)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () => _showAddCourseDialog(context, notifier),
          icon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
          label: const Text('+ Add Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF16A34A),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  void _showAddCourseDialog(BuildContext context, CourseManagementNotifier notifier) {
    final titleCtrl = TextEditingController();
    final instCtrl = TextEditingController(text: 'Dr. Renu Sharma');
    final durCtrl = TextEditingController(text: '30 Hours');
    final priceCtrl = TextEditingController(text: '₹2,499');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Add New Course', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Course Name')),
            const SizedBox(height: 10),
            TextField(controller: instCtrl, decoration: const InputDecoration(labelText: 'Instructor')),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: durCtrl, decoration: const InputDecoration(labelText: 'Duration'))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price'))),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A)),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                notifier.addCourse(CourseItem(
                  id: 'WCA-${DateTime.now().millisecondsSinceEpoch}',
                  name: titleCtrl.text.trim(),
                  category: 'Materia Medica',
                  instructor: instCtrl.text.trim(),
                  duration: durCtrl.text.trim(),
                  price: priceCtrl.text.trim(),
                  students: 120,
                  rating: 5.0,
                  status: 'Published',
                  thumbnailIcon: Icons.menu_book_rounded,
                  thumbnailBgColor: const Color(0xFF16A34A),
                ));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 2. STATISTICS CARDS SECTION (4 CARDS)
// ----------------------------------------------------------------------------

class _CourseStatCardsSection extends StatelessWidget {
  const _CourseStatCardsSection();

  @override
  Widget build(BuildContext context) {
    final stats = [
      const CourseStat(title: 'Total Courses', value: '148', icon: Icons.menu_book_rounded, iconColor: Color(0xFF16A34A), iconBgColor: Color(0xFFDCFCE7)),
      const CourseStat(title: 'Published', value: '126', icon: Icons.check_circle_rounded, iconColor: Color(0xFF2563EB), iconBgColor: Color(0xFFDBEAFE)),
      const CourseStat(title: 'Draft', value: '22', icon: Icons.description_rounded, iconColor: Color(0xFFD97706), iconBgColor: Color(0xFFFEF3C7)),
      const CourseStat(title: 'Enrollments', value: '4,875', icon: Icons.people_rounded, iconColor: Color(0xFF9333EA), iconBgColor: Color(0xFFF3E8FF)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth < 640) crossAxisCount = 1;
        else if (constraints.maxWidth < 1024) crossAxisCount = 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: constraints.maxWidth < 640 ? 2.4 : 2.0,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final s = stats[index];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: s.iconBgColor, borderRadius: BorderRadius.circular(14)),
                    child: Icon(s.icon, color: s.iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.title, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(s.value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ----------------------------------------------------------------------------
// 3. FILTER BAR SECTION
// ----------------------------------------------------------------------------

class _CourseFilterBarSection extends StatelessWidget {
  const _CourseFilterBarSection();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CourseManagementNotifier>();
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: isMobile
          ? Column(
              children: [
                _buildSearch(notifier),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildDrop('Category', notifier.selectedCategory, notifier.categories, notifier.setCategory),
                    _buildDrop('Instructor', notifier.selectedInstructor, notifier.instructors, notifier.setInstructor),
                    _buildDrop('Status', notifier.selectedStatus, notifier.statuses, notifier.setStatus),
                    _buildDrop('Language', notifier.selectedLanguage, notifier.languages, notifier.setLanguage),
                    _buildDrop('Sort By', notifier.selectedSort, notifier.sortOptions, notifier.setSort),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 3, child: _buildSearch(notifier)),
                const SizedBox(width: 12),
                _buildDrop('Category', notifier.selectedCategory, notifier.categories, notifier.setCategory),
                const SizedBox(width: 8),
                _buildDrop('Instructor', notifier.selectedInstructor, notifier.instructors, notifier.setInstructor),
                const SizedBox(width: 8),
                _buildDrop('Status', notifier.selectedStatus, notifier.statuses, notifier.setStatus),
                const SizedBox(width: 8),
                _buildDrop('Language', notifier.selectedLanguage, notifier.languages, notifier.setLanguage),
                const SizedBox(width: 8),
                _buildDrop('Sort By', notifier.selectedSort, notifier.sortOptions, notifier.setSort),
              ],
            ),
    );
  }

  Widget _buildSearch(CourseManagementNotifier notifier) {
    return SizedBox(
      height: 42,
      child: TextField(
        onChanged: notifier.setSearch,
        decoration: InputDecoration(
          hintText: 'Search Courses...',
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF16A34A), width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildDrop(String label, String value, List<String> items, ValueChanged<String> onChanged) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 18),
          style: const TextStyle(color: Color(0xFF334155), fontSize: 13, fontWeight: FontWeight.w600),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 4. COURSE TABLE SECTION
// ----------------------------------------------------------------------------

class _CourseTableSection extends StatelessWidget {
  const _CourseTableSection();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CourseManagementNotifier>();
    final courses = notifier.filteredCourses;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 320),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
              horizontalMargin: 20,
              columnSpacing: 24,
              dataRowMaxHeight: 68,
              columns: const [
                DataColumn(label: Text('THUMBNAIL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('COURSE NAME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('INSTRUCTOR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('DURATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('PRICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('STUDENTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('RATING', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
              ],
              rows: courses.map((course) {
                final isPublished = course.status == 'Published';
                return DataRow(
                  cells: [
                    DataCell(Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: course.thumbnailBgColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                      child: Icon(course.thumbnailIcon, color: course.thumbnailBgColor, size: 22),
                    )),
                    DataCell(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                        Text(course.id, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                      ],
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                      child: Text(course.category, style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                    )),
                    DataCell(Text(course.instructor, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF334155)))),
                    DataCell(Text(course.duration, style: const TextStyle(fontSize: 13, color: Color(0xFF475569)))),
                    DataCell(Text(course.price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)))),
                    DataCell(Text('${course.students}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)))),
                    DataCell(Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        Text('${course.rating}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPublished ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: BoxDecoration(color: isPublished ? const Color(0xFF16A34A) : const Color(0xFFD97706), shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(course.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isPublished ? const Color(0xFF15803D) : const Color(0xFFB45309))),
                        ],
                      ),
                    )),
                    DataCell(PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF64748B), size: 20),
                      onSelected: (val) {
                        if (val == 'delete') notifier.deleteCourse(course.id);
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'view', child: Text('View')),
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 5. RECENT ACTIVITY FEED SECTION
// ----------------------------------------------------------------------------

class _CourseActivityFeedSection extends StatelessWidget {
  const _CourseActivityFeedSection();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CourseManagementNotifier>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifier.activities.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final act = notifier.activities[index];
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                    child: Icon(act.icon, size: 16, color: const Color(0xFF16A34A)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(act.text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
                        Text(act.time, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
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
}
