import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/question_bank/previews/preview_screen.dart';
import 'widgets/mcq_stepper.dart';

class McqBuilderScreen extends StatefulWidget {
  const McqBuilderScreen({super.key});

  @override
  State<McqBuilderScreen> createState() => _McqBuilderScreenState();
}

class _McqBuilderScreenState extends State<McqBuilderScreen> {
  // Rich question text input controller
  late final TextEditingController _textController;
  String _questionText = "";

  // MCQ Options State
  int? _correctOptionIndex = 0;
  final List<String> _options = const [
    "Right coronary artery",
    "Left anterior descending artery",
    "Left circumflex artery",
    "Left main coronary artery",
    "Posterior descending artery",
  ];

  @override
  void initState() {
    super.initState();
    const defaultText =
        "A 58-year-old man presents with crushing retrosternal chest pain radiating to the left arm. ECG shows ST elevation in leads II, III and aVF. Which coronary artery is most likely occluded?";
    _textController = TextEditingController(text: defaultText);
    _questionText = defaultText;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final bool isDesktop = width > 992; // Tablet landscape & desktop
            final bool isMobile = width < 600;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Row Actions
                  _buildHeader(isMobile),
                  const SizedBox(height: 24),

                  // 2. Progress Stepper
                  McqStepper(parentWidth: width),
                  const SizedBox(height: 24),

                  // 3. Main Content Split-Pane (60% Editor / 40% Live Preview)
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Question Editor (60%)
                        Expanded(
                          flex: 6,
                          child: _buildEditorSection(),
                        ),
                        const SizedBox(width: 24),
                        // Right Column: Live Preview (40%)
                        Expanded(
                          flex: 4,
                          child: _buildLivePreviewSection(),
                        ),
                      ],
                    )
                  else // Stacked vertically on Mobile/Tablet Portrait
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildEditorSection(),
                        const SizedBox(height: 24),
                        _buildLivePreviewSection(),
                      ],
                    ),
                  
                  const SizedBox(height: 32),
                  // 4. Bottom Navigation Action Buttons (Cancel / Continue)
                  _buildBottomNavigation(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // BOTTOM NAVIGATION ACTIONS (Cancel / Continue)
  Widget _buildBottomNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Cancel Button (Navigates back)
        OutlinedButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            } else {
              _showFeedback("No previous screen to navigate back to.");
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF172033),
            side: const BorderSide(color: Color(0xFFE1E7EC)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Right Continue Button (Navigates to next screen)
        ElevatedButton(
          onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PreviewScreen()),
          );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF08A653),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Continue",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // LEFT COLUMN: QUESTION EDITOR SECTION
  Widget _buildEditorSection() {
    const Color borderCol = Color(0xFFE1E7EC);
    const Color labelColor = Color(0xFF667085);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderCol),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Editor Section Label
          const Text(
            "QUESTION EDITOR",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: labelColor,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),

          // Rich Text Toolbar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: borderCol),
                bottom: BorderSide(color: borderCol),
              ),
            ),
            child: Row(
              children: [
                _buildToolbarButton(Icons.format_bold_rounded, "Bold"),
                _buildToolbarButton(Icons.format_italic_rounded, "Italic"),
                _buildToolbarButton(Icons.format_list_bulleted_rounded, "Bullet List"),
                _buildToolbarButton(Icons.functions_rounded, "Math Formula"),
                _buildToolbarButton(Icons.image_outlined, "Insert Image"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Multi-line Question Input
          TextField(
            controller: _textController,
            onChanged: (val) {
              setState(() {
                _questionText = val;
              });
            },
            maxLines: 6,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF172033),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            decoration: const InputDecoration(
              hintText: "Type your question contents here...",
              hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 24),

          // Media Upload Row
          const Text(
            "ATTACH MEDIA",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: labelColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildUploadCard(Icons.image_outlined, "Upload Image"),
                const SizedBox(width: 12),
                _buildUploadCard(Icons.play_circle_outline_rounded, "Upload Diagram"),
                const SizedBox(width: 12),
                _buildUploadCard(Icons.description_outlined, "Upload PDF"),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Options & Correct Answer Section
          const Text(
            "Options & Correct Answer",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 12),

          // Options List
          Column(
            children: List.generate(_options.length, (index) {
              final isCorrect = _correctOptionIndex == index;
              final String letter = String.fromCharCode(65 + index); // A, B, C, D, E

              return _buildOptionEditorTile(index, letter, _options[index], isCorrect);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon, size: 20, color: const Color(0xFF667085)),
      tooltip: tooltip,
      onPressed: () {},
      splashRadius: 18,
    );
  }

  Widget _buildUploadCard(IconData icon, String label) {
    return Container(
      width: 130,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE1E7EC)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: const Color(0xFF667085)),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF172033)),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionEditorTile(int index, String letter, String text, bool isCorrect) {
    const Color green = Color(0xFF08A653);
    const Color lightGreen = Color(0xFFDDF7E8);
    const Color borderCol = Color(0xFFE1E7EC);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _correctOptionIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isCorrect ? lightGreen.withOpacity(0.4) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isCorrect ? green : borderCol,
              width: isCorrect ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Option Letter badge
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCorrect ? green : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.white : const Color(0xFF667085),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Option Content text
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172033),
                  ),
                ),
              ),

              // "Correct" tag indicator
              if (isCorrect)
                const Text(
                  "Correct",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: green,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // RIGHT COLUMN: LIVE PREVIEW SECTION
  Widget _buildLivePreviewSection() {
    const Color labelColor = Color(0xFF667085);
    const Color borderCol = Color(0xFFE1E7EC);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderCol),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live Preview Section Title
          const Text(
            "LIVE PREVIEW",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: labelColor,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 18),

          // Mobile device mock preview card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E7EC)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Question 1",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF667085),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "+4 / -1",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Question Text Area
                Text(
                  _questionText.isEmpty
                      ? "A 58-year-old man presents with crushing retrosternal chest pain..."
                      : _questionText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Pill Shaped Option Buttons
                Column(
                  children: List.generate(_options.length, (index) {
                    final String letter = String.fromCharCode(65 + index); // A, B, C, D, E
                    return _buildPreviewPillButton(letter, _options[index]);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPillButton(String letter, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), // Pill Shape
          border: Border.all(color: const Color(0xFFE1E7EC)),
        ),
        child: Row(
          children: [
            Text(
              "$letter ",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF667085),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF172033),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HEADER BUILDER (DO NOT MODIFY AS PER CONSTRAINTS)
  Widget _buildHeader(bool isMobile) {
    final titleCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add Question",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Create a new question for the White Coat Academy question bank",
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFF667085),
          ),
        ),
      ],
    );

    final actionRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cancel Button
        TextButton(
          onPressed: () => _showFeedback("Cancelled."),
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667085),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Save Draft Button
        OutlinedButton(
          onPressed: () => _showFeedback("Saved as draft!"),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF172033),
            side: const BorderSide(color: Color(0xFFE1E7EC)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Save Draft",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Publish Question Button
        ElevatedButton(
          onPressed: () => _showFeedback("Question published successfully!"),
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
            "Publish Question",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
            child: actionRow,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleCol),
        actionRow,
      ],
    );
  }
}