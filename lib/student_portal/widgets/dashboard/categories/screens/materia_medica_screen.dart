import 'package:flutter/material.dart';

class MateriaMedicaScreen extends StatelessWidget {
  const MateriaMedicaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F8F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff2E7D32)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Homoeopathic Materia Medica",
          style: TextStyle(
            color: Color(0xff1B5E20),
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffE8F5E9), Color(0xffC8E6C9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xff2E7D32),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Study of Drugs & Remedy Pictures",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Materia Medica Masterclass",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1B5E20),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Exhaustive lectures covering Kent, Allen's Keynotes, Boericke, Nash's Leaders, and clinical tips for remedy selection in acute and chronic cases.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff33691E),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3.5,
                children: [
                  _buildStatCard(Icons.menu_book, "24 Courses", "Lectures on individual remedies"),
                  _buildStatCard(Icons.play_circle_fill, "200+ Lectures", "Video lectures with slides"),
                  _buildStatCard(Icons.quiz, "40+ Remedy Quizzes", "Interactive drug quizzes"),
                  _buildStatCard(Icons.people, "9.8k Students", "Engrolled practitioners"),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                "Course Syllabus Structure",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1B5E20),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildCurriculumTile(
                    "01",
                    "Polychrest Remedies",
                    "Deep-dive into prominent constitutional remedies: Sulphur, Calcarea Carb, Lycopodium, Pulsatilla, Lachesis, etc.",
                    "10 Courses",
                  ),
                  _buildCurriculumTile(
                    "02",
                    "Allen's Keynotes & Red-line Symptoms",
                    "Important clinical hints, comparative study, and matching matching keynotes for acute prescribing.",
                    "8 Courses",
                  ),
                  _buildCurriculumTile(
                    "03",
                    "Nosodes & Sarcodes",
                    "Specialized class on remedies prepared from diseased tissues and healthy glandular secretions.",
                    "6 Courses",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff2E7D32).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xffE8F5E9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xffE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xff2E7D32), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff1B5E20)),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumTile(String num, String title, String desc, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE8F5E9)),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xffE8F5E9),
          child: Text(
            num,
            style: const TextStyle(color: Color(0xff2E7D32), fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1B5E20)),
        ),
        subtitle: Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 72, right: 24, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(desc, style: const TextStyle(color: Colors.black87, height: 1.4)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2E7D32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Study Materia Medica", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
