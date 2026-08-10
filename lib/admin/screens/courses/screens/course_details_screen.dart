import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../models/course_details_model.dart';
import '../../../providers/course_details_provider.dart';
import '../widgets/course_details/top_header.dart';
import '../widgets/course_details/course_hero_card.dart';
import '../widgets/course_details/course_content_section.dart';
import '../widgets/course_details/demo_video_card.dart';
import '../widgets/course_details/course_progress_card.dart';
import '../widgets/course_details/version_history_card.dart';
import '../widgets/course_details/quick_actions_card.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailsScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseDetailsProvider>(context, listen: false).fetchCourseDetails(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseDetailsProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: provider.isLoading && provider.courseData == null
          ? const Center(child: LoadingWidget())
          : provider.courseData == null
              ? const Center(
                  child: Text(
                    'Failed to load course details.',
                    style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                )
              : Column(
                  children: [
                    // Top Header
                    CourseDetailsHeader(
                      courseTitle: provider.courseData!.title,
                      onBack: () => Navigator.of(context).pop(),
                    ),

                    // Main Scrollable Area
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: isDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left column: Hero & Content (70% width)
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        CourseHeroCard(course: provider.courseData!),
                                        const SizedBox(height: 24),
                                        CourseContentSection(course: provider.courseData!),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  // Right column: Sidebar (30% width)
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        const DemoVideoCard(),
                                        const SizedBox(height: 24),
                                        // Calculate total vs published for the progress stats
                                        CourseProgressCard(
                                          totalLessons: provider.courseData!.modules.fold<int>(0, (sum, m) => sum + m.lessons.length),
                                          publishedLessons: provider.courseData!.modules.fold<int>(0, (sum, m) => sum + m.lessons.where((l) => l.status.toLowerCase() == 'published').length),
                                        ),
                                        const SizedBox(height: 24),
                                        VersionHistoryCard(history: provider.versionHistory),
                                        const SizedBox(height: 24),
                                        QuickActionsCard(course: provider.courseData!),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CourseHeroCard(course: provider.courseData!),
                                  const SizedBox(height: 24),
                                  const DemoVideoCard(),
                                  const SizedBox(height: 24),
                                  CourseProgressCard(
                                    totalLessons: provider.courseData!.modules.fold<int>(0, (sum, m) => sum + m.lessons.length),
                                    publishedLessons: provider.courseData!.modules.fold<int>(0, (sum, m) => sum + m.lessons.where((l) => l.status.toLowerCase() == 'published').length),
                                  ),
                                  const SizedBox(height: 24),
                                  CourseContentSection(course: provider.courseData!),
                                  const SizedBox(height: 24),
                                  VersionHistoryCard(history: provider.versionHistory),
                                  const SizedBox(height: 24),
                                  QuickActionsCard(course: provider.courseData!),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
