import 'package:flutter/material.dart';

class ExitExamScreen extends StatelessWidget {
  const ExitExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    
    // Responsive layout design systems
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;
    
    final double horizPadding = isMobile ? 20.0 : 40.0;
    final double bannerVerticalPadding = isMobile ? 36.0 : 50.0;
    final double titleFontSize = isMobile ? 28.0 : 36.0;
    final double subtitleFontSize = isMobile ? 14.0 : 16.0;

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
          "Exit Exam Preparation",
          style: TextStyle(
            color: Color(0xff1B5E20),
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Responsive Hero Banner
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffE8F5E9), Color(0xffC8E6C9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: horizPadding, vertical: bannerVerticalPadding),
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
                        "BHMS Licensing Exit Examination",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "National Exit Exam (Next) Ready",
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff1B5E20),
                        fontFamily: 'Poppins',
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Get your license to practice with confidence. Curated content strictly complying with the National Commission for Homoeopathy syllabus requirements.",
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: const Color(0xff33691E),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2. Responsive Stats Grid (Dynamically calculates height to prevent RenderFlex overflow)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int columns = 1;
                    if (width >= 1024) {
                      columns = 4;
                    } else if (width >= 600) {
                      columns = 2;
                    }

                    const double gap = 16.0;
                    const double desiredCardHeight = 88.0; // stable height fitting content perfectly
                    
                    final double gridWidth = constraints.maxWidth;
                    final double cardWidth = (gridWidth - (gap * (columns - 1))) / columns;
                    final double childAspectRatio = cardWidth / desiredCardHeight;

                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: gap,
                      crossAxisSpacing: gap,
                      childAspectRatio: childAspectRatio,
                      children: [
                        _buildStatCard(Icons.menu_book, "18 Courses", "Intensive Refresher modules"),
                        _buildStatCard(Icons.play_circle_fill, "150+ Lectures", "Clinical-focused classes"),
                        _buildStatCard(Icons.quiz, "80+ Practice Exams", "Topic-wise test series"),
                        _buildStatCard(Icons.people, "6.5k Students", "Licensed homoeopaths-to-be"),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),

              // 3. Syllabus Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizPadding),
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

              // 4. Curriculum Syllabus Tiles
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizPadding),
                child: Column(
                  children: [
                    _buildCurriculumTile(
                      "01",
                      "Clinical Practice & Patient Safety",
                      "Ethical considerations, clinical communication, safety procedures, and differential diagnosis.",
                      "6 Courses",
                      isMobile,
                    ),
                    _buildCurriculumTile(
                      "02",
                      "Therapeutics & Repertory Applications",
                      "Application of repertorial methods to clinical cases, homoeopathic prescribing, and remedy selection.",
                      "8 Courses",
                      isMobile,
                    ),
                    _buildCurriculumTile(
                      "03",
                      "Allied Sciences Overview",
                      "High-yield summaries of internal medicine, surgery, obstetrics & gynecology, and community health.",
                      "4 Courses",
                      isMobile,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xff1B5E20)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
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

  Widget _buildCurriculumTile(String num, String title, String desc, String duration, bool isMobile) {
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
            padding: EdgeInsets.only(
              left: isMobile ? 24.0 : 72.0, 
              right: 24.0, 
              bottom: 20.0,
            ),
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
                  child: const Text("Launch Exam Simulator", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
