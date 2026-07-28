import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => StudentDashboardScreenState();
}

class StudentDashboardScreenState extends State<StudentDashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FacultyProvider>().fetchFaculties();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(flex: 5, child: HeroSection()),
                  SizedBox(width: 40),
                  Expanded(flex: 4, child: DemoClassVideo()),
                ],
              ),
              // category
              const SizedBox(height: 80),
              const CategoryScreen(),

              
              const SizedBox(height: 60),
              const SectionHeader(),
              const SizedBox(height: 32),
              Consumer<CourseProvider>(
                builder: (context, courseProvider, child) {
                  if (courseProvider.courses.isEmpty) {
                    return const Text("No courses found");
                  }
                  return SizedBox(
                    height: 460,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: courseProvider.courses.length,
                      itemBuilder: (context, index) {
                        final course = courseProvider.courses[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: CourseCard(course: course),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              LiveClassesSection(),

              const SizedBox(height: 80),
              const FacultySection(),

              const SizedBox(height: 30),
              const JourneySection(),

              // stats
              const SizedBox(height: 80),
              const StatsSection(),
              // pricing section
              const SizedBox(height: 60),
              const PricingSection(),
            ],
          ),
        ),
      ),
    );
  }
}
