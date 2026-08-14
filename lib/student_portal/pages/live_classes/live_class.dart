import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class LiveClassesSection extends StatelessWidget {
  LiveClassesSection({super.key});

  final List<LiveSessionData> sessions = [
    LiveSessionData(
      title: "AIAPGET · Organon Marathon",
      instructor: "Dr. Anjali Menon",
      date: "Today, 7:00 PM",
      countdown: "02:14:30",
    ),
    LiveSessionData(
      title: "NEET PG · Pathology Rapid Revision",
      instructor: "Dr. Rakesh Iyer",
      date: "Tomorrow, 6:30 PM",
      countdown: "26:44:10",
    ),
    LiveSessionData(
      title: "Materia Medica · Kent's Repertory",
      instructor: "Dr. Priya Sharma",
      date: "Sat, 5:00 PM",
      countdown: "72:00:00",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top "Live Classes" Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, size: 8, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  "Live Classes",
                  style: GoogleFonts.inter(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Main Header and Subtitle Row
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Learn live from India's top faculty.",
                    style: GoogleFonts.inter(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Interactive sessions, doubt-solving, and recorded playback — all included.",
                    style: GoogleFonts.inter(fontSize: 15, color: AppColors.textSecondary),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "See full schedule",
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.textPrimary),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Horizontal List of Cards
          SizedBox(
            height: 320,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sessions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 24),
              itemBuilder: (_, index) {
                return LiveSessionCard(session: sessions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
