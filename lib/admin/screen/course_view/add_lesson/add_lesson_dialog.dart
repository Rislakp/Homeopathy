import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// ENUM FOR LESSON TYPES
// =============================================================================
enum LessonType { liveClass, video, document, quiz, assignment }

// =============================================================================
// WIDGET: ADD LESSON DIALOG
// =============================================================================
class AddLessonDialog extends StatefulWidget {
  final Function(String module, String title, LessonType type, String? fileName)? onAddLesson;

  const AddLessonDialog({
    super.key,
    this.onAddLesson,
  });

  @override
  State<AddLessonDialog> createState() => _AddLessonDialogState();
}

class _AddLessonDialogState extends State<AddLessonDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  
  String? _selectedModule;
  LessonType _selectedType = LessonType.liveClass; // Default to Live Class with red dot
  String? _selectedFileName;

  // Mock list of modules
  final List<String> _modules = [
    "Module 1 — Introduction to Homeopathy",
    "Module 2 — Materia Medica Foundations",
    "Module 3 — Chronic Miasms & Organon",
    "Module 4 — Case Taking Principles",
    "Module 5 — Repertorization Methodologies",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set default module selection
    _selectedModule ??= _modules.first;

    // Explicit colors based on requirements (bright dashboard style)
    const Color customWhite = Colors.white;
    const Color customGreen = Color(0xFF10B981); // Bright dashboard green
    const Color customDarkText = Color(0xFF1F2937); // Dark text
    const Color customLabelColor = Color(0xFF374151); // Medium label text
    const Color customGreyBorder = Color(0xFFE5E7EB); // Light grey border
    const Color customFieldBg = Color(0xFFF9FAFB); // Off-white field background

    return Dialog(
      backgroundColor: customWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =============================================================
                // 1. HEADER SECTION
                // =============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Lesson",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: customDarkText,
                      ),
                    ),
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        border: Border.all(color: customGreyBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 16),
                        color: Colors.grey.shade600,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: "Dismiss Dialog",
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),

                // =============================================================
                // 2. FORM FIELDS SECTION
                // =============================================================
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // A. Module Dropdown
                        Text(
                          "Module",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: customLabelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedModule,
                          dropdownColor: customWhite,
                          style: GoogleFonts.inter(color: customDarkText, fontSize: 13),
                          decoration: _getInputDecoration(customFieldBg, customGreyBorder),
                          items: _modules.map((modName) {
                            return DropdownMenuItem<String>(
                              value: modName,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: customGreyBorder,
                                      width: 0.8,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        modName,
                                        style: GoogleFonts.inter(
                                          color: customDarkText,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedModule = val;
                            });
                          },
                        ),

                        const SizedBox(height: 18),

                        // B. Lesson Title Input
                        Text(
                          "Lesson Title",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: customLabelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          style: GoogleFonts.inter(color: customDarkText, fontSize: 13),
                          validator: (val) => val == null || val.trim().isEmpty ? "Lesson title is required" : null,
                          decoration: _getInputDecoration(customFieldBg, customGreyBorder).copyWith(
                            hintText: "e.g. Understanding Miasms in Practice",
                            hintStyle: GoogleFonts.inter(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // C. Lesson Type Dropdown (with leading icons)
                        Text(
                          "Lesson Type",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: customLabelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<LessonType>(
                          value: _selectedType,
                          dropdownColor: customWhite,
                          style: GoogleFonts.inter(color: customDarkText, fontSize: 13),
                          decoration: _getInputDecoration(customFieldBg, customGreyBorder),
                          items: [
                            // Live Class (Red circle dot icon)
                            DropdownMenuItem(
                              value: LessonType.liveClass,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text("Live Class", style: GoogleFonts.inter(color: customDarkText)),
                                ],
                              ),
                            ),
                            // Recorded Video (Blue circle dot icon)
                            DropdownMenuItem(
                              value: LessonType.video,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text("Recorded Video", style: GoogleFonts.inter(color: customDarkText)),
                                ],
                              ),
                            ),
                            // PDF Notes (Orange circle dot icon)
                            DropdownMenuItem(
                              value: LessonType.document,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text("PDF Notes", style: GoogleFonts.inter(color: customDarkText)),
                                ],
                              ),
                            ),
                            // Quiz (Green circle dot icon)
                            DropdownMenuItem(
                              value: LessonType.quiz,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text("Quiz Assessment", style: GoogleFonts.inter(color: customDarkText)),
                                ],
                              ),
                            ),
                            // Assignment (Purple circle dot icon)
                            DropdownMenuItem(
                              value: LessonType.assignment,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.purple,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text("Assignment", style: GoogleFonts.inter(color: customDarkText)),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedType = val;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 18),

                        // D. Upload File / Link Field (Custom Container Picker)
                        Text(
                          "Upload File / Link",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: customLabelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFileName = _selectedFileName == null
                                  ? "homeopathy_principles_module1.pdf"
                                  : null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: customFieldBg,
                              border: Border.all(color: customGreyBorder),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "Choose File",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedFileName ?? "No file chosen",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: _selectedFileName == null
                                          ? Colors.grey.shade400
                                          : customDarkText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(color: customGreyBorder, height: 1),
                const SizedBox(height: 20),

                // =============================================================
                // 3. FOOTER / ACTION BUTTONS SECTION
                // =============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: customGreyBorder),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Add Lesson Button (Bright Green Background)
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _selectedModule != null) {
                          if (widget.onAddLesson != null) {
                            widget.onAddLesson!(
                              _selectedModule!,
                              _titleController.text.trim(),
                              _selectedType,
                              _selectedFileName,
                            );
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Lesson added successfully!",
                                style: GoogleFonts.inter(),
                              ),
                              backgroundColor: customGreen,
                              behavior: SnackBarBehavior.floating,
                              width: 300,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customGreen,
                        foregroundColor: customWhite,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        "Add Lesson",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Consistent Input Field Border Style
  InputDecoration _getInputDecoration(Color fieldBg, Color borderColors) {
    return InputDecoration(
      filled: true,
      fillColor: fieldBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColors),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5), // Custom green focus border
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
