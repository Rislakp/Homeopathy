import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'models/course_model.dart';
import 'providers/course_provider.dart';
import 'widgets/course_card.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const _CourseScreenContent(),
    );
  }
}

class _CourseScreenContent extends StatefulWidget {
  const _CourseScreenContent();

  @override
  State<_CourseScreenContent> createState() => _CourseScreenContentState();
}

class _CourseScreenContentState extends State<_CourseScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "PG Entrance",
    "Clinical",
    "Core Homeopathy",
    "Basic Sciences",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CourseModel> _getFilteredCourses(List<CourseModel> allCourses) {
    return allCourses.where((course) {
      // 1. Filter by category
      if (_selectedCategory != 'All') {
        if (_selectedCategory == 'PG Entrance' &&
            course.category != 'PG Entrance' &&
            course.category != 'Foundation') {
          return false;
        }
        if (_selectedCategory == 'Clinical' &&
            course.category != 'Clinical' &&
            course.category != 'Internship' &&
            course.category != 'Research') {
          return false;
        }
        if (_selectedCategory == 'Core Homeopathy' &&
            course.category != 'Organon' &&
            course.category != 'Materia Medica' &&
            course.category != 'Pharmacy' &&
            course.category != 'Repertory') {
          return false;
        }
        if (_selectedCategory == 'Basic Sciences' &&
            course.category != 'Anatomy' &&
            course.category != 'Physiology' &&
            course.category != 'Pathology') {
          return false;
        }
      }

      // 2. Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = course.title.toLowerCase().contains(query);
        final matchesInstructor = course.instructorName.toLowerCase().contains(
          query,
        );
        final matchesCategory = course.category.toLowerCase().contains(query);
        return matchesTitle || matchesInstructor || matchesCategory;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1200;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Premium Header & Search Area
              _buildHeader(isMobile),

              // 2. Filter Category Chips
              _buildCategoryFilters(isMobile),

              // 3. Grid Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : (isTablet ? 24 : 40),
                  vertical: 24,
                ),
                child: Consumer<CourseProvider>(
                  builder: (context, provider, child) {
                    final filteredCourses = _getFilteredCourses(
                      provider.courses,
                    );

                    if (filteredCourses.isEmpty) {
                      return _buildEmptyState();
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int columns = 3;
                        double imageHeight = 250;
                        double cardBaseHeight =
                            340; // padding + text spaces + info row + button height

                        if (isMobile) {
                          columns = 1;
                          imageHeight = 220;
                        } else if (isTablet) {
                          columns = 2;
                          imageHeight = 240;
                        }

                        // Calculate aspect ratio dynamically to prevent RenderFlex overflow
                        final double gridWidth = constraints.maxWidth;
                        final double gap = 24.0;
                        final double cardWidth =
                            (gridWidth - (gap * (columns - 1))) / columns;
                        final double totalCardHeight = imageHeight + 340;
                        final double childAspectRatio =
                            cardWidth / totalCardHeight;

                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1280),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredCourses.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    mainAxisSpacing: 24,
                                    crossAxisSpacing: 24,
                                    childAspectRatio: childAspectRatio,
                                    mainAxisExtent: imageHeight + 340,
                                  ),
                              itemBuilder: (context, index) {
                                return CourseCard(
                                  course: filteredCourses[index],
                                  imageHeight: imageHeight,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : 48.0,
        vertical: 40.0,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "HOMEOPATHY LEARNING PORTAL",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryGreen,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                "Elevate Your Homoeopathic Clinical & PG Prep Journey",
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: GoogleFonts.outfit(
                  fontSize: isMobile ? 32 : 44,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                "Learn from AIR top rankers and expert clinicians. Comprehensive syllabus coverage, interactive tests, and clinical tips.",
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 32),

              // Search Bar Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search courses, faculty, topics...",
                                hintStyle: GoogleFonts.outfit(
                                  color: AppColors.textLight,
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
        child: Row(
          children: _categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ChoiceChip(
                label: Text(
                  cat,
                  style: GoogleFonts.outfit(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  }
                },
                selectedColor: AppColors.primaryGreen,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : AppColors.border,
                  ),
                ),
                elevation: isSelected ? 4 : 0,
                shadowColor: AppColors.primaryGreen.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.find_in_page_outlined,
            size: 80,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No Courses Found",
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We couldn't find any courses matching your search query or selected filters. Try searching for something else!",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = "";
                _selectedCategory = "All";
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "Reset Filters",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fade in slide up animation wrapper using TweenAnimationBuilder
class _FadeInStaggered extends StatelessWidget {
  final Widget child;
  final int index;

  const _FadeInStaggered({required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0.0, 40.0 * (1.0 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
