import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: const Center(
        child: Text('Courses Screen'),
      ),
    );
  }
}