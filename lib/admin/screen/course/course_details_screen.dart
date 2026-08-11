import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../models/course_management_model.dart';
import '../../providers/course_management_provider.dart';
import 'widget/top_header.dart';
import 'widget/course_hero_card.dart';
import 'widget/course_content_section.dart';
import 'widget/demo_video_card.dart';
import 'widget/course_progress_card.dart';
import 'widget/version_history_card.dart';
import 'widget/quick_actions_card.dart';

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
      Provider.of<CourseManagementNotifier>(context, listen: false).fetchCourseDetails(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseManagementNotifier>();
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: provider.isLoading && provider.selectedCourseData == null
          ? const Center(child: LoadingWidget())
          : provider.selectedCourseData == null
              ? const Center(
                  child: Text(
                    'Failed to load course details.',
                    style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                )
              : Column(
                  children: [
                    CourseDetailsHeader(
                      courseTitle: provider.selectedCourseData!.title,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: isDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        CourseHeroCard(course: provider.selectedCourseData!),
                                        const SizedBox(height: 24),
                                        CourseContentSection(course: provider.selectedCourseData!),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        const DemoVideoCard(),
                                        const SizedBox(height: 24),
                                        CourseProgressCard(
                                          totalLessons: provider.selectedCourseData!.modules.fold<int>(0, (sum, m) => sum + m.lessons.length),
                                          publishedLessons: provider.selectedCourseData!.modules.fold<int>(0, (sum, m) => sum + m.lessons.where((l) => l.status.toLowerCase() == 'published').length),
                                        ),
                                        const SizedBox(height: 24),
                                        VersionHistoryCard(history: provider.versionHistory),
                                        const SizedBox(height: 24),
                                        QuickActionsCard(course: provider.selectedCourseData!),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CourseHeroCard(course: provider.selectedCourseData!),
                                  const SizedBox(height: 24),
                                  const DemoVideoCard(),
                                  const SizedBox(height: 24),
                                  CourseProgressCard(
                                    totalLessons: provider.selectedCourseData!.modules.fold<int>(0, (sum, m) => sum + m.lessons.length),
                                    publishedLessons: provider.selectedCourseData!.modules.fold<int>(0, (sum, m) => sum + m.lessons.where((l) => l.status.toLowerCase() == 'published').length),
                                  ),
                                  const SizedBox(height: 24),
                                  CourseContentSection(course: provider.selectedCourseData!),
                                  const SizedBox(height: 24),
                                  VersionHistoryCard(history: provider.versionHistory),
                                  const SizedBox(height: 24),
                                  QuickActionsCard(course: provider.selectedCourseData!),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
