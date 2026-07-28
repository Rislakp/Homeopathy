import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';


class FacultySection extends StatelessWidget {
  const FacultySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FacultyProvider>(
      builder: (context, facultyProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Top Faculty" badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
                  ),
                 AppSpacing.w8,
                  const Text(
                    'Top Faculty',
                    style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ),
            AppSpacing.h16,

            // Heading + "Meet all faculty" button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text(
                    "Learn from India's finest\nhomeopathy educators.",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 1.2),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                   
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  label: const Text('Meet all faculty'),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  iconAlignment: IconAlignment.end,
                ),
              ],
            ),
           AppSpacing.h40,

            if (facultyProvider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (facultyProvider.error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
                      Text('Failed to load faculty: ${facultyProvider.error}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => facultyProvider.fetchFaculties(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (facultyProvider.faculties.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Text('No faculty found'),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive column count
                  int crossAxisCount = 4;
                  if (constraints.maxWidth < 900) crossAxisCount = 2;
                  if (constraints.maxWidth < 500) crossAxisCount = 1;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: facultyProvider.faculties.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      return FacultyCard(faculty: facultyProvider.faculties[index]);
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }
}