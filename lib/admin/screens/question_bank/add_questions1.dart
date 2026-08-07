import 'package:flutter/material.dart';
import 'package:homeopathy/admin/screens/question_bank/mcq_builder/mcq_builder_screen.dart';

class AddQuestionsScreen extends StatefulWidget {
  const AddQuestionsScreen({super.key});

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  // Local controllers for input fields
  late final TextEditingController _titleController;
  late final TextEditingController _marksController;
  late final TextEditingController _timeController;

  // Dropdown States
  String? _selectedCourse = "MBBS Final Year";
  String? _selectedSubject = "Medicine";
  String? _selectedModule = "Cardiology";
  String? _selectedChapter = "Ischemic Heart Disease";
  String? _selectedTopic = "STEMI";
  String? _selectedDifficulty = "Easy";

  // Active step state (can be changed to test inactive states)
  final int _currentActiveStep = 1; // 1-indexed (General Information)

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: "Inferior wall MI — culprit artery identification",
    );
    _marksController = TextEditingController(text: "4");
    _timeController = TextEditingController(text: "90");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _marksController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _showFeedback(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 10, 5, 100),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              final bool isMobile = width < 600;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Section
                  _buildHeader(isMobile),
                  const SizedBox(height: 24),

                  // 2. Stepper Container
                  _buildStepperCard(width),
                  const SizedBox(height: 24),

                  // 3. Form Card Container
                  _buildFormCard(width),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // HEADER BUILDER
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
          style: TextStyle(fontSize: 13.5, color: Color(0xFF667085)),
        ),
      ],
    );

    final actionRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cancel Button
        TextButton(
          onPressed: () {
            _showFeedback("Action cancelled.");
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
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
          onPressed: () {
            _showFeedback("Question saved as draft successfully!");
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
            "Save Draft",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),

        // Publish Question Button
        ElevatedButton(
          onPressed: () {
            _showFeedback("Question published successfully!");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 10, 5, 100),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Publish Question",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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

  // PROGRESS STEPPER CARD
  Widget _buildStepperCard(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: width > 600 ? width - 48 : 550,
          child: Row(
            children: [
              _buildStepItem(1, "General Information"),
              _buildStepDivider(1),
              _buildStepItem(2, "MCQ Builder"),
              _buildStepDivider(2),
              _buildStepItem(3, "Preview"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(int stepNumber, String stepLabel) {
    final bool isActive = _currentActiveStep == stepNumber;
    const Color activeGreen = Color.fromARGB(255, 10, 5, 100);
    const Color inactiveGray = Color(0xFFD9D9D9);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? activeGreen : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? activeGreen : inactiveGray,
              width: 2,
            ),
          ),
          child: Text(
            stepNumber.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : const Color(0xFF667085),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          stepLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? const Color(0xFF172033) : const Color(0xFF667085),
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(int afterStep) {
    final bool isPassed = _currentActiveStep > afterStep;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: isPassed ? const Color.fromARGB(255, 10, 5, 100) : const Color(0xFFE1E7EC),
      ),
    );
  }

  // MAIN FORM CARD CONTAINER
  Widget _buildFormCard(double width) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E7EC)),
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
          // Row 1: Full-width Question Title field
          _buildInputLabel("Question Title"),
          TextField(
            controller: _titleController,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF172033),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE1E7EC)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 10, 5, 100),
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Row 2: Grid fields section
          _buildFormGrid(width),

          const SizedBox(height: 32),

          // Row 3: Continue Button aligned to the left
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const McqBuilderScreen(),
                ),
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormGrid(double width) {
    // 3 columns on Desktop, 2 on Tablet, 1 on Mobile
    int cols = width > 992 ? 3 : (width > 600 ? 2 : 1);

    final List<Widget> gridItems = [
      _buildDropdownField(
        label: "Course",
        value: _selectedCourse,
        items: const ["MBBS Final Year", "BDS", "Nursing (BSc)", "NEET PG"],
        onChanged: (val) => setState(() => _selectedCourse = val),
      ),
      _buildDropdownField(
        label: "Subject",
        value: _selectedSubject,
        items: const ["Medicine", "Surgery"],
        onChanged: (val) => setState(() => _selectedSubject = val),
      ),
      _buildDropdownField(
        label: "Module",
        value: _selectedModule,
        items: const [
          "Cardiology",
          "Neurology",
          "Orthopaedics",
          "ENT",
          "Ophthalmology",
        ],
        onChanged: (val) => setState(() => _selectedModule = val),
      ),
      _buildDropdownField(
        label: "Chapter",
        value: _selectedChapter,
        items: const [
          "Ischemic Heart Disease",
          "Cardiac Arrhythmia",
          "Endocarditis",
          "Valvular Disease",
        ],
        onChanged: (val) => setState(() => _selectedChapter = val),
      ),
      _buildDropdownField(
        label: "Topic",
        value: _selectedTopic,
        items: const ["STEMI", "NSTEMI", "Angina", "Heart Failure"],
        onChanged: (val) => setState(() => _selectedTopic = val),
      ),
      _buildDropdownField(
        label: "Difficulty",
        value: _selectedDifficulty,
        items: const ["Easy", "Medium", "Hard"],
        onChanged: (val) => setState(() => _selectedDifficulty = val),
      ),
      _buildTextField(label: "Marks", controller: _marksController),
      _buildTextField(
        label: "Estimated Time (seconds)",
        controller: _timeController,
      ),
    ];

    if (cols == 1) {
      return Column(
        children: gridItems
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: item,
              ),
            )
            .toList(),
      );
    }

    final List<Widget> rows = [];
    for (int i = 0; i < gridItems.length; i += cols) {
      final List<Widget> rowItems = [];
      for (int j = 0; j < cols; j++) {
        if (i + j < gridItems.length) {
          rowItems.add(Expanded(child: gridItems[i + j]));
        } else {
          rowItems.add(Expanded(child: Container()));
        }
        if (j < cols - 1) {
          rowItems.add(const SizedBox(width: 16));
        }
      }
      rows.add(
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: rowItems),
      );
      if (i + cols < gridItems.length) {
        rows.add(const SizedBox(height: 16));
      }
    }

    return Column(children: rows);
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFF667085),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE1E7EC)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: value,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF172033),
                fontWeight: FontWeight.w500,
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF667085)),
              onChanged: onChanged,
              items: items
                  .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel(label),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 13.5,
            color: Color(0xFF172033),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE1E7EC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF08A653),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
