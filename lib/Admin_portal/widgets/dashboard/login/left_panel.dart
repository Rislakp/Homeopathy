import 'package:homeopathy/Admin_portal/widgets/common_widgets/App_text.dart';
import 'package:homeopathy/student_portal/widgets/common_widgetts.dart/import.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff07B44C),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: 150,
            left: 180,
            child: Container(
              height: 320,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.06),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 55,
                  vertical: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        const SizedBox(width: 18),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "White Coat Academy",
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),

                            AppText(
                              text: "Homeopathy E-Learning Platform",
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 40),

                    Center(
                      child: Container(
                        height: 220,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.add_circle_outline,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),

                    const Text(
                      "Empowering the next generation of\nHomeopathy practitioners.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Manage students, courses, live classes and payments\nall from one beautifully organized admin workspace.",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
