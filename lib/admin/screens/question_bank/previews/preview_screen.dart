import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  // Device view state
  String _currentView = 'Desktop'; // 'Desktop', 'Tablet', 'Mobile'

  // MCQ Selection State
  int? _selectedOptionIndex;

  final List<String> _options = const [
    "Right coronary artery",
    "Left anterior descending artery",
    "Left circumflex artery",
    "Left main coronary artery",
    "Posterior descending artery",
  ];

  void _showFeedback(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF08A653),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundBg = Color(0xFFF1F8F6);

    return Scaffold(
      backgroundColor: backgroundBg,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable upper content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Header Section + Device view toggles
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // 2. Simulated device preview card
                    Center(
                      child: _buildPreviewCard(),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Fixed bottom navigation bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // HEADER & TOGGLES
  Widget _buildHeader() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;

    final titleCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Student Preview",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Exactly how students will see this question.",
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFF667085),
          ),
        ),
      ],
    );

    final togglesRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDeviceToggle("Desktop", Icons.desktop_windows_outlined),
        const SizedBox(width: 8),
        _buildDeviceToggle("Tablet", Icons.tablet_android_outlined),
        const SizedBox(width: 8),
        _buildDeviceToggle("Mobile", Icons.phone_android_outlined),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleCol,
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: togglesRow,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleCol),
        togglesRow,
      ],
    );
  }

  Widget _buildDeviceToggle(String viewType, IconData icon) {
    final bool isActive = _currentView == viewType;
    const Color green = Color(0xFF08A653);
    const Color lightGreen = Color(0xFFDDF7E8);
    const Color borderCol = Color(0xFFE1E7EC);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentView = viewType;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? lightGreen : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: isActive ? green : borderCol),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: isActive ? green : const Color(0xFF667085)),
              const SizedBox(width: 8),
              Text(
                viewType,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: isActive ? green : const Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MAIN PREVIEW CARD CONTAINER
  Widget _buildPreviewCard() {
    double maxWidth;
    switch (_currentView) {
      case 'Mobile':
        maxWidth = 400.0;
        break;
      case 'Tablet':
        maxWidth = 768.0;
        break;
      case 'Desktop':
      default:
        maxWidth = 1000.0;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header Pills
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF), // Light Blue
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Question 1 of 60",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B82F6), // Blue Text
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED), // Light Orange
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "+4 / -1 · 90s",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEA580C), // Orange/Brown Text
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Question Text
          const Text(
            "A 58-year-old man presents with crushing retrosternal chest pain radiating to the left arm. ECG shows ST elevation in leads II, III and aVF. Which coronary artery is most likely occluded?",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Media Attachment Placeholder
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE1E7EC),
                style: BorderStyle.solid, // solid light gray border matches best
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              "ECG attachment preview",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF98A2B3),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // MCQ Options List
          Column(
            children: List.generate(_options.length, (index) {
              final isSelected = _selectedOptionIndex == index;
              final String letter = String.fromCharCode(65 + index); // A, B, C, D, E

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedOptionIndex = isSelected ? null : index;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFDDF7E8) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF08A653) : const Color(0xFFE1E7EC),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Option Badge Letter
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF08A653) : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : const Color(0xFF667085),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Option text content
                        Expanded(
                          child: Text(
                            _options[index],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF172033),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // BOTTOM NAVIGATION BAR
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE1E7EC)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Outlined Back
          OutlinedButton(
            onPressed: () {
              _showFeedback("Navigated Back.");
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF172033),
              side: const BorderSide(color: Color(0xFFE1E7EC)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "< Back",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),

          // Center: Label
          const Text(
            "Step 4 of 4 · Preview",
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF667085),
            ),
          ),

          // Right: Green Save & Publish
          ElevatedButton(
            onPressed: () {
              _showFeedback("Question saved and published successfully!");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF08A653),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Save & Publish",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
